//
//  SearchArtistResponse.swift
//  ShowPot
//
//  Created by 이건준 on 8/28/24.
//

import Foundation

// MARK: - SearchArtistResponse
struct SearchArtistResponse: Codable {
    let code: Int
    let message: String
    let data: SearchArtistData
}

// MARK: - DataClass
struct SearchArtistData: Codable {
    let size: Int
    let hasNext: Bool
    let data: [SearchArtistDataElement]
}

// MARK: - Datum
struct SearchArtistDataElement: Codable {
    let id: String?
    let imageURL, name, artistSpotifyID: String
    let isSubscribed: Bool

    enum CodingKeys: String, CodingKey {
        case id, imageURL, name
        case artistSpotifyID = "artistSpotifyId"
        case isSubscribed
    }
}
