//
//  ShowInterestListResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/30/24.
//

import Foundation

struct ShowInterestListResponse: Codable {
    let size: Int
    let hasNext: Bool
    let data: [ShowInterestData]
}

// MARK: - Datum
struct ShowInterestData: Codable {
    let id, interestShowID, interestedAt, title: String
    let startAt, endAt, location, posterImageURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case interestShowID = "interestShowId"
        case interestedAt, title, startAt, endAt, location, posterImageURL
    }
}

