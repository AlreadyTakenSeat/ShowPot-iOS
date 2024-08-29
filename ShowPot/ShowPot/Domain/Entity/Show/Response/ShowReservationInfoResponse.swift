//
//  ShowReservationInfoResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/30/24.
//

import Foundation

struct ShowReservationInfoResponse: Codable {
    let alertReservationStatus: AlertReservationStatus
    let alertReservationAvailability: AlertReservationAvailability
}

// MARK: - AlertReservationAvailability
struct AlertReservationAvailability: Codable {
    let canReserve24, canReserve6, canReserve1: Bool
}

// MARK: - AlertReservationStatus
struct AlertReservationStatus: Codable {
    let before24, before6, before1: Bool
}

