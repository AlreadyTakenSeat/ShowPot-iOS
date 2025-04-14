//
//  ShowsSearchRequest.swift
//  ShowPot
//
//  Created by 김도형 on 4/10/25.
//

import Foundation

struct ShowsSearchRequest: Encodable {
    let cursorId: String?
    let search: String
    let size: Int
}
