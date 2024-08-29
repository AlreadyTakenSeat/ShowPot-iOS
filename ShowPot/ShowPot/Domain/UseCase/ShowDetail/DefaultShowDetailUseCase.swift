//
//  DefaultShowDetailUseCase.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/15/24.
//

import Foundation
import RxSwift
import RxCocoa

class DefaultShowDetailUseCase: ShowDetailUseCase {
    
    private let apiService: SPShowAPI
    
    var showOverview = BehaviorSubject<ShowDetailOverView>(value: .init(posterImageURLString: "", title: "", time: nil, location: ""))
    var ticketList = BehaviorSubject<ShowDetailTicketInfo>(value: .init(ticketCategory: [], prereserveOpenTime: nil, normalreserveOpenTime: nil))
    var buttonState = BehaviorRelay<ShowDetailButtonState>(value: .init(isLiked: false, isAlarmSet: false))
    var artistList = BehaviorSubject<[FeaturedSubscribeArtistCellModel]>(value: [])
    var genreList = BehaviorRelay<[GenreType]>(value: [])
    var seatList = BehaviorRelay<[SeatDetailInfo]>(value: [])
    var updateInterestResult = PublishSubject<Bool>()
    
    private let disposeBag = DisposeBag()
    
    init(apiService: SPShowAPI = SPShowAPI()) {
        self.apiService = apiService
        ticketList.onNext(
            .init(
                ticketCategory: ["interpark", "yes24", "melonticket", "티켓링크"],
                prereserveOpenTime: Date(timeIntervalSinceNow: 6000),
                normalreserveOpenTime: Date(timeIntervalSinceNow: 4000)
            )
        )
    }
    
    func requestShowDetailData(showID: String) {
        
        apiService.showDetail(showId: showID)
            .subscribe(with: self) { owner, response in
                owner.showOverview.onNext(.init(
                    posterImageURLString: response.posterImageURL,
                    title: response.name,
                    time: DateFormatterFactory.dateWithHypen.date(from: response.startDate),
                    location: response.location
                ))
                
                owner.artistList.onNext(response.artists.map {
                    FeaturedSubscribeArtistCellModel(
                        id: $0.id,
                        state: .none,
                        artistImageURL: URL(string: $0.imageURL),
                        artistName: $0.englishName
                    )
                })
                
                owner.genreList.accept(response.genres.compactMap {
                    GenreType(rawValue: $0.name)
                })
                
                owner.seatList.accept(response.seats.map {
                    SeatDetailInfo(
                        seatCategoryTitle: $0.seatType,
                        seatPrice: "\($0.price)"
                    )
                })
                
                owner.buttonState.accept(.init(
                    isLiked: response.isInterested,
                    isAlarmSet: [true, false].shuffled()[0]
                ))
            }
            .disposed(by: disposeBag)
    }
    
    func updateShowInterest() {
        LogHelper.debug("공연 관심 등록/취소 요청")
        updateInterestResult.onNext([true, false].shuffled()[0])
    }
}
