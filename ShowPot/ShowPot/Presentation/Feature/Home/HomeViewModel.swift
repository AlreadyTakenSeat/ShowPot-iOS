//
//  HomeViewModel.swift
//  ShowPot
//
//  Created by 김도형 on 4/2/25.
//

import Foundation

import Dependencies
import RxCompose
import RxSwift
import RxCocoa

final class HomeViewModel: Composer {
    enum Action {
        case viewDidLoad
        case mutatedGenres(Pageable<GenreEntity>)
        case mutatedArtists(Pageable<ArtistEntity>)
        case mutatedUpcomingShows(Pageable<ShowOpenEntity>)
        case mutatedRecommendedShows(Pageable<ShowOpenEntity>)
        case fetchGenresError
        case fetchArtistsError
        case fetchUpcomingShowsError
        case fetchRecommendedShowsError
    }
    
    struct State {
        var genres = Pageable<GenreEntity>()
        var artists = Pageable<ArtistEntity>(size: 10)
        var upcomingShows = Pageable<ShowOpenEntity>()
        var recommendedShows = Pageable<ShowOpenEntity>()
        @PresentState
        var isGenresLoading: Bool = true
        @PresentState
        var isArtistsLoading: Bool = true
        @PresentState
        var isUpcomingShowsLoading: Bool = true
        @PresentState
        var isRecommendedShowsLoading: Bool = true
    }
    
    var disposeBag = DisposeBag()
    
    @ComposableState
    var state = State()
    var action = PublishRelay<Action>()
    
    @Dependency(HomeUseCase.self)
    private var useCase
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .viewDidLoad:
            return .merge(
                fetchGenres(genres: state.genres),
                fetchArtists(artists: state.artists),
                fetchUpcomingShows(upcomingShows: state.upcomingShows),
                fetchRecommendedShows(recommendedShows: state.recommendedShows)
            )
        case let .mutatedArtists(artists):
            state.artists.cursor = artists.cursor
            state.artists.hasNext = artists.hasNext
            state.artists.size = artists.size
            state.artists.data.append(contentsOf: artists.data)
            state.isArtistsLoading = false
            return .none
        case let .mutatedGenres(genres):
            state.genres.cursor = genres.cursor
            state.genres.hasNext = genres.hasNext
            state.genres.size = genres.size
            state.genres.data.append(contentsOf: genres.data)
            state.isGenresLoading = false
            return .none
        case let .mutatedUpcomingShows(upcomingShows):
            state.upcomingShows.cursor = upcomingShows.cursor
            state.upcomingShows.hasNext = upcomingShows.hasNext
            state.upcomingShows.size = upcomingShows.size
            state.upcomingShows.data.append(contentsOf: upcomingShows.data)
            state.isUpcomingShowsLoading = false
            return .none
        case let .mutatedRecommendedShows(recommendedShows):
            state.recommendedShows.cursor = recommendedShows.cursor
            state.recommendedShows.hasNext = recommendedShows.hasNext
            state.recommendedShows.size = recommendedShows.size
            state.recommendedShows.data.append(contentsOf: recommendedShows.data)
            state.isRecommendedShowsLoading = false
            return .none
        case .fetchGenresError:
            state.isGenresLoading = false
            return .none
        case .fetchArtistsError:
            state.isArtistsLoading = false
            return .none
        case .fetchUpcomingShowsError:
            state.isUpcomingShowsLoading = false
            return .none
        case .fetchRecommendedShowsError:
            state.isRecommendedShowsLoading = false
            return .none
        }
    }
}

// MARK: - Functions
private extension HomeViewModel {
    func fetchGenres(genres: Pageable<GenreEntity>) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            let cursor = CursorEntity(
                cursorId: genres.data.last?.id,
                size: genres.size
            )
            let response = try await useCase.genreList(cursor)
            effect.onNext(.send(.mutatedGenres(response)))
        } catch: { error in
            print(error)
            return .send(.fetchGenresError)
        }
    }
    
    func fetchArtists(artists: Pageable<ArtistEntity>) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            let cursor = CursorEntity(
                cursorId: artists.data.last?.id,
                size: artists.size
            )
            let response = try await useCase.artistList(cursor)
            effect.onNext(.send(.mutatedArtists(response)))
        } catch: { error in
            print(error)
            return .send(.fetchArtistsError)
        }
    }
    
    func fetchUpcomingShows(upcomingShows: Pageable<ShowOpenEntity>) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            let model = ShowListEntity(
                sort: .recent,
                onlyOpenSchedule: false,
                cursorId: upcomingShows.data.last?.id,
                size: 2
            )
            let response = try await useCase.shows(model)
            effect.onNext(.send(.mutatedUpcomingShows(response)))
        } catch: { error in
            print(error)
            return .send(.fetchUpcomingShowsError)
        }
    }
    
    func fetchRecommendedShows(recommendedShows: Pageable<ShowOpenEntity>) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            let model = ShowListEntity(
                sort: .popular,
                onlyOpenSchedule: false,
                cursorId: recommendedShows.data.last?.id,
                size: 10
            )
            let response = try await useCase.shows(model)
            effect.onNext(.send(.mutatedRecommendedShows(response)))
        } catch: { error in
            print(error)
            return .send(.fetchRecommendedShowsError)
        }
    }
}
