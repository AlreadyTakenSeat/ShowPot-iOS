//
//  UserNotificationResponse.swift
//  ShowPot
//
//  Created by 김도형 on 4/11/25.
//

import Foundation

struct UserNotificationResponse: Decodable, Entitiable {
    let title: String
    let message: String
    let notifiedAt: String
    let showId: String
    let showImageURL: String
}

extension UserNotificationResponse {
    func toEntity() -> UserNotificationEntity {
        return UserNotificationEntity(
            title: self.title,
            message: self.message,
            notifiedAt: self.notifiedAt,
            showId: self.showId,
            showImageURL: self.showImageURL
        )
    }
}
