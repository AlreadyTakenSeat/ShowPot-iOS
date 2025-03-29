//
//  GenreListResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/27/24.
//

import Foundation
struct GenreListResponse: Codable {
    let code: Int
    let message: String
    let data: GenreListData
}

// MARK: - GenreListResponse
struct GenreListData: Codable {
    let size: Int
    let hasNext: Bool
    let data: [GenreDataElement]
}

// MARK: - Datum
struct GenreDataElement: Codable {
    let id, name: String
    let isSubscribed: Bool?
}
