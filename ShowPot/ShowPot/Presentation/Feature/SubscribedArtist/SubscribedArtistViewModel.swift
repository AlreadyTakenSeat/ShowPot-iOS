//
//  SubscribedArtistViewModel.swift
//  ShowPot
//
//  Created by 김도형 on 4/19/25.
//

import Foundation

import Dependencies
import RxCompose
import RxSwift
import RxCocoa

final class SubscribedArtistViewModel: Composer {
    enum Action {
        case artistDeleteButtonTapped(ArtistEntity)
        case viewDidLoad
        case mutatedArtists(Pageable<ArtistEntity>)
        case prefetchItems([Int])
        case willDisplayCell(Int)
        case subscribeButtonTapped
        case artistViewModel(ArtistViewModel.Action)
        case mutatedLoginMessage(String)
        case viewDidAppear
    }
    
    struct State {
        var artists = Pageable<ArtistEntity>()
        var isPaging = false
        @PresentState
        var artistViewModel: ArtistViewModel?
        @PresentState
        var loginMessage: String?
        @PresentState
        var isLoading: Bool = false
    }
    
    @ComposableState
    var state = State()
    var action = PublishRelay<Action>()
    var disposeBag = DisposeBag()
    
    @Dependency(SubscribedArtistUseCase.self)
    private var useCase
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case let .artistDeleteButtonTapped(artist):
            guard
                let index = state.artists.data.firstIndex(of: artist)
            else { return .none }
            state.artists.data.remove(at: index)
            let artistIds = [artist.id ?? ""]
            return fetchArtistUnsubscribe(artistIds: artistIds)
        case .viewDidLoad:
            state.isLoading = true
            return fetchSubscriptionList(artists: state.artists)
        case let .prefetchItems(indexes):
            guard
                !state.isPaging && state.artists.hasNext,
                indexes.contains(where: { state.artists.size - 2 <= $0 })
            else { return .none }
            state.isPaging = true
            return fetchSubscriptionList(artists: state.artists)
        case let .willDisplayCell(index):
            guard
                !state.isPaging && state.artists.hasNext,
                index >= state.artists.size - 2
            else { return .none }
            state.isPaging = true
            return fetchSubscriptionList(artists: state.artists)
        case let .mutatedArtists(artists):
            state.artists.cursor = artists.cursor
            state.artists.hasNext = artists.hasNext
            state.artists.data.append(contentsOf: artists.data)
            state.artists.size += artists.size
            state.isPaging = false
            state.isLoading = false
            return .none
        case .subscribeButtonTapped:
            let viewModel = ArtistViewModel()
            state.artistViewModel = viewModel
            return .run(viewModel.action.map {
                .artistViewModel($0)
            })
        case .artistViewModel(.delegate(.resetSelection)):
            state.artists = Pageable<ArtistEntity>()
            return fetchSubscriptionList(artists: state.artists)
        case .artistViewModel:
            return .none
        case let .mutatedLoginMessage(message):
            state.loginMessage = message
            return .none
        case .viewDidAppear:
            state.artistViewModel = nil
            return .none
        }
    }
}

// MARK: - Functions
private extension SubscribedArtistViewModel {
    func fetchArtistUnsubscribe(artistIds: [String]) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            try await useCase.unsubscribe(artistIds)
        } catch: { error in
            switch error {
            case SPError.tokenNotFound,
                 SPError.reissueFail:
                return .send(.mutatedLoginMessage("로그인 후 좋아하는\n아티스트 구독을 해보세요!"))
            default: return .none
            }
        }
    }
    
    func fetchSubscriptionList(artists: Pageable<ArtistEntity>) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            let cursor = CursorEntity(
                cursorId: artists.data.last?.id,
                size: 30
            )
            let response = try await useCase.subscriptionList(cursor: cursor)
            effect.onNext(.send(.mutatedArtists(response)))
        } catch: { error in
            print(error)
            return .none
        }
    }
}
