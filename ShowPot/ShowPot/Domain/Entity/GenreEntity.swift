//
//  GenreEntity.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import Foundation

struct GenreEntity: Identifiable, Hashable {
    let id: String
    let name: Genre?
    let isSubscribed: Bool?
}

extension GenreEntity {
    enum Genre: String {
        case rock
        case hiphop
        case band
        case jpop
        case pop
        case house
        case edm
        case musical
        case rnb
        case opera
        case metal
        case classic
        case jazz
    }
}
