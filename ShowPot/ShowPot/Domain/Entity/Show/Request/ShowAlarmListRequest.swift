//
//  ShowAlarmListRequest.swift
//  ShowPot
//
//  Created by 이건준 on 8/30/24.
//

import Foundation

struct ShowAlarmListRequest: Codable {
    let size: Int
    let type: ShowTicketingType
    let cursorID: String?
    let cursorValue: String?
    
    enum CodingKeys: String, CodingKey {
        case cursorID = "cursorId"
        case size, type, cursorValue
    }
}

enum ShowTicketingType: String, Codable {
    case terminated = "TERMINATED"
    case continued = "CONTINUED"
}
