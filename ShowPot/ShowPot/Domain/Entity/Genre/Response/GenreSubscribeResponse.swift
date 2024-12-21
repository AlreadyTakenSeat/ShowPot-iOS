//
//  GenreSubscribeResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/27/24.
//

import Foundation

struct GenreSubscribeResponse: Codable {
    let code: Int
    let message: String
    let data: GenreSubscribeData
}

struct GenreSubscribeData: Codable {
    let successSubscriptionGenreIDS: [String]

    enum CodingKeys: String, CodingKey {
        case successSubscriptionGenreIDS = "successSubscriptionGenreIds"
    }
}
