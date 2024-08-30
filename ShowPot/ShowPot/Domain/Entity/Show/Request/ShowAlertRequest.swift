//
//  ShowAlertRequest.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/30/24.
//

import Foundation

enum AlertTime: String {
    case before24 = "BEFORE_24"
    case before6 = "BEFORE_6"
    case before1 = "BEFORE_1"
}

struct ShowAlertRequest: Codable {
    let alertTimes: [String]
}
