//
//  SubscribeArtistResponse.swift
//  ShowPot
//
//  Created by 이건준 on 8/29/24.
//

import Foundation

struct SubscribeArtistResponse: Codable {
    let successSubscriptionArtistIDS: [String]
    
    enum CodingKeys: String, CodingKey {
        case successSubscriptionArtistIDS = "successSubscriptionArtistIds"
    }
}
