//
//  UserNotificationUseCase.swift
//  ShowPot
//
//  Created by 김도형 on 4/13/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct UserNotificationUseCase {
    var notificationList: (
        _ cursor: CursorEntity
    ) async throws -> Pageable<UserNotificationEntity>
    var exist: () async throws -> Bool
}

extension UserNotificationUseCase: TestDependencyKey {
    static let testValue: UserNotificationUseCase = {
        return UserNotificationUseCase(
            notificationList: { _ in .mock([]) },
            exist: { true }
        )
    }()
    
    static var previewValue: UserNotificationUseCase = testValue
}
