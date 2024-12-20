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
    var ticketModel = BehaviorSubject<ShowDetailTicketInfo>(value: .init(ticketCategory: [], prereserveOpenTime: nil, normalreserveOpenTime: nil))
    var buttonState = BehaviorRelay<ShowDetailButtonState>(value: .init(isLiked: false, isAlarmSet: false, isAlreadyOpen: false))
    var artistModel = BehaviorSubject<[FeaturedSubscribeArtistCellModel]>(value: [])
    var genreModel = BehaviorRelay<[GenreType]>(value: [])
    var seatModel = BehaviorRelay<[SeatDetailInfo]>(value: [])
    var updatedShowInterestResult = PublishSubject<Bool>()
    
    private let disposeBag = DisposeBag()
    
    init(apiService: SPShowAPI = SPShowAPI()) {
        self.apiService = apiService
    }
    
    func requestShowDetailData(showID: String) {
        /* TODO: [SPT-4] 변경된 알람 설정 모델 적용 필요
        apiService.showDetail(showId: showID)
            .catch { _ in return .empty() }
            .subscribe(with: self) { owner, response in
                owner.showOverview.onNext(.init(
                    posterImageURLString: response.posterImageURL,
                    title: response.name,
                    time: DateFormatterFactory.dateWithHypen.date(from: response.startDate),
                    location: response.location
                ))
                
                let normalOpenTime = response.ticketingTimes.first(where: { $0.ticketingAPIType == TicketingType.normal.rawValue })
                let preOpenTime = response.ticketingTimes.first(where: { $0.ticketingAPIType == TicketingType.pre.rawValue })
                
                owner.ticketModel.onNext(
                    ShowDetailTicketInfo(
                        ticketCategory: response.ticketingSites.map { TicketInfo(categoryName: $0.name, link: $0.link) },
                        prereserveOpenTime: DateFormatterFactory.dateTime.date(from: preOpenTime?.ticketingAt ?? ""),
                        normalreserveOpenTime: DateFormatterFactory.dateTime.date(from: normalOpenTime?.ticketingAt ?? "")
                    )
                )
                
                owner.artistModel.onNext(response.artists.map {
                    FeaturedSubscribeArtistCellModel(
                        id: $0.id,
                        state: .none,
                        artistImageURL: URL(string: $0.imageURL),
                        artistName: $0.englishName
                    )
                })
                
                owner.genreModel.accept(response.genres.compactMap {
                    GenreType(rawValue: $0.name)
                })
                
                owner.seatModel.accept(response.seats.map {
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
         */
    }
    
    func updateShowInterest(showID: String) {
        apiService.updateInterest(showId: showID)
            .catch { _ in return .empty() }
            .subscribe(with: self) { owner, response in
                /* TODO: [SPT-4] 변경된 알람 설정 모델 적용 필요
                owner.updatedShowInterestResult.onNext(response.hasInterest)
                 */
            }
            .disposed(by: disposeBag)
    }
}

enum TicketingType: String {
    case pre = "PRE"
    case normal = "NORMAL"
}
