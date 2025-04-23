//
//  ShowListViewModel.swift
//  ShowPot
//
//  Created by 김도형 on 4/6/25.
//

import Foundation

import Dependencies
import RxCompose
import RxSwift
import RxCocoa

final class ShowListViewModel: Composer {
    enum Action {
        case viewDidLoad
        case prefetchItems([Int])
        case willDisplayCell(Int)
        case mutatedShows(Pageable<ShowEntity>)
        case fetchShowsError
    }
    
    struct State {
        var notifications = Pageable<ShowEntity>()
        var isPaging = false
        @PresentState
        var isLoading: Bool = false
    }
    
    @ComposableState
    var state = State()
    var action = PublishRelay<Action>()
    var disposeBag = DisposeBag()
    
    @Dependency(UserNotificationUseCase.self)
    private var userNotificationUseCase
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .viewDidLoad:
            state.isLoading = true
            return fetchNotificationList(shows: state.notifications)
        case let .prefetchItems(indexes):
            guard
                !state.isPaging && state.notifications.hasNext,
                indexes.contains(where: { state.notifications.size - 2 <= $0 })
            else { return .none }
            state.isPaging = true
            return fetchNotificationList(shows: state.notifications)
        case let .willDisplayCell(index):
            guard
                !state.isPaging && state.notifications.hasNext,
                index >= state.notifications.size - 2
            else { return .none }
            state.isPaging = true
            return fetchNotificationList(shows: state.notifications)
        case let .mutatedShows(shows):
            state.notifications.cursor = shows.cursor
            state.notifications.hasNext = shows.hasNext
            state.notifications.data.append(contentsOf: shows.data)
            state.notifications.size += shows.size
            state.isPaging = false
            state.isLoading = false
            return .none
        case .fetchShowsError:
            state.isLoading = false
            return .none
        }
    }
}

// MARK: - Functions
private extension ShowListViewModel {
    func fetchNotificationList(shows: Pageable<ShowEntity>) -> Observable<Effect<Action>> {
        return .run { [useCase = self.userNotificationUseCase] effect in
            let cursor = CursorEntity(
                cursorId: shows.data.last?.id,
                size: 30
            )
            let response = try await useCase.notificationList(cursor)
            let shows: Pageable<ShowEntity> = Pageable(
                size: response.size,
                hasNext: response.hasNext,
                data: response.data.map { $0.toShowEntity() },
                cursor: Pageable.Cursor(
                    id: response.cursor?.id,
                    value: response.cursor?.value
                )
            )
            effect.onNext(.send(.mutatedShows(shows)))
        } catch: { error in
            return .send(.fetchShowsError)
        }
    }
}
