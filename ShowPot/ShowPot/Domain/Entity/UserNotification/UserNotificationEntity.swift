//
//  UserNotificationEntity.swift
//  ShowPot
//
//  Created by 김도형 on 4/11/25.
//

import Foundation

struct UserNotificationEntity: Decodable {
    let title: String
    let message: String
    let notifiedAt: String
    let showId: String
    let showImageURL: String
}

extension UserNotificationEntity {
    func toShowEntity() -> ShowEntity {
        return ShowEntity(
            id: UUID().uuidString,
            title: self.title,
            startAt: self.message,
            endAt: "",
            location: self.notifiedAt,
            imageURL: self.showImageURL
        )
    }
}
