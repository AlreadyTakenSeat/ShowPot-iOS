//
//  ShowsListRequest.swift
//  ShowPot
//
//  Created by 김도형 on 4/10/25.
//

import Foundation

struct ShowsListRequest: Encodable {
    let sort: String
    let onlyOpenSchedule: Bool
    let cursorId: String?
    let size: Int
}

extension ShowListEntity {
    func toData() -> ShowsListRequest {
        return ShowsListRequest(
            sort: self.sort.rawValue,
            onlyOpenSchedule: self.onlyOpenSchedule,
            cursorId: self.cursorId,
            size: self.size
        )
    }
}
