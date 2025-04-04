//
//  SearchViewModel.swift
//  ShowPot
//
//  Created by 김도형 on 4/4/25.
//

import Foundation

import RxCompose
import RxSwift
import RxCocoa

final class SearchViewModel: Composer {
    enum Action {
        case searchTextFieldOnSubmit(String)
        case clearButtonTapped
        case recentSearchesCollectionViewItemSelected(Int)
        case searchTextFieldButtonTapped
        /// 임시
        case mutatedRecents
    }
    
    struct State {
        var query: String
        @Shared(.userDefaults(.recentQueries))
        var recentQueries = [String]()
        
        var artists: [ArtistEntity] = ArtistResponse.mockList.map { $0.toEntity() }
        var shows: [ShowEntity] = [ShowResponse.mock.toEntity()]
        @PresentState
        var showSearchResult: Bool = false
    }
    
    @ComposableState
    var state: State
    var action = PublishRelay<Action>()
    var disposeBag = DisposeBag()
    
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
            return .send(.mutatedRecents)
        case .clearButtonTapped:
            state.recentQueries?.removeAll()
            return .none
        case .mutatedRecents:
            state.showSearchResult = true
            return .none
        case let .recentSearchesCollectionViewItemSelected(item):
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
        }
    }
}
