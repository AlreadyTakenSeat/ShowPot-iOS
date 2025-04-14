//
//  ShowsRepository.swift
//  ShowPot
//
//  Created by 김도형 on 4/11/25.
//

import Foundation

import Dependencies

struct ShowsRepository {
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
    var shows: (
        _ model: ShowListEntity
    ) async throws -> Pageable<ShowOpenEntity>
    var showsDetail: (
        _ showId: String,
        _ deviceToken: String
    ) async throws -> ShowDetailEntity
    var alertReservations: (
        _ showId: String,
        _ ticketingApiType: TicketingTypeEntity
    ) async throws -> [ReservationTimeEntity]
    var terminatedTicketingCount: () async throws -> Int
    var interestsCount: () async throws -> Int
    var alertsCount: () async throws -> Int
    var alertList: (
        _ type: TicketingStateEntity,
        _ cursor: Pageable<ShowAlarmEntity>.Cursor,
        _ size: Int
    ) async throws -> Pageable<ShowAlarmEntity>
    var search: (
        _ search: String,
        _ cursorId: String?,
        _ size: Int
    ) async throws -> Pageable<ShowEntity>
    var interestList: (
        _ cursorId: String?,
        _ cursorValue: String?,
        _ size: Int
    ) async throws -> Pageable<ShowOpenEntity>
}
