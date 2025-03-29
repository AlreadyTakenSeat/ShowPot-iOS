//
//  SubscribeArtistResponse.swift
//  ShowPot
//
//  Created by 이건준 on 8/29/24.
//

import Foundation

// MARK: - SubscribeArtistResponse
struct SubscribeArtistResponse: Codable {
    let code: Int
    let message: String
    let data: SubscribeArtistData
}

// MARK: - DataClass
struct SubscribeArtistData: Codable {
    let subscriptionArtistIDS: [SubscriptionArtistID]

    enum CodingKeys: String, CodingKey {
        case subscriptionArtistIDS = "subscriptionArtistIds"
    }
}

// MARK: - SubscriptionArtistID
struct SubscriptionArtistID: Codable {
    let id, artistSpotifyID: String

    enum CodingKeys: String, CodingKey {
        case id
        case artistSpotifyID = "artistSpotifyId"
    }
}

