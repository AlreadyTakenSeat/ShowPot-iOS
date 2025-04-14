//
//  CursorReqeust.swift
//  ShowPot
//
//  Created by 김도형 on 4/11/25.
//

import Foundation

struct CursorRequest: Encodable {
    let cursorId: String?
    let cursorValue: String?
    let size: Int
}

extension CursorEntity {
    func toData() -> CursorRequest {
        return CursorRequest(
            cursorId: self.cursorId,
            cursorValue: self.cursorValue,
            size: self.size
        )
    }
}
