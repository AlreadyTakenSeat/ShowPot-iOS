//
//  GenreUnsubscribeResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/27/24.
//

import Foundation

struct GenreUnsubscribeResponse: Codable {
    let code: Int
    let message: String
    let data: GenreUnsubscribeData
}

struct GenreUnsubscribeData: Codable {
    let successSubscriptionGenreIDS: [String]

    enum CodingKeys: String, CodingKey {
        case successSubscriptionGenreIDS = "successSubscriptionGenreIds"
    }
}

