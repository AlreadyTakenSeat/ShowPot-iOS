//
//  GenreViewModel.swift
//  ShowPot
//
//  Created by 김도형 on 4/3/25.
//

import Foundation

import Dependencies
import RxCompose
import RxSwift
import RxCocoa

final class GenreViewModel: Composer {
    enum Action {
        case collectionViewItemSelected(Int)
        case mutatedGenres(Pageable<GenreEntity>)
        case mutatedLoginMessage(String)
        case unsubscribeAlertButtonTapped
        case viewDidLoad
        case bottomButtonTapped
        case resetGenreList
        case fetchGenreListError
    }
    
    struct State {
        var genres = Pageable<GenreEntity>()
        @PresentState
        var showSubscribeButton: Bool = false
        var selectedGenres = Set<GenreEntity>()
        @PresentState
        var selectedGenre: GenreEntity?
        @PresentState
        var loginMessage: String?
        @PresentState
        var isLoading: Bool = false
    }
    
    var disposeBag = DisposeBag()
    
    @ComposableState
    var state = State()
    var action = PublishRelay<Action>()
    
    @Dependency(GenreUseCase.self)
    private var useCase
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case let .collectionViewItemSelected(item):
            let genre = state.genres.data[item]
            if genre.isSubscribed {
                state.selectedGenre = genre
                return .none
            }
            
            if state.selectedGenres.remove(genre) == nil {
                state.selectedGenres.insert(genre)
            }
            state.showSubscribeButton = !state.selectedGenres.isEmpty
            return .none
        case let .mutatedGenres(genres):
            state.genres.cursor = genres.cursor
            state.genres.hasNext = genres.hasNext
            state.genres.size += genres.size
            state.genres.data.append(contentsOf: genres.data)
            state.selectedGenre = nil
            state.showSubscribeButton = false
            state.isLoading = false
            return .none
        case let .mutatedLoginMessage(message):
            state.loginMessage = message
            return .none
        case .viewDidLoad:
            state.isLoading = true
            return fetchGenreList(genres: state.genres)
        case .unsubscribeAlertButtonTapped:
            return fetchGenreUnsubscribe(
                genreIds: [state.selectedGenre?.id ?? ""]
            )
        case .bottomButtonTapped:
            let genreIds = state.selectedGenres.map(\.id)
            return fetchGenreSubscribe(genreIds: genreIds)
        case .resetGenreList:
            state.genres = Pageable<GenreEntity>()
            return fetchGenreList(genres: state.genres)
        case .fetchGenreListError:
            state.isLoading = false
            return .none
        }
    }
}

// MARK: - Functions
private extension GenreViewModel {
    func fetchGenreList(genres: Pageable<GenreEntity>) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            let cursor = CursorEntity(
                cursorId: genres.data.last?.id,
                size: 30
            )
            let response = try await useCase.genreList(cursor)
            effect.onNext(.send(.mutatedGenres(response)))
        } catch: { error in
            print(error)
            return .send(.fetchGenreListError)
        }
    }
    
    func fetchGenreUnsubscribe(genreIds: [String]) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            try await useCase.unsubscribe(genreIds)
            effect.onNext(.send(.resetGenreList))
        } catch: { error in
            switch error {
            case SPError.tokenNotFound,
                 SPError.reissueFail:
                return .send(.mutatedLoginMessage("로그인 후 좋아하는\n장르를 구독을 해보세요!"))
            default: return .none
            }
        }
    }
    
    func fetchGenreSubscribe(genreIds: [String]) -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            try await useCase.subscribe(genreIds)
            effect.onNext(.send(.resetGenreList))
        } catch: { error in
            switch error {
            case SPError.tokenNotFound,
                 SPError.reissueFail:
                return .send(.mutatedLoginMessage("로그인 후 좋아하는\n장르를 구독을 해보세요!"))
            default: return .none
            }
        }
    }
}
