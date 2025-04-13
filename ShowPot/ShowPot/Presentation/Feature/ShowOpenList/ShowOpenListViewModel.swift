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

final class ShowOpenListViewModel: Composer {
    enum Action {
        case filterCheckBoxTapped
        case viewDidLoad
        case mutatedShowOpens(Pageable<ShowOpenEntity>)
        case prefetchItems([Int])
        case willDisplayCell(Int)
    }
    
    struct State {
        var showOpens = Pageable<ShowOpenEntity>()
        var onlyOpenSchedule = false
        var isPaging = false
    }
    
    @ComposableState
    var state = State()
    var action = PublishRelay<Action>()
    var disposeBag = DisposeBag()
    
    @Dependency(ShowOpenListUseCase.self)
    private var useCase
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .filterCheckBoxTapped:
            state.onlyOpenSchedule.toggle()
            state.showOpens = Pageable<ShowOpenEntity>()
            return fetchShows(
                showOpens: state.showOpens,
                onlyOpenSchedule: state.onlyOpenSchedule
            )
        case .viewDidLoad:
            return fetchShows(
                showOpens: state.showOpens,
                onlyOpenSchedule: state.onlyOpenSchedule
            )
        case let .mutatedShowOpens(showOpens):
            state.showOpens.cursor = showOpens.cursor
            state.showOpens.hasNext = showOpens.hasNext
            state.showOpens.data.append(contentsOf: showOpens.data)
            state.showOpens.size += showOpens.size
            state.isPaging = false
            return .none
        case let .prefetchItems(indexes):
            guard
                !state.isPaging && state.showOpens.hasNext,
                indexes.contains(where: { state.showOpens.size - 2 <= $0 })
            else { return .none }
            state.isPaging = true
            return fetchShows(
                showOpens: state.showOpens,
                onlyOpenSchedule: state.onlyOpenSchedule
            )
        case let .willDisplayCell(index):
            guard
                !state.isPaging && state.showOpens.hasNext,
                index >= state.showOpens.size - 2
            else { return .none }
            state.isPaging = true
            return fetchShows(
                showOpens: state.showOpens,
                onlyOpenSchedule: state.onlyOpenSchedule
            )
        }
    }
}

// MARK: - Functions
private extension ShowOpenListViewModel {
    func fetchShows(showOpens: Pageable<ShowOpenEntity>, onlyOpenSchedule: Bool) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            let model = ShowListEntity(
                sort: .recent,
                onlyOpenSchedule: onlyOpenSchedule,
                cursorId: showOpens.data.last?.id,
                size: 30
            )
            let response = try await useCase.shows(model: model)
            effect.onNext(.send(.mutatedShowOpens(response)))
        } catch: { error in
            print(error)
            return .none
        }
    }
}
