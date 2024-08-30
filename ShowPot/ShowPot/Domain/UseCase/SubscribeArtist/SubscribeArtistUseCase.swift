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
    var subscribeArtistResult: PublishSubject<Bool> { get set }
    
    func fetchArtistList()
    func subscribeArtists(artistID: [String])
}
