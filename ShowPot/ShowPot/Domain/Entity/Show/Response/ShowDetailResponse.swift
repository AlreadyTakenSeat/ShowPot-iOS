//
//  ShowDetailResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/30/24.
//

import Foundation

// MARK: - Show
struct ShowDetailResponse: Codable {
    let id, name, startDate, endDate: String
    let location, posterImageURL: String
    let artists: [ShowDetailArtist]
    let genres: [ShowDetailGenre]
    let ticketingTimes: [TicketingTime]
    let seats: [Seat]
    let ticketingSites: [TicketingSite]
}

// MARK: - Artist
struct ShowDetailArtist: Codable {
    let id, koreanName, englishName, imageURL: String
}

// MARK: - Genre
struct ShowDetailGenre: Codable {
    let id, name: String
}

// MARK: - Seat
struct Seat: Codable {
    let seatType: String
    let price: Int
}

// MARK: - TicketingSite
struct TicketingSite: Codable {
    let name, link: String
}

// MARK: - TicketingTime
struct TicketingTime: Codable {
    let ticketingAPIType, ticketingAt: String

    enum CodingKeys: String, CodingKey {
        case ticketingAPIType = "ticketingApiType"
        case ticketingAt
    }
}
