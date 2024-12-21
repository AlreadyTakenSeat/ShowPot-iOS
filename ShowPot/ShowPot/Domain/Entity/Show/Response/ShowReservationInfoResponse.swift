//
//  ShowReservationInfoResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/30/24.
//

import Foundation

// MARK: - Welcome
struct ShowReservationInfoResponse: Codable {
    let code: Int
    let message: String
    let data: ShowReservationInfoData
}

// MARK: - DataClass
struct ShowReservationInfoData: Codable {
    let times: [ShowReservationTime]
}

// MARK: - Time
struct ShowReservationTime: Codable {
    let beforeMinutes: Int
    let isReserved, canReserve: Bool
}

