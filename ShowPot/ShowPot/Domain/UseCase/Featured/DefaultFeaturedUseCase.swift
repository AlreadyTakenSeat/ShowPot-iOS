//
//  DefaultFeaturedUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/28/24.
//
import Foundation
import RxSwift
import RxCocoa

final class DefaultFeaturedUseCase: SubscribeArtistUseCase, AllPerformanceUseCase {
    
    private let disposeBag = DisposeBag()
    private let apiService: APIClient
    
    var artistList = BehaviorRelay<[FeaturedSubscribeArtistCellModel]>(value: [])
    var performanceList = BehaviorRelay<[FeaturedPerformanceWithTicketOnSaleSoonCellModel]>(value: [])
    var subscribeArtistResult = PublishSubject<Bool>()
    
    init(apiService: APIClient = APIClient()) {
        self.apiService = apiService
    }
    
    func fetchArtistList() {
        apiService.unsubcribeArtistList(
            request: .init(
                sortStandard: .englishNameAscending,
                artistGenderApiTypes: [],
                artistApiTypes: [],
                genreIds: [],
                cursor: nil,
                size: 10
            )
        ).subscribe(with: self) { owner, response in
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
        
    }
    
    func fetchAllPerformance(state: ShowFilterState) {
        apiService.showList(
            sort: state.type.rawValue,
            onlyOpen: state.isOnlyUpcoming,
            size: 2
        )
        .subscribe(with: self) { owner, response in
            owner.performanceList.accept(response.data.map {
                FeaturedPerformanceWithTicketOnSaleSoonCellModel(
                    showID: $0.id,
                    performanceState: $0.isOpen ? .reserving : .upcoming,
                    performanceTitle: $0.title,
                    performanceLocation: $0.location,
                    performanceImageURL: URL(string: $0.posterImageURL),
                    performanceDate: $0.isOpen ? nil : DateFormatterFactory.dateTime.date(from: $0.ticketingAt)
                )
            })
        }
        .disposed(by: disposeBag)
    }
}
