//
//  ShowDetailResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/30/24.
//

import Foundation

// MARK: - DataClass
struct ShowDetailResponse: Decodable {
    let id, name, startDate, endDate: String
    let location: String
    let posterImageURL: String
    let isInterested: Bool
    let artists: [Artist]
    let genres: [Genre]
    let ticketingTimes: [TicketingTime]
    let seats: [Seat]
    let ticketingSites: [TicketingSite]
}

extension ShowDetailResponse {
    func toEntity() -> ShowDetailEntity {
        return ShowDetailEntity(
            id: self.id,
            name: self.name,
            startDate: self.startDate,
            endDate: self.endDate,
            location: self.location,
            posterImageURL: self.posterImageURL,
            isInterested: self.isInterested,
            artists: self.artists.map { $0.toEntity() },
            genres: self.genres.map { $0.toEntity() },
            ticketingTimes: self.ticketingTimes.map { $0.toEntity() },
            seats: self.seats.map { $0.toEntity() },
            ticketingSites: self.ticketingSites.map { $0.toEntity() }
        )
    }
}

extension ShowDetailResponse {
    // MARK: - Artist
    struct Artist: Decodable {
        let id, name: String
        let imageURL: String
        
        func toEntity() -> ShowDetailEntity.Artist {
            return ShowDetailEntity.Artist(
                id: self.id,
                name: self.name,
                imageURL: self.imageURL
            )
        }
    }
    
    // MARK: - Genre
    struct Genre: Decodable {
        let id, name: String
        
        func toEntity() -> ShowDetailEntity.Genre {
            return ShowDetailEntity.Genre(
                id: self.id,
                name: self.name
            )
        }
    }
    
    // MARK: - Seat
    struct Seat: Decodable {
        let seatType: String
        let price: Int
        
        func toEntity() -> ShowDetailEntity.Seat {
            return ShowDetailEntity.Seat(
                seatType: self.seatType,
                price: self.price
            )
        }
    }
    
    // MARK: - TicketingSite
    struct TicketingSite: Decodable {
        let name: String
        let link: String
        
        func toEntity() -> ShowDetailEntity.TicketingSite {
            return ShowDetailEntity.TicketingSite(
                name: self.name,
                link: self.link
            )
        }
    }
    
    // MARK: - TicketingTime
    struct TicketingTime: Decodable {
        let ticketingAPIType, ticketingAt: String
        
        enum CodingKeys: String, CodingKey {
            case ticketingAPIType = "ticketingApiType"
            case ticketingAt
        }
        
        func toEntity() -> ShowDetailEntity.TicketingTime {
            return ShowDetailEntity.TicketingTime(
                ticketingAPIType: self.ticketingAPIType,
                ticketingAt: self.ticketingAt
            )
        }
    }
}
