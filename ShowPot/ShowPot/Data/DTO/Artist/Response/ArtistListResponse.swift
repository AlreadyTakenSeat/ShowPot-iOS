//
//  ArtistListResponse.swift
//  ShowPot
//
//  Created by 이건준 on 8/28/24.
//

import Foundation

// MARK: - ArtistListRespons
struct ArtistListResponse: Codable {
    let code: Int
    let message: String
    let data: ArtistListData
}

// MARK: - DataClass
struct ArtistListData: Codable {
    let size: Int
    let hasNext: Bool
    let data: [ArtistListDataElement]
    let cursor: ArtistListCursor
}

// MARK: - Cursor
struct ArtistListCursor: Codable {
    let id, value: ID
}

// MARK: - ID
struct ID: Codable { }

// MARK: - Datum
struct ArtistListDataElement: Codable {
    let id, imageURL, name: String
}

