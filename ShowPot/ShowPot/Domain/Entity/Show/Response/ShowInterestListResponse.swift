//
//  ShowInterestListResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/30/24.
//

import Foundation

struct ShowInterestListResponse: Codable {
    let code: Int
    let message: String
    let data: ShowInterestListData
}

struct ShowInterestListData: Codable {
    let size: Int
    let hasNext: Bool
    let data: [ShowInterestDataElement]
}

// MARK: - Datum
struct ShowInterestDataElement: Codable {
    let id, interestShowID, interestedAt, title: String
    let startAt, endAt, location, posterImageURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case interestShowID = "interestShowId"
        case interestedAt, title, startAt, endAt, location, posterImageURL
    }
}

