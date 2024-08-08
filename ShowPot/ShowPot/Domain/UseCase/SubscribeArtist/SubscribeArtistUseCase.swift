//
//  SubscribeArtistUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/8/24.
//

import Foundation

protocol SubscribeArtistUseCase {
    func fetchArtistList() async throws -> [FeaturedSubscribeArtistCellModel]
    func subscribeArtists(artistID: [String]) async throws -> [String]
}
