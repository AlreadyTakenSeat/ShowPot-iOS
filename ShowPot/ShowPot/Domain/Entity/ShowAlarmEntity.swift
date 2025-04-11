//
//  ShowAlarmEntity.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import Foundation

struct ShowAlarmEntity: Identifiable, Hashable {
    let id: String
    let title: String
    let startAt: String
    let endAt: String
    let location: String
    let imageURL: String
    let ticketingAt: String
    let color: String = TicketColor.allCases.randomElement()?.rawValue ?? ""
}

extension ShowAlarmEntity {
    enum TicketColor: String, CaseIterable {
        case blue
        case green
        case orange
        case yellow
    }
}

extension ShowAlarmEntity {
    static let mock = ShowAlarmEntity(
        id: "01937cf9-9c48-4ac9-1c57-8aba45fd4a96",
        title: "Post malone 공연1",
        startAt: "2025-3-9 00:00",
        endAt: "2025-3-9 00:00",
        location: "서울 잠실",
        imageURL: "https://showpot.s3.ap-northeast-2.amazonaws.com/show/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202024-09-10%20%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB%2011.33.52_1732968553281.png",
        ticketingAt: "2025-3-4 10:04"
    )
    
    func with(title: String, ticketingAt: String) -> ShowAlarmEntity {
        return ShowAlarmEntity(
            id: self.id,
            title: title,
            startAt: self.startAt,
            endAt: self.endAt,
            location: self.location,
            imageURL: self.imageURL,
            ticketingAt: ticketingAt
        )
    }
}
