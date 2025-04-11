//
//  Pageable.swift
//  ShowPot
//
//  Created by 김도형 on 4/11/25.
//

import Foundation

struct Pageable<T> {
    var size: Int
    var hasNext: Bool
    var data: [T]
    var cursor: Cursor?
    
    init(
        size: Int = 30,
        hasNext: Bool = false,
        data: [T] = [],
        cursor: Cursor? = nil
    ) {
        self.size = size
        self.hasNext = hasNext
        self.data = data
        self.cursor = cursor
    }
}

extension Pageable {
    struct Cursor {
        let id: String
        let value: String?
    }
}

extension Pageable {
    static func mock(_ data: [T]) -> Pageable<T> {
        return Pageable(
            size: 30,
            hasNext: false,
            data: data,
            cursor: Cursor(id: "", value: "")
        )
    }
}
