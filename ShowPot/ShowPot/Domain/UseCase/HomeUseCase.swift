//
//  HomeUseCase.swift
//  ShowPot
//
//  Created by 김도형 on 4/11/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct HomeUseCase {
    var shows: (
        _ model: ShowListEntity
    ) async throws -> Pageable<ShowOpenEntity>
    var genreList: (
        _ cursor: CursorEntity
    ) async throws -> Pageable<GenreEntity>
    var artistList: (
        _ cursor: CursorEntity
    ) async throws -> Pageable<ArtistEntity>
}

extension HomeUseCase: TestDependencyKey {
    static let testValue: HomeUseCase = {
        return HomeUseCase(
            shows: { _ in .mock(ShowOpenEntity.mockList) },
            genreList: { _ in .mock(GenreEntity.mockList) },
            artistList: { _ in .mock(ArtistEntity.mockList) }
        )
    }()
    
    static var previewValue: HomeUseCase = testValue
}
