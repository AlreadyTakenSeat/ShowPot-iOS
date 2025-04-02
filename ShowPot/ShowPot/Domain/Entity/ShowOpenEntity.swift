//
//  ShowOpenEntity.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import Foundation

struct ShowOpenEntity: Identifiable, Hashable {
    let id, title, location, posterImageURL, ticketingAt: String
    let isOpen: Bool
}
