//
//  GenresRepository.swift
//  ShowPot
//
//  Created by 김도형 on 4/11/25.
//

import Foundation

struct GenresRepository {
    var unsubscribe: (
        _ genreIds: [String]
    ) async throws -> Void
    var subscribe: (
        _ genreIds: [String]
    ) async throws -> Void
    var genreList: (
        _ cursor: CursorEntity
    ) async throws -> Pageable<GenreEntity>
    var unsubscriptionList: (
        _ cursor: CursorEntity
    ) async throws -> Pageable<GenreEntity>
    var subscriptionList: (
        _ cursor: CursorEntity
    ) async throws -> Pageable<GenreEntity>
    var subscriptionCount: () async throws -> Int
}
