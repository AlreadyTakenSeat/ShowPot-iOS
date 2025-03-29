//
//  SearchShowResponse.swift
//  ShowPot
//
//  Created by 이건준 on 8/28/24.
//

import Foundation

struct SearchShowResponse: Codable {
    let code: Int
    let message: String
    let data: SearchShowData
}

struct SearchShowData: Codable {
    let size: Int
    let hasNext: Bool
    let data: [SearchShowDataElement]
}

struct SearchShowDataElement: Codable {
    let id: String
    let title: String
    let startAt: String
    let endAt: String
    let location: String
    let imageURL: String
}
