//
//  Pageable.swift
//  ShowPot
//
//  Created by 김도형 on 4/11/25.
//

import Foundation

struct Pageable<T> {
    let size: Int
    let hasNext: Bool
    let data: [T]
    let cursor: Cursor?
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
