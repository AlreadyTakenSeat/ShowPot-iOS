//
//  UnsubscribeArtistListRequest.swift
//  ShowPot
//
//  Created by 이건준 on 8/28/24.
//

import Foundation

struct UnsubscribeArtistListRequest: Codable {
    let sortStandard: SortStandard
    let artistGenderApiTypes: [Gender]
    let artistApiTypes: [ArtistCategory]
    let genreIds: [String]
    let cursor: String?
    let size: Int
}

enum SortStandard: String, Codable {
    case koreanNameAscending = "KOREAN_NAME_ASC"
    case koreanNameDescending = "KOREAN_NAME_DESC"
    case englishNameAscending = "ENGLISH_NAME_ASC"
    case englishNameDescending = "ENGLISH_NAME_DESC"
}

enum Gender: String, Codable {
    case man = "MAN"
    case woman = "WOMAN"
    case mixed = "MIXED"
}

enum ArtistCategory: String, Codable {
    case solo = "SOLO"
    case group = "GROUP"
}
