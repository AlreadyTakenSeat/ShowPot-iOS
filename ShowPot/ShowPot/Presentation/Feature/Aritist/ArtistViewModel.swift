//
//  ArtistViewModel.swift
//  ShowPot
//
//  Created by 김도형 on 4/4/25.
//

import Foundation

import Dependencies
import RxCompose
import RxSwift
import RxCocoa

final class ArtistViewModel: Composer {
    enum Action {
        case collectionViewItemSelected(Int)
        case resetSelection
        case mutatedLoginMessage(String)
        case bottomButtonTapped
        case mutatedArtists(Pageable<ArtistEntity>)
        case viewDidLoad
        case prefetchItems([Int])
        case willDisplayCell(Int)
        case delegate(Delegate)
        
        enum Delegate {
            case resetSelection
        }
    }
    
    struct State {
        var artists = Pageable<ArtistEntity>(size: 0)
        var selectedArtists = Set<ArtistEntity>()
        @PresentState
        var showSubscribeButton: Bool = false
        @PresentState
        var loginMessage: String?
        var isPaging = false
        @PresentState
        var isLoading: Bool = false
    }
    
    var disposeBag = DisposeBag()
    
    @ComposableState
    var state = State()
    var action = PublishRelay<Action>()
    
    @Dependency(ArtistUseCase.self)
    private var useCase
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .delegate: return .none
        case let .collectionViewItemSelected(item):
            let artist = state.artists.data[item]
            if state.selectedArtists.contains(artist) {
                state.selectedArtists.remove(artist)
            } else {
                state.selectedArtists.insert(artist)
            }
            state.showSubscribeButton = !state.selectedArtists.isEmpty
            return .none
        case .resetSelection:
            state.artists.data.removeAll { artist in
                state.selectedArtists.contains(artist)
            }
            state.selectedArtists.removeAll()
            state.showSubscribeButton = false
            return .send(.delegate(.resetSelection))
        case let .mutatedLoginMessage(message):
            state.loginMessage = message
            return .none
        case .bottomButtonTapped:
            let spotifyIds = state.selectedArtists.compactMap(\.spotifyId)
            return fetchArtistSubscribe(spotifiyIds: spotifyIds)
        case let .mutatedArtists(artists):
            state.artists.cursor = artists.cursor
            state.artists.hasNext = artists.hasNext
            state.artists.data.append(contentsOf: artists.data)
            state.artists.size += artists.size
            state.isPaging = false
            state.isLoading = false
            return .none
        case .viewDidLoad:
            state.isLoading = true
            return fetchArtistsUnsubscriptionList(artists: state.artists)
        case let .prefetchItems(indexes):
            guard
                !state.isPaging && state.artists.hasNext,
                indexes.contains(where: { state.artists.size - 2 <= $0 })
            else { return .none }
            state.isPaging = true
            return fetchArtistsUnsubscriptionList(artists: state.artists)
        case let .willDisplayCell(index):
            guard
                !state.isPaging && state.artists.hasNext,
                index >= state.artists.size - 2
            else { return .none }
            state.isPaging = true
            return fetchArtistsUnsubscriptionList(artists: state.artists)
        }
    }
}

// MARK: - Functions
private extension ArtistViewModel {
    func fetchArtistSubscribe(spotifiyIds: [String]) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            try await useCase.subscribe(spotifiyIds)
            effect.onNext(.send(.resetSelection))
        } catch: { error in
            switch error {
            case SPError.tokenNotFound,
                 SPError.reissueFail:
                return .send(.mutatedLoginMessage("로그인 후 좋아하는\n아티스트 구독을 해보세요!"))
            default: return .none
            }
        }
    }
    
    func fetchArtistsUnsubscriptionList(artists: Pageable<ArtistEntity>) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            let cursor = CursorEntity(
                cursorId: artists.data.last?.id,
                size: 30
            )
            let response = try await useCase.unsubscriptionList(cursor: cursor)
            effect.onNext(.send(.mutatedArtists(response)))
        } catch: { error in
            print(error)
            return .none
        }
    }
}
