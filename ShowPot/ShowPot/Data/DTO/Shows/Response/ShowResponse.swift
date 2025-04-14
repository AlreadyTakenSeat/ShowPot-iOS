//
//  ShowSearchResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/30/24.
//

import Foundation

struct ShowResponse: Decodable, Entitiable {
    let id, title, startAt, endAt: String
    let location, imageURL: String
}

extension ShowResponse {
    func toEntity() -> ShowEntity {
        let startAt = self.startAt.toDate(.default) ?? .now
        let endAt = self.endAt.toDate(.default) ?? .now
        
        return ShowEntity(
            id: self.id,
            title: self.title,
            startAt: startAt.toString(.showEntity),
            endAt: endAt.toString(.showEntity),
            location: self.location,
            imageURL: self.imageURL
        )
    }
}
