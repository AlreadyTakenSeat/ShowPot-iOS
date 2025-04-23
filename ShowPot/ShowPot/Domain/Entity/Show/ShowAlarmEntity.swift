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
        id: "01966173-f186-07e1-f5c4-47c4c5f4d6a7",
        title: "라우브 내한공연 - 대구 Lauv＇s I Love You, Mean It Tour in Daegu",
        startAt: "2025-5-25 00:00",
        endAt: "2025-5-25 00:00",
        location: "서울 잠실",
        imageURL: "https://showpot.s3.ap-northeast-2.amazonaws.com/show/55c905ee880d4b5daeda4ce1d0b97073_1745392063473.jpg",
        ticketingAt: "2025-4-24 12:00"
    )
    
    static let mockList = [
        ShowAlarmEntity(
            id: "01966173-f186-07e1-f5c4-47c4c5f4d6a7",
            title: "라우브 내한공연 - 대구 Lauv＇s I Love You, Mean It Tour in Daegu",
            startAt: "2025-5-25 00:00",
            endAt: "2025-5-25 00:00",
            location: "서울 잠실",
            imageURL: "https://showpot.s3.ap-northeast-2.amazonaws.com/show/55c905ee880d4b5daeda4ce1d0b97073_1745392063473.jpg",
            ticketingAt: "2025-4-24 12:00"
        ),
        ShowAlarmEntity(
            id: "01942b2a-7596-2900-bddd-4d59a325c2f4",
            title: "콜드플레이 내한공연 LIVE NATION PRESENTS COLDPLAY : MUSIC OF THE SPHERES DELIVERED BY DHL",
            startAt: "2025-4-16 00:00",
            endAt: "2025-4-25 00:00",
            location: "고양종합운동장 주경기장",
            imageURL: "https://showpot.s3.ap-northeast-2.amazonaws.com/show/24013437_p_1735890990349.gif",
            ticketingAt: "2024-8-30 19:00"
        ),
        ShowAlarmEntity(
            id: "01940673-5378-ec87-bc4b-8ad2dc56649f",
            title: "요네즈 켄시 내한공연 KENSHI YONEZU 2025 WORLD TOUR",
            startAt: "2025-3-22 00:00",
            endAt: "2025-3-23 00:00",
            location: "인스파이어 아레나",
            imageURL: "https://showpot.s3.ap-northeast-2.amazonaws.com/show/24014669_p_1735890788643.gif",
            ticketingAt: "2024-10-14 19:11"
        )
    ]
    
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
