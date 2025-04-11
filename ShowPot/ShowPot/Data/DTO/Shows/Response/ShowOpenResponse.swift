//
//  SampleResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 5/25/24.
//

import Foundation

// MARK: - Datum
struct ShowOpenResponse: Decodable, Entitiable {
    let id, title, location, posterImageURL, ticketingAt: String
    let isOpen: Bool
}

extension ShowOpenResponse {
    func toEntity() -> ShowOpenEntity {
        let date = self.ticketingAt.toDate(.default) ?? .now
        
        return ShowOpenEntity(
            id: self.id,
            title: self.title,
            location: self.location,
            posterImageURL: self.posterImageURL,
            ticketingAt: self.ticketingAt,
            isOpen: self.isOpen
        )
    }
}
