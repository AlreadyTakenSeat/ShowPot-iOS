//
//  DefaultSubscribeArtistUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/8/24.
//

import Foundation

import RxSwift
import RxRelay

final class DefaultSubscribeArtistUseCase: SubscribeArtistUseCase {
    
    private let apiService: SPArtistAPI
    private let disposeBag = DisposeBag()
    
    var artistList = BehaviorRelay<[FeaturedSubscribeArtistCellModel]>(value: [])
    var subscribeArtistResult = PublishSubject<Bool>()
    
    init(apiService: SPArtistAPI = SPArtistAPI()) {
        self.apiService = apiService
    }
    
    func fetchArtistList() {
        apiService.unsubscriptions(
            request: .init(
                sortStandard: .englishNameAscending,
                artistGenderApiTypes: [],
                artistApiTypes: [],
                genreIds: [],
                cursor: nil,
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
    
    func subscribeArtists(artistID: [String]) {
        apiService.subscribe(artistIDS: artistID)
            .subscribe { response in
                self.subscribeArtistResult.onNext(true)
            } onError: { error in
                self.subscribeArtistResult.onNext(false)
            } 
            .disposed(by: disposeBag)
    }
}
