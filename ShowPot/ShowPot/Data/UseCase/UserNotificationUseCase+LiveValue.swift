//
//  UserNotificationUseCase+LiveValue.swift
//  ShowPot
//
//  Created by 김도형 on 4/13/25.
//

import Foundation

import Dependencies

extension UserNotificationUseCase: DependencyKey {
    static let liveValue: UserNotificationUseCase = {
        @Dependency(\.usersNotificationsRepository.notificationList)
        var notificationList
        @Dependency(\.usersNotificationsRepository.exist)
        var exist
        
        return UserNotificationUseCase(
            notificationList: notificationList,
            exist: exist
        )
    }()
}
