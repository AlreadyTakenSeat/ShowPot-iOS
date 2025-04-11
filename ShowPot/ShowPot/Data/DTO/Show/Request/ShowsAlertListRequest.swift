//
//  ShowsAlertListRequest.swift
//  ShowPot
//
//  Created by 김도형 on 4/10/25.
//

import Foundation

struct ShowsAlertListRequest: Encodable {
    let type: String
    let cursorId: String
    let cursorValue: String?
    let size: Int
}
