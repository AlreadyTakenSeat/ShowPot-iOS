//
//  MyArtistUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/30/24.
//

import RxSwift
import RxCocoa

protocol MyArtistUseCase {
    var artistList: BehaviorRelay<[FeaturedSubscribeArtistCellModel]> { get }
    var subscribeArtistResult: PublishSubject<Bool> { get set }
    var unsubscribedArtistID: PublishSubject<[String]> { get }
    
    func fetchArtistList()
    func unsubscribe(artistID: [String])
}
