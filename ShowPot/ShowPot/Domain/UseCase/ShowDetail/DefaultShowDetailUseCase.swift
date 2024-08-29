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
    var buttonState = BehaviorRelay<ShowDetailButtonState>(value: .init(isLiked: false, isAlarmSet: false, isAlreadyOpen: false))
    var artistList = BehaviorSubject<[FeaturedSubscribeArtistCellModel]>(value: [])
    var genreList = BehaviorRelay<[GenreType]>(value: [])
    var seatList = BehaviorRelay<[SeatDetailInfo]>(value: [])
    var updateInterestResult = PublishSubject<Bool>()
    
    private let disposeBag = DisposeBag()
    
    init(apiService: SPShowAPI = SPShowAPI()) {
        self.apiService = apiService
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
                
                let normalOpenTime = response.ticketingTimes.first(where: { $0.ticketingAPIType == TicketingType.normal.rawValue })
                let preOpenTime = response.ticketingTimes.first(where: { $0.ticketingAPIType == TicketingType.pre.rawValue })
                
                owner.ticketList.onNext(
                    ShowDetailTicketInfo(
                        ticketCategory: response.ticketingSites.map { TicketInfo(categoryName: $0.name, link: $0.link) },
                        prereserveOpenTime: DateFormatterFactory.dateTime.date(from: preOpenTime?.ticketingAt ?? ""),
                        normalreserveOpenTime: DateFormatterFactory.dateTime.date(from: normalOpenTime?.ticketingAt ?? "")
                    )
                )
                
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
                        seatPrice: NumberformatterFactory.decimal.number(from: "\($0.price)")
                    )
                })
                
                owner.buttonState.accept(.init(
                    isLiked: response.isInterested,
                    isAlarmSet: false, 
                    isAlreadyOpen: false
                ))
            }
            .disposed(by: disposeBag)
    }
    
    func updateShowInterest(showID: String) {
        apiService.updateInterest(showId: showID)
            .subscribe { response in
                self.updateInterestResult.onNext(true)
            } onError: { error in
                self.updateInterestResult.onNext(false)
            }
            .disposed(by: disposeBag)
    }
}

enum TicketingType: String {
    case pre = "PRE"
    case normal = "NORMAL"
}
