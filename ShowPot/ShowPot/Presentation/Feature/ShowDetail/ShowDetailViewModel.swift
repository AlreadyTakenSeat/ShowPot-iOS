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
    }
    
    struct State {
        let showId: String
        var show: ShowDetailEntity?
        @PresentState
        var alarmSelectionViewModel: AlarmSelectionViewModel?
        @PresentState
        var loginMessage: String?
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
            let viewModel = AlarmSelectionViewModel(
                ticketingTimes: show.ticketingTimes
            )
            state.alarmSelectionViewModel = viewModel
            return .run(viewModel.action.map {
                .alarmSelectionViewModel($0)
            })
        case let .alarmSelectionViewModel(.delegate(.bottomButtonTapped(alertTimes))):
            state.alarmSelectionViewModel = nil
            print(alertTimes)
            return .none
        case .alarmSelectionViewModel:
            return .none
        case .viewDidLoad:
            return fetchShowDetail(id: state.showId)
        case let .mutatedShow(showDetail):
            state.show = showDetail
            return .none
        case let .mutatedIsInterested(isInterested):
            state.show?.isInterested = isInterested
            return .none
        case let .mutatedLoginMessage(message):
            state.loginMessage = message
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
        }
    }
    
    func fetchUninterested(id: String) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            try await useCase.uninterested(id)
            effect.onNext(.send(.mutatedIsInterested(false)))
        } catch: { error in
            print(error)
            guard case SPError.tokenNotFound = error else { return .none }
            return .send(.mutatedLoginMessage("로그인 후 가고싶은 공연의\n관심 설정해보세요!"))
        }
    }
    
    func fetchInterested(id: String) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            try await useCase.interests(id)
            effect.onNext(.send(.mutatedIsInterested(true)))
        } catch: { error in
            print(error)
            guard case SPError.tokenNotFound = error else { return .none }
            return .send(.mutatedLoginMessage("로그인 후 가고싶은 공연의\n관심 설정해보세요!"))
        }
    }
}
