//
//  ShowAlertListResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/30/24.
//

import Foundation

// MARK: - Show
struct ShowAlertListResponse: Codable {
    let size: Int
    let hasNext: Bool
    let data: [ShowAlertData]
}

// MARK: - Datum
struct ShowAlertData: Codable {
    let id, title, startAt, endAt: String
    let location, imageURL, cursorID, cursorValue: String

    enum CodingKeys: String, CodingKey {
        case id, title, startAt, endAt, location, imageURL
        case cursorID = "cursorId"
        case cursorValue
    }
}
