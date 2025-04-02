//
//  ArtistEntity.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import Foundation

struct ArtistEntity: Identifiable, Hashable {
    let id, imageURL, name: String
    let isSubscribed: Bool?
}
