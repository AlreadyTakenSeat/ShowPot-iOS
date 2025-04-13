//
//  ArtistUseCase.swift
//  ShowPot
//
//  Created by 김도형 on 4/13/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct ArtistUseCase {
    var subscribe: (
        _ artistIds: [String]
    ) async throws -> Void
    var unsubscriptionList: (
        _ cursor: CursorEntity
    ) async throws -> Pageable<ArtistEntity>
}

extension ArtistUseCase: TestDependencyKey {
    static let testValue: ArtistUseCase = {
        return ArtistUseCase(
            subscribe: { _ in },
            unsubscriptionList: { _ in .mock(ArtistEntity.mockList) }
        )
    }()
}
