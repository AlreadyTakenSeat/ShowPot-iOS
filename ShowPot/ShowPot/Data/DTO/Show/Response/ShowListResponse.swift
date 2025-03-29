//
//  SampleResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 5/25/24.
//

import Foundation

struct ShowListResponse: Codable {
    let code: Int
    let message: String
    let data: ShowListData
}

// MARK: - Show
struct ShowListData: Codable {
    let size: Int
    let hasNext: Bool
    let data: [ShowListElement]
}

// MARK: - Datum
struct ShowListElement: Codable {
    let id, title, location, posterImageURL, ticketingAt: String
    let isOpen: Bool
}
