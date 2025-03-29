//
//  UserNotificationExistResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 12/22/24.
//

import Foundation

// MARK: - UserNotificationExistResponse
struct UserNotificationExistResponse: Codable {
    let code: Int
    let message: String
    let data: UserNotificationExistData
}

// MARK: - DataClass
struct UserNotificationExistData: Codable {
    let isExist: Bool
}
