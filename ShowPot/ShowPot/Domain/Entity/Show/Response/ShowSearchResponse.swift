//
//  ShowSearchResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/30/24.
//

import Foundation

// MARK: - ShowSearchResponse
struct ShowSearchResponse: Codable {
    let size: Int
    let hasNext: Bool
    let data: [ShowSearchData]
}

// MARK: - ShowSearchData
struct ShowSearchData: Codable {
    let id, title, startAt, endAt: String
    let location, imageURL: String
}
