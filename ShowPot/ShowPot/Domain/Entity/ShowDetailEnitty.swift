//
//  ShowDetailEnitty.swift
//  ShowPot
//
//  Created by 김도형 on 4/4/25.
//

import Foundation

struct ShowDetailEntity: Identifiable, Hashable {
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

extension ShowDetailEntity {
    // MARK: - Artist
    struct Artist: Identifiable, Hashable {
        let id, name: String
        let imageURL: String
    }
    
    // MARK: - Genre
    struct Genre: Identifiable, Hashable {
        let id, name: String
    }
    
    // MARK: - Seat
    struct Seat: Hashable {
        let seatType: String
        let price: Int
    }
    
    // MARK: - TicketingSite
    struct TicketingSite: Hashable {
        let name: String
        let link: String
    }
    
    // MARK: - TicketingTime
    struct TicketingTime: Hashable {
        let ticketingAPIType, ticketingAt: String
    }
}

extension ShowDetailEntity {
    static let mock = ShowDetailEntity(
        id: "01937cf9-9c48-4ac9-1c57-8aba45fd4a96",
        name: "Post malone 공연1",
        startDate: "2025-3-9 00:00",
        endDate: "2025-3-9 00:00",
        location: "서울 잠실",
        posterImageURL: "https://showpot.s3.ap-northeast-2.amazonaws.com/show/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202024-09-10%20%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB%2011.33.52_1732968553281.png",
        isInterested: false,
        artists: [
            ShowDetailEntity.Artist(
                id: "01937cf1-1ddf-9bea-0437-6e1238cf5809",
                name: "Post Malone",
                imageURL: "https://i.scdn.co/image/ab6761610000f178e17c0aa1714a03d62b5ce4e0"
            )
        ],
        genres: [
            ShowDetailEntity.Genre(
                id: "017f20V20d0-4f3c-8f4d-9e15-7ff0c3a876d1",
                name: "band"
            )
        ],
        ticketingTimes: [
            ShowDetailEntity.TicketingTime(
                ticketingAPIType: "NORMAL",
                ticketingAt: "2025-3-4 10:04"
            )
        ],
        seats: [
            ShowDetailEntity.Seat(
                seatType: "스탠딩 S석",
                price: 50000
            ),
            ShowDetailEntity.Seat(
                seatType: "스탠딩 P석",
                price: 30000
            )
        ],
        ticketingSites: [
            ShowDetailEntity.TicketingSite(
                name: "인터파크",
                link: "https://tickets.interpark.com/goods/24011642"
            ),
            ShowDetailEntity.TicketingSite(
                name: "YES24",
                link: "http://ticket.yes24.com/"
            )
        ]
    )
}
