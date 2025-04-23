//
//  SubscribedArtistUseCase.swift
//  ShowPot
//
//  Created by 김도형 on 4/19/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct SubscribedArtistUseCase {
    var unsubscribe: (
        _ artistIds: [String]
    ) async throws -> Void
    var subscriptionList: (
        _ cursor: CursorEntity
    ) async throws -> Pageable<ArtistEntity>
}

extension SubscribedArtistUseCase: TestDependencyKey {
    static let testValue: SubscribedArtistUseCase = {
        return SubscribedArtistUseCase(
            unsubscribe: { _ in },
            subscriptionList: { _ in .mock(ArtistEntity.mockList) }
        )
    }()
    
    static let previewValue: SubscribedArtistUseCase = testValue
}
