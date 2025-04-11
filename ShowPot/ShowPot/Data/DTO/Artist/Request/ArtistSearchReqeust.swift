//
//  ArtistSearchReqeust.swift
//  ShowPot
//
//  Created by 김도형 on 4/11/25.
//

import Foundation

struct ArtistSearchReqeust: Encodable {
    let search: String
    let cursorId: String?
    let size: Int
}
