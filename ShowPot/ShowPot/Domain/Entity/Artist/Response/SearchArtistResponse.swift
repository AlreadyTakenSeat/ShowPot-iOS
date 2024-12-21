//
//  SearchArtistResponse.swift
//  ShowPot
//
//  Created by 이건준 on 8/28/24.
//

import Foundation

struct SearchArtistResponse: Codable {
    let code: Int
    let message: String
    let data: SearchArtistData
}

struct SearchArtistData: Codable {
    let size: Int
    let hasNext: Bool
    let data: [SearchArtistDataElement]
}

struct SearchArtistDataElement: Codable {
    let id: String
    let imageURL: String
    let koreanName: String
    let englishName: String
    let isSubscribed: Bool
}
