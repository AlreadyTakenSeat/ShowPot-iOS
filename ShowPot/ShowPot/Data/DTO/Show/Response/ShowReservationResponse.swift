//
//  ShowReservationResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/30/24.
//

import Foundation

// MARK: - DataClass
struct ShowReservationResponse: Decodable {
    let times: [Time]
}

// MARK: - Time
extension ShowReservationResponse {
    struct Time: Decodable {
        let beforeMinutes: Int
        let isReserved, canReserve: Bool
    }
}

extension ShowReservationResponse {
    func toEntity() -> [ReservationTimeEntity] {
        return times.map { time in
            return ReservationTimeEntity(
                beforeMinutes: time.beforeMinutes,
                isReserved: time.isReserved,
                canReserve: time.canReserve
            )
        }
    }
}
