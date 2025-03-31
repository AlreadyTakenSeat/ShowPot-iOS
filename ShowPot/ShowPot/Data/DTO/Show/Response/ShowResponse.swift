//
//  ShowSearchResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/30/24.
//

import Foundation

struct ShowResponse: Decodable {
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
            startAt: startAt.toString(.showSearchEntity),
            endAt: endAt.toString(.showSearchEntity),
            location: self.location,
            imageURL: self.imageURL
        )
    }
}

extension ShowResponse {
    static let mock = ShowResponse(
        id: "01937cf9-9c48-4ac9-1c57-8aba45fd4a96",
        title: "Post malone 공연1",
        startAt: "2025-3-9 00:00",
        endAt: "2025-3-9 00:00",
        location: "서울 잠실",
        imageURL: "https://showpot.s3.ap-northeast-2.amazonaws.com/show/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202024-09-10%20%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB%2011.33.52_1732968553281.png"
    )
}
