//
//  UserNotificationResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 12/22/24.
//

import Foundation

// MARK: - UserNotificationResponse
struct UserNotificationResponse: Codable {
    let code: Int
    let message: String
    let data: UserNotificationData
}

// MARK: - DataClass
struct UserNotificationData: Codable {
    let size: Int
    let hasNext: Bool
    let data: [UserNotificationDataElement]
    let cursor: UserNotificationCursor
}

// MARK: - Cursor
struct UserNotificationCursor: Codable {
    let id, value: ID
}

// MARK: - ID
struct UserNotificationCursorID: Codable {
}

// MARK: - Datum
struct UserNotificationDataElement: Codable {
    let title, message, notifiedAt, showID: String
    let showImageURL: String

    enum CodingKeys: String, CodingKey {
        case title, message, notifiedAt
        case showID = "showId"
        case showImageURL
    }
}
