//
//  ShowsInterestListRequest.swift
//  ShowPot
//
//  Created by 김도형 on 4/10/25.
//

import Foundation

struct ShowsInterestListRequest: Encodable {
    let cursorId: String?
    let cursorValue: String?
    let size: Int
}
