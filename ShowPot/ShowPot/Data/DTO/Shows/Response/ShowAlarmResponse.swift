//
//  ShowAlarmResponse.swift
//  ShowPot
//
//  Created by 이건준 on 8/30/24.
//

import Foundation

struct ShowAlarmResponse: Decodable {
    let id: String
    let title: String
    let startAt: String
    let endAt: String
    let location: String
    let imageURL: String
    let ticketingAt: String
}

extension ShowAlarmResponse {
    func toEntity() -> ShowAlarmEntity {
        let date = self.ticketingAt.toDate(.default) ?? .now
        let startAt = self.startAt.toDate(.default) ?? .now
        let endAt = self.endAt.toDate(.default) ?? .now
        
        return ShowAlarmEntity(
            id: self.id,
            title: self.title,
            startAt: startAt.toString(.showEntity),
            endAt: endAt.toString(.showEntity),
            location: self.location,
            imageURL: self.imageURL,
            ticketingAt: date.toString(
                .showOpenEntity,
                identifier: "en_US"
            ).uppercased()
        )
    }
}
