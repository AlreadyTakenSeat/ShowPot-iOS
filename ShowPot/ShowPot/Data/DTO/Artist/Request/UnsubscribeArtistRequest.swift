//
//  UnsubscribeArtistRequest.swift
//  ShowPot
//
//  Created by 이건준 on 8/29/24.
//

import Foundation

struct UnsubscribeArtistRequest: Codable {
    let artistIDS: [String]
    
    enum CodingKeys: String, CodingKey {
        case artistIDS = "artistIds"
    }
}
