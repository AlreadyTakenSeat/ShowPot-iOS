//
//  CursorEntity.swift
//  ShowPot
//
//  Created by 김도형 on 4/11/25.
//

import Foundation

struct CursorEntity {
    let cursorId: String?
    let cursorValue: String?
    let size: Int
    
    init(
        cursorId: String?,
        cursorValue: String? = nil,
        size: Int
    ) {
        self.cursorId = cursorId
        self.cursorValue = cursorValue
        self.size = size
    }
}
