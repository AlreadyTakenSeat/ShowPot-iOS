//
//  DefaultMyArtistUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/30/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DefaultMyArtistUseCase: MyArtistUseCase {
    
    private let apiService: SPArtistAPI
    private let disposeBag = DisposeBag()
    
    var artistList = BehaviorRelay<[FeaturedSubscribeArtistCellModel]>(value: [])
    var subscribeArtistResult = PublishSubject<Bool>()
    var unsubscribedArtistID = PublishSubject<[String]>()
    
    init(apiService: SPArtistAPI = SPArtistAPI()) {
        self.apiService = apiService
    }
    
    func fetchArtistList() {
        apiService.subscriptions(
            request: .init(
                sort: .englishNameAscending,
                cursor: "",
                size: 100
            )
        )
        .subscribe(with: self) { owner, response in
            owner.artistList.accept(response.data.map {
                FeaturedSubscribeArtistCellModel(
                    id: $0.id,
                    state: .none,
                    artistImageURL: URL(string: $0.imageURL),
                    artistName: $0.englishName
                )
            })
        }
        .disposed(by: disposeBag)
    }
    
    func unsubscribe(artistID: [String]) {
        apiService.unsubscribe(artistIDS: artistID)
            .subscribe(with: self) { owner, response in
                owner.unsubscribedArtistID.onNext(response.successUnsubscriptionArtistIDS)
            }
            .disposed(by: disposeBag)
    }
}
