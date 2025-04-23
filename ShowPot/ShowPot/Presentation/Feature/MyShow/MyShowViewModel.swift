//
//  MyShowViewModel.swift
//  ShowPot
//
//  Created by 김도형 on 4/5/25.
//

import Foundation

import Dependencies
import RxCompose
import RxSwift
import RxCocoa

final class MyShowViewModel: Composer {
    enum Action {
        case viewDidAppear
        case mutatedInterestCount(Int)
        case mutatedShows(Pageable<ShowAlarmEntity>)
        case fetchInterestCountError
        case fetchAlertListError
    }
    
    struct State {
        var shows = Pageable<ShowAlarmEntity>()
        var alertsCount = 0
        var interestCount = 0
        var ticketingCount = 0
        @PresentState
        var isAlertListLoading = true
        @PresentState
        var isInterestCountLoading = true
    }
    
    @ComposableState
    var state = State()
    var action = PublishRelay<Action>()
    var disposeBag = DisposeBag()
    
    @Dependency(MyShowUseCase.self)
    private var useCase
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .viewDidAppear:
            state.shows = Pageable<ShowAlarmEntity>()
            state.isAlertListLoading = true
            state.isInterestCountLoading = true
            return .merge(
                fetchAlertList(shows: state.shows),
                fetchInterestCount()
            )
        case let .mutatedShows(shows):
            state.shows.cursor = shows.cursor
            state.shows.hasNext = shows.hasNext
            state.shows.data.append(contentsOf: shows.data)
            state.shows.size += shows.size
            state.isAlertListLoading = false
            return .none
        case let .mutatedInterestCount(count):
            state.isInterestCountLoading = false
            state.interestCount = count
            return .none
        case .fetchInterestCountError:
            state.isInterestCountLoading = false
            return .none
        case .fetchAlertListError:
            state.isAlertListLoading = false
            return .none
        }
    }
}

// MARK: - Functions
private extension MyShowViewModel {
    func fetchInterestCount() -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            let response = try await useCase.interestsCount()
            effect.onNext(.send(.mutatedInterestCount(response)))
        } catch: { error in
            print(error)
            return .send(.fetchInterestCountError)
        }
    }
    
    func fetchAlertList(shows: Pageable<ShowAlarmEntity>) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            let response = try await useCase.alertList(
                .continued,
                Pageable<ShowAlarmEntity>.Cursor(
                    id: shows.data.last?.id,
                    value: nil
                ),
                30
            )
            effect.onNext(.send(.mutatedShows(response)))
        } catch: { error in
            print(error)
            return .send(.fetchAlertListError)
        }
    }
}
