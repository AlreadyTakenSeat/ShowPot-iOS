//
//  UnsubscribeArtistResponse.swift
//  ShowPot
//
//  Created by 이건준 on 8/29/24.
//

import Foundation

struct UnsubscribeArtistResponse: Codable {
    let code: Int
    let message: String
    let data: UnsubscribeArtistData
}

struct UnsubscribeArtistData: Codable {
    let successUnsubscriptionArtistIDS: [String]
    
    enum CodingKeys: String, CodingKey {
        case successUnsubscriptionArtistIDS = "successUnsubscriptionArtistIds"
    }
}
