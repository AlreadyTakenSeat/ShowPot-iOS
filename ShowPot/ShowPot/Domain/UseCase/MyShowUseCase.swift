//
//  MyShowUseCase.swift
//  ShowPot
//
//  Created by 김도형 on 4/13/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct MyShowUseCase {
    var terminatedTicketingCount: () async throws -> Int
    var interestsCount: () async throws -> Int
    var alertsCount: () async throws -> Int
    var alertList: (
        _ type: TicketingStateEntity,
        _ cursor: Pageable<ShowAlarmEntity>.Cursor,
        _ size: Int
    ) async throws -> Pageable<ShowAlarmEntity>
}

extension MyShowUseCase: TestDependencyKey {
    static let testValue: MyShowUseCase = {
        return MyShowUseCase(
            terminatedTicketingCount: { 0 },
            interestsCount: { 0 },
            alertsCount: { 0 },
            alertList: { _, _, _ in .mock([ShowAlarmEntity.mock]) }
        )
    }()
}
