//
//  NotificationRepository.swift
//  ShowPot
//
//  Created by 김도형 on 4/9/25.
//

import UIKit
import Combine

struct NotificationRepository {
    var requestAuthorization: (
        _ application: UIApplication
    ) -> Void
    var userInfoPublisher: () -> AnyPublisher<[AnyHashable: Any]?, Never> = {
        .init(Empty())
    }
    var getAuthorizationStatus: () async -> Bool = { false }
}
