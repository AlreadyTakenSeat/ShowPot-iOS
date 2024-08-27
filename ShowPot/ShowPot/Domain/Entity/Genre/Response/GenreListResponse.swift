//
//  GenreListResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/27/24.
//

import Foundation

// MARK: - GenreListResponse
struct GenreListResponse: Codable {
    let size: Int
    let hasNext: Bool
    let data: [GenreData]
}

// MARK: - Datum
struct GenreData: Codable {
    let id, name: String
    let isSubscribed: Bool?
}
