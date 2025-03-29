//
//  ShowDetailResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/30/24.
//

import Foundation

// MARK: - ShowDetailResponse
struct ShowDetailResponse: Codable {
    let code: Int
    let message: String
    let data: ShowDetailData
}

// MARK: - DataClass
struct ShowDetailData: Codable {
    let id, name, startDate, endDate: String
    let location: String
    let posterImageURL: String
    let isInterested: Bool
    let artists: [ShowDetailArtist]
    let genres: [ShowDetailGenre]
    let ticketingTimes: [ShowDetailTicketingTime]
    let seats: [ShowDetailSeat]
    let ticketingSites: [ShowDetailTicketingSite]
}

// MARK: - Artist
struct ShowDetailArtist: Codable {
    let id, name: String
    let imageURL: String
}

// MARK: - Genre
struct ShowDetailGenre: Codable {
    let id, name: String
}

// MARK: - Seat
struct ShowDetailSeat: Codable {
    let seatType: String
    let price: Int
}

// MARK: - TicketingSite
struct ShowDetailTicketingSite: Codable {
    let name: String
    let link: String
}

// MARK: - TicketingTime
struct ShowDetailTicketingTime: Codable {
    let ticketingAPIType, ticketingAt: String

    enum CodingKeys: String, CodingKey {
        case ticketingAPIType = "ticketingApiType"
        case ticketingAt
    }
}
