//
//  SearchViewModel.swift
//  ShowPot
//
//  Created by 김도형 on 4/4/25.
//

import Foundation

import Dependencies
import RxCompose
import RxSwift
import RxCocoa

final class SearchViewModel: Composer {
    enum Action {
        case searchTextFieldOnSubmit(String)
        case clearButtonTapped
        case recentSearchesItemSelected(Int)
        case searchTextFieldButtonTapped
        case recentSearchesCancelButtonTapped(Int)
        case mutatedArtists(Pageable<ArtistEntity>)
        case mutatedShows(Pageable<ShowEntity>)
        case artistCellItemSelected(Int)
        case mutatedLoginMessage(String)
        case mutatedArtistsSubscribe(Int, Bool)
        /// 임시
        case mutatedRecents
    }
    
    struct State {
        var query: String
        @Shared(.userDefaults(.recentQueries))
        var recentQueries = [String]()
        
        var artists = Pageable<ArtistEntity>()
        var shows = Pageable<ShowEntity>()
        @PresentState
        var showSearchResult: Bool = false
        @PresentState
        var loginMessage: String?
    }
    
    @ComposableState
    var state: State
    var action = PublishRelay<Action>()
    var disposeBag = DisposeBag()
    
    @Dependency(SearchUseCase.self)
    private var useCase
    
    init(query: String) {
        self.state = State(query: query)
    }
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case let .searchTextFieldOnSubmit(query):
            state.query = query
            guard !query.filter({ !$0.isWhitespace }).isEmpty else {
                state.showSearchResult = false
                return .none
            }
            state.recentQueries?.append(query)
            state.shows = Pageable<ShowEntity>()
            state.artists = Pageable<ArtistEntity>()
            return .merge(
                .send(.mutatedRecents),
                fetchShowsSearch(shows: state.shows, search: query),
                fetchArtistsSearch(artists: state.artists, search: query)
            )
        case .clearButtonTapped:
            state.recentQueries?.removeAll()
            return .none
        case .mutatedRecents:
            state.showSearchResult = true
            return .none
        case let .recentSearchesItemSelected(item):
            state.query = state.recentQueries?[item] ?? ""
            return .send(.mutatedRecents)
        case .searchTextFieldButtonTapped:
            if !state.query.isEmpty {
                state.query = ""
                state.showSearchResult = false
                return .none
            } else {
                let query = state.query
                state.recentQueries?.append(query)
                return .send(.mutatedRecents)
            }
        case let .recentSearchesCancelButtonTapped(item):
            state.recentQueries?.remove(at: item)
            return .none
        case let .mutatedArtists(artists):
            state.artists.cursor = artists.cursor
            state.artists.hasNext = artists.hasNext
            state.artists.size = artists.size
            state.artists.data.append(contentsOf: artists.data)
            return .none
        case let .mutatedShows(shows):
            state.shows.cursor = shows.cursor
            state.shows.hasNext = shows.hasNext
            state.shows.size = shows.size
            state.shows.data.append(contentsOf: shows.data)
            return .none
        case let .artistCellItemSelected(item):
            if let isSubcribed = state.artists.data[item].isSubscribed, isSubcribed {
                return fetchArtistUnsubscribe(
                    artistId: state.artists.data[item].id ?? "",
                    item: item
                )
            } else if let spotifyId = state.artists.data[item].spotifyId {
                return fetchArtistSubscribe(
                    artistId: spotifyId,
                    item: item
                )
            }
            return .none
        case let .mutatedLoginMessage(message):
            state.loginMessage = message
            return .none
        case let .mutatedArtistsSubscribe(item, isSubscribed):
            state.artists.data[item].isSubscribed = isSubscribed
            return .none
        }
    }
}

// MARK: - Functions
private extension SearchViewModel {
    func fetchArtistsSearch(artists: Pageable<ArtistEntity>, search: String) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            let cursor = CursorEntity(
                cursorId: artists.data.last?.id,
                size: artists.size
            )
            let response = try await useCase.artistsSearch(cursor, search)
            effect.onNext(.send(.mutatedArtists(response)))
        } catch: { error in
            print(#function, error)
            return .none
        }
    }
    
    func fetchShowsSearch(shows: Pageable<ShowEntity>, search: String) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            let response = try await useCase.showsSearch(
                search,
                shows.data.last?.id,
                shows.size
            )
            effect.onNext(.send(.mutatedShows(response)))
        } catch: { error in
            print(#function, error)
            return .none
        }
    }
    
    func fetchArtistSubscribe(artistId: String, item: Int) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            try await useCase.subscribe(genreIds: [artistId])
            effect.onNext(.send(.mutatedArtistsSubscribe(item, true)))
        } catch: { error in
            switch error {
            case SPError.tokenNotFound,
                 SPError.reissueFail:
                return .send(.mutatedLoginMessage("로그인 후 좋아하는\n아티스트 구독을 해보세요!"))
            default: return .none
            }
        }
    }
    
    func fetchArtistUnsubscribe(artistId: String, item: Int) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            try await useCase.unsubscribe(genreIds: [artistId])
            effect.onNext(.send(.mutatedArtistsSubscribe(item, false)))
        } catch: { error in
            switch error {
            case SPError.tokenNotFound,
                 SPError.reissueFail:
                return .send(.mutatedLoginMessage("로그인 후 좋아하는\n아티스트 구독을 해보세요!"))
            default: return .none
            }
        }
    }
}
