//
//  UsersNotificationsRepository+LiveValue.swift
//  ShowPot
//
//  Created by 김도형 on 4/11/25.
//

import Foundation

import Dependencies

extension UsersNotificationsRepository: DependencyKey {
    static let liveValue: UsersNotificationsRepository = {
        let provider = NetworkProvider<UsersNotificationsEndPoint>()
        
        return UsersNotificationsRepository(
            notificationList: { cursor in
                let request = cursor.toData()
                let response: PageDTO<UserNotificationResponse> = try await provider.request(
                    .notificationList(request)
                )
                return response.toEntity()
            },
            exist: {
                let response: UserNotificationExistResponse = try await provider.request(.exist)
                return response.isExist
            }
        )
    }()
}
