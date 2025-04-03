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
    
    static let mockList: [GenreResponse] = [
        GenreResponse(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d1", name: "rock", isSubscribed: false),
        GenreResponse(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d2", name: "hiphop", isSubscribed: false),
        GenreResponse(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d3", name: "band", isSubscribed: false),
        GenreResponse(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d4", name: "jpop", isSubscribed: false),
        GenreResponse(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d5", name: "pop", isSubscribed: false),
        GenreResponse(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d6", name: "house", isSubscribed: false),
        GenreResponse(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d7", name: "edm", isSubscribed: false),
        GenreResponse(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d8", name: "musical", isSubscribed: false),
        GenreResponse(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d9", name: "rnb", isSubscribed: false),
        GenreResponse(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876da", name: "opera", isSubscribed: false),
        GenreResponse(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876db", name: "metal", isSubscribed: false),
        GenreResponse(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876dc", name: "classic", isSubscribed: false),
        GenreResponse(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876dd", name: "jazz", isSubscribed: false)
    ]
}
