//
//  ArtistResponse.swift
//  ShowPot
//
//  Created by 이건준 on 8/28/24.
//

import Foundation

// MARK: - Datum
struct ArtistResponse: Decodable, Entitiable {
    let id: String?
    let imageURL, name, spotifyId: String
    let isSubscribed: Bool?
}

extension ArtistResponse {
    func toEntity() -> ArtistEntity {
        return ArtistEntity(
            id: self.id,
            imageURL: self.imageURL,
            name: self.name,
            spotifyId: self.spotifyId,
            isSubscribed: self.isSubscribed
        )
    }
}
