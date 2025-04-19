//
//  ShowDetailViewModel.swift
//  ShowPot
//
//  Created by 김도형 on 4/4/25.
//

import Foundation

import Dependencies
import RxCompose
import RxSwift
import RxCocoa

final class ShowDetailViewModel: Composer {
    enum Action {
        case favoriteButtonTapped
        case alarmButtonTapped
        case alarmSelectionViewModel(AlarmSelectionViewModel.Action)
        case viewDidLoad
        case mutatedShow(ShowDetailEntity)
        case mutatedIsInterested(Bool)
        case mutatedLoginMessage(String)
        case mutatedReservations([ReservationTimeEntity])
        case mutatedToastMessage(String)
    }
    
    struct State {
        let showId: String
        var show: ShowDetailEntity?
        @PresentState
        var alarmSelectionViewModel: AlarmSelectionViewModel?
        @PresentState
        var loginMessage: String?
        @PresentState
        var toasMessage: String?
        @PresentState
        var isLoading: Bool = false
    }
    
    @ComposableState
    var state: State
    var action = PublishRelay<Action>()
    var disposeBag = DisposeBag()
    
    @Dependency(ShowDetailUseCase.self)
    private var useCase
    
    init(state: State) {
        self.state = state
    }
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .favoriteButtonTapped:
            guard let show = state.show else { return .none }
            return show.isInterested
            ? fetchUninterested(id: show.id)
            : fetchInterested(id: show.id)
        case .alarmButtonTapped:
            guard let show = state.show else { return .none }
            return fetchAlertReservations(id: show.id)
        case let .alarmSelectionViewModel(.delegate(.bottomButtonTapped(alertTimes))):
            state.alarmSelectionViewModel = nil
            print(alertTimes)
            return fetchAlert(id: state.showId, alertTimes: alertTimes.sorted())
        case .alarmSelectionViewModel:
            return .none
        case .viewDidLoad:
            state.isLoading = true
            return fetchShowDetail(id: state.showId)
        case let .mutatedShow(showDetail):
            state.show = showDetail
            state.isLoading = false
            return .none
        case let .mutatedIsInterested(isInterested):
            state.show?.isInterested = isInterested
            return .none
        case let .mutatedLoginMessage(message):
            state.loginMessage = message
            return .none
        case let .mutatedReservations(reservations):
            guard let show = state.show else { return .none }
            var times = ReservationTimeEntity.default
            reservations.enumerated().forEach { index, reservation in
                times[index].isReserved = reservation.isReserved
            }
            let viewModel = AlarmSelectionViewModel(
                state: AlarmSelectionViewModel.State(
                    show: show,
                    times: times
                )
            )
            state.alarmSelectionViewModel = viewModel
            return .run(viewModel.action.map {
                .alarmSelectionViewModel($0)
            })
        case let .mutatedToastMessage(message):
            state.toasMessage = message
            return .none
        }
    }
}

// MARK: - Functions
private extension ShowDetailViewModel {
    func fetchShowDetail(id: String) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            let fcmToken = try await useCase.fetchFCMToken()
            let response = try await useCase.showsDetail(id, fcmToken)
            effect.onNext(.send(.mutatedShow(response)))
        } catch: { error in
            print(error)
            return .none
        }
    }
    
    func fetchUninterested(id: String) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            try await useCase.uninterested(id)
            effect.onNext(.send(.mutatedIsInterested(false)))
        } catch: { error in
            switch error {
            case SPError.tokenNotFound,
                 SPError.reissueFail:
                return .send(.mutatedLoginMessage("로그인 후 가고싶은 공연의\n관심 설정해보세요!"))
            default: return .none
            }
        }
    }
    
    func fetchInterested(id: String) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            try await useCase.interests(id)
            effect.onNext(.send(.mutatedIsInterested(true)))
        } catch: { error in
            switch error {
            case SPError.tokenNotFound,
                 SPError.reissueFail:
                return .send(.mutatedLoginMessage("로그인 후 가고싶은 공연의\n관심 설정해보세요!"))
            default: return .none
            }
        }
    }
    
    func fetchAlertReservations(id: String) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            let response = try await useCase.alertReservations(id, .normal)
            effect.onNext(.send(.mutatedReservations(response)))
        } catch: { error in
            switch error {
            case SPError.tokenNotFound,
                 SPError.reissueFail:
                return .send(.mutatedLoginMessage("로그인 후 가고싶은 공연의\n티켓팅 알림을 설정해보세요!"))
            default: return .none
            }
        }
    }
    
    func fetchAlert(id: String, alertTimes: [String]) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            try await useCase.alert(id, .normal, alertTimes)
            effect.onNext(.send(.mutatedToastMessage("알림 설정이 완료되었습니다")))
        } catch: { error in
            print(error)
            return .none
        }
    }
}
