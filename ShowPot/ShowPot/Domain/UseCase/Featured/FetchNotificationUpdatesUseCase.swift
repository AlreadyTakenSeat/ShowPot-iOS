//
//  FetchNotificationUpdatesUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 9/26/24.
//

import RxCocoa

protocol FetchNotificationUpdatesUseCase {
    var hasNewNotifications: BehaviorRelay<Bool> { get }
    func fetchNotificationUpdates()
}
