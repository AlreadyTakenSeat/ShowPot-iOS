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
    }
    
    struct State {
        var shows = Pageable<ShowAlarmEntity>()
        var alertsCount = 0
        var interestCount = 0
        var ticketingCount = 0
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
            return .merge(
                fetchAlertList(shows: state.shows),
                fetchInterestCount()
            )
        case let .mutatedShows(shows):
            state.shows.cursor = shows.cursor
            state.shows.hasNext = shows.hasNext
            state.shows.data.append(contentsOf: shows.data)
            state.shows.size += shows.size
            return .none
        case let .mutatedInterestCount(count):
            state.interestCount = count
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
            return .none
        }
    }
    
    func fetchAlertList(shows: Pageable<ShowAlarmEntity>) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            let response = try await useCase.alertList(
                type: .continued,
                cursor: Pageable<ShowAlarmEntity>.Cursor(
                    id: shows.data.last?.id,
                    value: nil
                ),
                size: 30
            )
            effect.onNext(.send(.mutatedShows(response)))
        } catch: { error in
            print(error)
            return .none
        }
    }
}
