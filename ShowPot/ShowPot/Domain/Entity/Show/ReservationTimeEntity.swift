//
//  ReservationTimeEntity.swift
//  ShowPot
//
//  Created by 김도형 on 4/10/25.
//

import Foundation

struct ReservationTimeEntity: Identifiable, Hashable {
    let id = UUID()
    let beforeMinutes: Int
    var isReserved: Bool
    var canReserve: Bool
}

extension ReservationTimeEntity {
    static let mockList: [ReservationTimeEntity] = [
        ReservationTimeEntity(
            beforeMinutes: 5,
            isReserved: false,
            canReserve: true
        ),
        ReservationTimeEntity(
            beforeMinutes: 10,
            isReserved: true,
            canReserve: true
        ),
        ReservationTimeEntity(
            beforeMinutes: 30,
            isReserved: true,
            canReserve: false
        ),
        ReservationTimeEntity(
            beforeMinutes: 60,
            isReserved: false,
            canReserve: false
        )
    ]
    
    static let `default`: [ReservationTimeEntity] = [
        ReservationTimeEntity(
            beforeMinutes: 5,
            isReserved: false,
            canReserve: true
        ),
        ReservationTimeEntity(
            beforeMinutes: 10,
            isReserved: false,
            canReserve: true
        ),
        ReservationTimeEntity(
            beforeMinutes: 30,
            isReserved: false,
            canReserve: true
        ),
        ReservationTimeEntity(
            beforeMinutes: 60,
            isReserved: false,
            canReserve: true
        )
    ]
}
