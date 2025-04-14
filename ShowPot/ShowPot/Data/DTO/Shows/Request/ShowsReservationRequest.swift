//
//  ShowsReservationRequest.swift
//  ShowPot
//
//  Created by 김도형 on 4/10/25.
//

import Foundation

struct ShowsReservationRequest: Encodable {
    let showId: String
    let ticketingApiType: String
}
