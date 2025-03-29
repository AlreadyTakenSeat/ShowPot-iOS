//
//  SampleResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 5/25/24.
//

import Foundation

// MARK: - Show
struct Show: Codable {
    let size: Int
    let hasNext: Bool
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let id, title, location, posterImageURL: String
    let reservationAt: String
    let hasTicketingOpenSchedule: Bool
    let viewCount: Int
    let artists: [Artist]
    let genres: [Genre]
    let showTicketingTimes: [ShowTicketingTime]
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
