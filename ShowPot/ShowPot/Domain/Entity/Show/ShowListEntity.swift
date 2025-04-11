//
//  ShowListEntity.swift
//  ShowPot
//
//  Created by 김도형 on 4/10/25.
//

import Foundation

struct ShowListEntity {
    let sort: Sort
    let onlyOpenSchedule: Bool
    let cursorId: String?
    let size: Int
}

extension ShowListEntity {
    enum Sort: String {
        case recent = "RECENT"
        case popular = "POPULAR"
    }
}
