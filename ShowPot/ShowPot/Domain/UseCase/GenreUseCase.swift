//
//  GenreUseCase.swift
//  ShowPot
//
//  Created by 김도형 on 4/13/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct GenreUseCase {
    var unsubscribe: (
        _ genreIds: [String]
    ) async throws -> Void
    var subscribe: (
        _ genreIds: [String]
    ) async throws -> Void
    var genreList: (
        _ cursor: CursorEntity
    ) async throws -> Pageable<GenreEntity>
}

extension GenreUseCase: TestDependencyKey {
    static let testValue: GenreUseCase = {
        return GenreUseCase(
            unsubscribe: { _ in },
            subscribe: { _ in },
            genreList: { _ in .mock(GenreEntity.mockList) }
        )
    }()
    
    static var previewValue: GenreUseCase = testValue
}
