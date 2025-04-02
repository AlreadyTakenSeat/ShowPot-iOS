//
//  ArtistResponse.swift
//  ShowPot
//
//  Created by 이건준 on 8/28/24.
//

import Foundation

// MARK: - Datum
struct ArtistResponse: Decodable {
    let id, imageURL, name: String
    let isSubscribed: Bool?
}

extension ArtistResponse {
    func toEntity() -> ArtistEntity {
        return ArtistEntity(
            id: self.id,
            imageURL: self.imageURL,
            name: self.name,
            isSubscribed: self.isSubscribed
        )
    }
}

extension ArtistResponse {
    static let mock = ArtistResponse(
        id: "01937cf1-1ddf-9bea-0437-6e1238cf5809",
        imageURL: "https://i.scdn.co/image/ab6761610000f178e17c0aa1714a03d62b5ce4e0",
        name: "Post Malone",
        isSubscribed: nil
    )
    
    static let mockAlarm = ArtistResponse(
        id: "01937cf1-1ddf-9bea-0437-6e1238cf5809",
        imageURL: "https://i.scdn.co/image/ab6761610000f178e17c0aa1714a03d62b5ce4e0",
        name: "Post Malone",
        isSubscribed: true
    )
}
