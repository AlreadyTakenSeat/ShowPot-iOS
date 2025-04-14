//
//  ShowsAlertRequest.swift
//  ShowPot
//
//  Created by 김도형 on 4/10/25.
//

import Foundation

struct ShowsAlertRequest: Encodable {
    let showId: String
    let ticketingApiType: String
    let alertTimes: [String]
}
