//
//  ShowSearchResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/30/24.
//

import Foundation

struct ShowSearchResponse: Codable {
    let code: Int
    let message: String
    let data: ShowSearchData
}

// MARK: - ShowSearchResponse
struct ShowSearchData: Codable {
    let size: Int
    let hasNext: Bool
    let data: [ShowSearchDataElement]
}

// MARK: - ShowSearchData
struct ShowSearchDataElement: Codable {
    let id, title, startAt, endAt: String
    let location, imageURL: String
}
