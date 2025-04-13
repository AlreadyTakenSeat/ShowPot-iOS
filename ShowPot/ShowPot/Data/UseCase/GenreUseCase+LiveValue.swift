//
//  GenreUseCase+LiveValue.swift
//  ShowPot
//
//  Created by 김도형 on 4/13/25.
//

import Foundation

import Dependencies

extension GenreUseCase: DependencyKey {
    static let liveValue: GenreUseCase = {
        @Dependency(\.genresRepository.unsubscribe)
        var genresUnsubscribe
        @Dependency(\.genresRepository.subscribe)
        var genresSubscribe
        @Dependency(\.genresRepository.genreList)
        var genresList
        
        return GenreUseCase(
            unsubscribe: genresUnsubscribe,
            subscribe: genresSubscribe,
            genreList: genresList
        )
    }()
}
