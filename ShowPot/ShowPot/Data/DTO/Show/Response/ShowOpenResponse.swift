//
//  SampleResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 5/25/24.
//

import Foundation

// MARK: - Datum
struct ShowOpenResponse: Decodable {
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
            ticketingAt: date.toString(
                .showOpenEntity,
                identifier: "en_US"
            ),
            isOpen: self.isOpen
        )
    }
}

extension ShowOpenResponse {
    static let mock = ShowOpenResponse(
        id: "01937cf9-9c48-4ac9-1c57-8aba45fd4a96",
        title: "Post malone 공연1",
        location: "서울 잠실",
        posterImageURL: "https://showpot.s3.ap-northeast-2.amazonaws.com/show/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202024-09-10%20%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB%2011.33.52_1732968553281.png",
        ticketingAt: "2025-3-4 10:04",
        isOpen: true
    )
}
