//
//  SubscribeArtistUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/8/24.
//

import RxSwift
import RxRelay

protocol SubscribeArtistUseCase {
    
    var artistList: BehaviorRelay<[FeaturedSubscribeArtistCellModel]> { get }
    
    func fetchArtistList()
    func subscribeArtists(artistID: [String]) async throws -> [String]
}
