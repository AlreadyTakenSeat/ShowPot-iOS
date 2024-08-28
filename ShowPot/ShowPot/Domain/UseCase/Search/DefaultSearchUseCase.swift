//
//  DefaultSearchUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DefaultSearchUseCase: SearchUseCase {
    
    private let apiService: SPSearchAPI
    private let disposeBag = DisposeBag()
    
    var artistSearchResult = BehaviorRelay<[FeaturedSubscribeArtistCellModel]>(value: [])
    var showSearchResult = BehaviorRelay<[PerformanceInfoCollectionViewCellModel]>(value: [])
    var addSubscribtionresult = PublishSubject<(artistID: String, isSuccess: Bool)>()
    var deleteSubscribtionresult = PublishSubject<(artistID: String, isSuccess: Bool)>()
    
    init(apiService: SPSearchAPI = SPSearchAPI()) {
        self.apiService = apiService
    }
    
    func addSubscribtion(artistID: String) {
        apiService.subscribe(artistIDS: [artistID])
            .subscribe { response in
                self.addSubscribtionresult.onNext((artistID, true))
            } onError: { error in
                self.addSubscribtionresult.onNext((artistID, false))
            }
            .disposed(by: disposeBag)
    }
    
    func deleteSubscribtion(artistID: String) {
        apiService.unsubscribe(artistIDS: [artistID])
            .subscribe { response in
                self.deleteSubscribtionresult.onNext((artistID, true))
            } onError: { error in
                self.deleteSubscribtionresult.onNext((artistID, false))
            }
            .disposed(by: disposeBag)
    }
    
    func searchArtist(search: String, cursor: String?) {
        apiService.searchArtist(
            request: .init(
                sortStandard: .englishNameAscending,
                cursor: cursor,
                size: 100,
                search: search
            )
        )
        .subscribe(with: self) { owner, response in
            owner.artistSearchResult.accept(response.data.map {
                FeaturedSubscribeArtistCellModel(
                    id: $0.id, 
                    state: $0.isSubscribed ? .subscription : .availableSubscription,
                    artistImageURL: URL(string: $0.imageURL),
                    artistName: $0.englishName
                )
            })
        }
        .disposed(by: disposeBag)
    }
    
    func searchShowList(search: String, cursor: String?) {
        apiService.searchShowList(
            request: .init(
                cursor: cursor,
                size: 100,
                search: search
            )
        )
        .subscribe(with: self) { owner, response in
            owner.showSearchResult.accept(response.data.map {
                PerformanceInfoCollectionViewCellModel(
                    showID: $0.id,
                    performanceImageURL: URL(string: $0.imageURL),
                    performanceTitle: $0.title,
                    performanceTime: DateFormatterFactory.dateWithHypen.date(from: $0.startAt),
                    performanceLocation: $0.location
                )
            })
        }
        .disposed(by: disposeBag)
    }
}
