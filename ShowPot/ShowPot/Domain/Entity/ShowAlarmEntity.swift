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
