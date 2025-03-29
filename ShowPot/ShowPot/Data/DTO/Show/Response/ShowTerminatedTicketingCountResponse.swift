//
//  ShowTerminatedTicketingCountResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/30/24.
//

import Foundation

struct ShowTerminatedTicketingCountResponse: Codable {
    let code: Int
    let message: String
    let data: ShowTerminatedTicketingCountData
}

struct ShowTerminatedTicketingCountData: Codable {
    let count: Int
}
