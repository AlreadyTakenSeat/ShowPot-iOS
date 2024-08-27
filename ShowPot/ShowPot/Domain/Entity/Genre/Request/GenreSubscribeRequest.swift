//
//  GenreSubscribeRequest.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/27/24.
//

import Foundation

struct GenreSubscribeRequest: Codable {
    let genreIDS: [String]

    enum CodingKeys: String, CodingKey {
        case genreIDS = "genreIds"
    }
}
