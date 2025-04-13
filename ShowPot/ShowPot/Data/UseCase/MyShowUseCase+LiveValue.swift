//
//  MyShowUseCase+LiveValue.swift
//  ShowPot
//
//  Created by 김도형 on 4/13/25.
//

import Foundation

import Dependencies

extension MyShowUseCase: DependencyKey {
    static let liveValue: MyShowUseCase = {
        @Dependency(\.showsRepository.terminatedTicketingCount)
        var terminatedTicketingCount
        @Dependency(\.showsRepository.interestsCount)
        var interestsCount
        @Dependency(\.showsRepository.alertsCount)
        var alertCount
        @Dependency(\.showsRepository.alertList)
        var alertList
        
        return MyShowUseCase(
            terminatedTicketingCount: terminatedTicketingCount,
            interestsCount: interestsCount,
            alertsCount: alertCount,
            alertList: alertList
        )
    }()
}
