//
//  SubscribeArtistListRequest.swift
//  ShowPot
//
//  Created by 이건준 on 8/29/24.
//

import Foundation

struct SubscribeArtistListRequest: Codable {
    let sort: SortStandard
    let cursor: String
    let size: Int
}
