//
//  GenreResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/27/24.
//

import Foundation

struct GenreResponse: Codable {
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

extension GenreResponse {
    static let mock = GenreResponse(
        id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d1",
        name: "rock",
        isSubscribed: nil
    )
    
    static let mockAlarm = GenreResponse(
        id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d1",
        name: "rock",
        isSubscribed: true
    )
}
