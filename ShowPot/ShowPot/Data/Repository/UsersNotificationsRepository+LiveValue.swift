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
                let response: DTO<PageResponse<UserNotificationResponse>>
                response = try await provider.request(
                    .notificationList(request)
                )
                return response.data.toEntity()
            },
            exist: {
                let response: DTO<UserNotificationExistResponse>
                response = try await provider.request(.exist)
                return response.data.isExist
            }
        )
    }()
}
