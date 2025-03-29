//
//  ShowAlarmListResponse.swift
//  ShowPot
//
//  Created by 이건준 on 8/30/24.
//

import Foundation

struct ShowAlarmListResponse: Codable {
    let size: Int
      let hasNext: Bool
      let data: [ShowAlarmData]
}

struct ShowAlarmData: Codable {
    let id: String
    let title: String
    let startAt: String
    let endAt: String
    let location: String
    let imageURL: String
    let cursorID: String
    let ticketingAt: String
    
    enum CodingKeys: String, CodingKey {
        case cursorID = "cursorId"
        case ticketingAt = "cursorValue"
        case id, title, startAt, endAt, location, imageURL
    }
}
