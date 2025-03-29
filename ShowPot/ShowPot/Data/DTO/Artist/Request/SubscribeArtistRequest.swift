//
//  SubscribeArtistRequest.swift
//  ShowPot
//
//  Created by 이건준 on 8/29/24.
//

import Foundation

struct SubscribeArtistRequest: Codable {
    let artistIDS: [String]
    
    enum CodingKeys: String, CodingKey {
        case artistIDS = "spotifyArtistIds"
    }
}
