//
//  SearchUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/28/24.
//

import RxSwift
import RxCocoa

protocol SearchUseCase {
    
    var artistSearchResult: BehaviorRelay<[FeaturedSubscribeArtistCellModel]> { get }
    var showSearchResult: BehaviorRelay<[PerformanceInfoCollectionViewCellModel]> { get }
    var addSubscribtionresult: PublishSubject<(artistID: String, isSuccess: Bool)> { get set }
    var deleteSubscribtionresult: PublishSubject<(artistID: String, isSuccess: Bool)> { get set }
    
    func searchArtist(search: String, cursor: String?)
    func searchShowList(search: String, cursor: String?)
    func addSubscribtion(artistID: String)
    func deleteSubscribtion(artistID: String)
}
