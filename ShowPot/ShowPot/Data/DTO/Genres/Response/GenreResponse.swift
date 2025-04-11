//
//  GenreResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/27/24.
//

import Foundation

struct GenreResponse: Decodable, Entitiable {
    let id, name: String
    let isSubscribed: Bool?
}

extension GenreResponse {
    func toEntity() -> GenreEntity {
        return GenreEntity(
            id: self.id,
            name: GenreEntity.Genre(rawValue: self.name),
            isSubscribed: self.isSubscribed
        )
    }
}
