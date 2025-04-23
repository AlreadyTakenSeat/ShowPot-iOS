//
//  ShowDetailUseCase.swift
//  ShowPot
//
//  Created by 김도형 on 4/12/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct ShowDetailUseCase {
    var showsDetail: (
        _ showId: String,
        _ deviceToken: String
    ) async throws -> ShowDetailEntity
    var alertReservations: (
        _ showId: String,
        _ ticketingApiType: TicketingTypeEntity
    ) async throws -> [ReservationTimeEntity]
    var uninterested: (
        _ showId: String
    ) async throws -> Void
    var interests: (
        _ showId: String
    ) async throws -> Void
    var alert: (
        _ showId: String,
        _ ticketingApiType: TicketingTypeEntity,
        _ alertTimes: [String]
    ) async throws -> Void
    var fetchFCMToken: () async throws -> String
}

extension ShowDetailUseCase: TestDependencyKey {
    static let testValue: ShowDetailUseCase = {
        return ShowDetailUseCase(
            showsDetail: { _, _ in .mock },
            alertReservations: { _, _ in ReservationTimeEntity.mockList },
            uninterested: { _ in },
            interests: { _ in },
            alert: { _, _, _ in },
            fetchFCMToken: { "" }
        )
    }()
    
    static var previewValue: ShowDetailUseCase = testValue
}
