//
//  SampleResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 5/25/24.
//

import Foundation

// MARK: - Show
struct ShowListResponse: Codable {
    let size: Int
    let hasNext: Bool
    let data: [ShowListData]
}

// MARK: - Datum
struct ShowListData: Codable {
    let id, title, location, posterImageURL, ticketingAt: String
    let isOpen: Bool
}

// MARK: - Artist
struct Artist: Codable {
    let id, koreanName, englishName, imageURL: String
}

// MARK: - Genre
struct Genre: Codable {
    let id, name: String
}

// MARK: - ShowTicketingTime
struct ShowTicketingTime: Codable {
    let ticketingType, ticketingAt: String
}
