//
//  SearchUseCase+LiveValue.swift
//  ShowPot
//
//  Created by 김도형 on 4/12/25.
//

import Foundation

import Dependencies

extension SearchUseCase: DependencyKey {
    static let liveValue: SearchUseCase = {
        @Dependency(\.artistsRepository.search)
        var artistsSearch
        @Dependency(\.artistsRepository.subscribe)
        var artistsSubscribe
        @Dependency(\.artistsRepository.unsubscribe)
        var artistsUnsubscribe
        @Dependency(\.showsRepository.search)
        var showsSearch
        
        return SearchUseCase(
            artistsSearch: artistsSearch,
            showsSearch: showsSearch,
            unsubscribe: artistsUnsubscribe,
            subscribe: artistsSubscribe
        )
    }()
}
