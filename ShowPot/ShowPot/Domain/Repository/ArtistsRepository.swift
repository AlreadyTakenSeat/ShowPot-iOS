//
//  ArtistsRepository.swift
//  ShowPot
//
//  Created by 김도형 on 4/11/25.
//

import Foundation

struct ArtistsRepository {
    var unsubscribe: (
        _ genreIds: [String]
    ) async throws -> Void
    var subscribe: (
        _ genreIds: [String]
    ) async throws -> Void
    var unsubscriptionList: (
        _ cursor: CursorEntity
    ) async throws -> Pageable<ArtistEntity>
    var subscriptionList: (
        _ cursor: CursorEntity
    ) async throws -> Pageable<ArtistEntity>
    var subscriptionCount: () async throws -> Int
    var search: (
        _ cursor: CursorEntity,
        _ search: String
    ) async throws -> Pageable<ArtistEntity>
}
