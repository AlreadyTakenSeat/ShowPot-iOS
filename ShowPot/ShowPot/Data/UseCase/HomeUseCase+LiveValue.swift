//
//  HomeUseCase+LiveValue.swift
//  ShowPot
//
//  Created by 김도형 on 4/11/25.
//

import Foundation

import Dependencies

extension HomeUseCase: DependencyKey {
    static let liveValue: HomeUseCase = {
        @Dependency(\.showsRepository.shows)
        var shows
        @Dependency(\.genresRepository.genreList)
        var genreList
        @Dependency(\.artistsRepository.unsubscriptionList)
        var unsubscriptionList
        
        return HomeUseCase(
            shows: shows,
            genreList: genreList,
            artistList: unsubscriptionList
        )
    }()
}
