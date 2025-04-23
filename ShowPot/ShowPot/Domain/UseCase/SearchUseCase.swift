//
//  SearchUseCase.swift
//  ShowPot
//
//  Created by 김도형 on 4/12/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct SearchUseCase {
    var artistsSearch: (
        _ cursor: CursorEntity,
        _ search: String
    ) async throws -> Pageable<ArtistEntity>
    var showsSearch: (
        _ search: String,
        _ cursorId: String?,
        _ size: Int
    ) async throws -> Pageable<ShowEntity>
    var unsubscribe: (
        _ genreIds: [String]
    ) async throws -> Void
    var subscribe: (
        _ genreIds: [String]
    ) async throws -> Void
}

extension SearchUseCase: TestDependencyKey {
    static let testValue: SearchUseCase = {
        return SearchUseCase(
            artistsSearch: { _, _ in .mock(ArtistEntity.mockList) },
            showsSearch: { _, _, _ in .mock(ShowEntity.mockList) },
            unsubscribe: { _ in },
            subscribe: { _ in }
        )
    }()
    
    static var previewValue: SearchUseCase = testValue
}
