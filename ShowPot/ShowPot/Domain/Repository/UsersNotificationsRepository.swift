//
//  UsersNotificationsRepository.swift
//  ShowPot
//
//  Created by 김도형 on 4/11/25.
//

import Foundation

struct UsersNotificationsRepository {
    var notificationList: (
        _ cursor: CursorEntity
    ) async throws -> Pageable<UserNotificationEntity>
    var exist: () async throws -> Bool
}
