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
    var showOverview = BehaviorSubject<ShowDetailOverView>(value: .init(posterImageURLString: "", title: "", time: nil, location: ""))
    var ticketList = BehaviorSubject<ShowDetailTicketInfo>(value: .init(ticketCategory: [], prereserveOpenTime: nil, normalreserveOpenTime: nil))
    var buttonState = BehaviorRelay<ShowDetailButtonState>(value: .init(isLiked: false, isAlarmSet: false))
    var artistList = BehaviorSubject<[FeaturedSubscribeArtistCellModel]>(value: [])
    var genreList = BehaviorRelay<[GenreType]>(value: [])
    var seatList = BehaviorRelay<[SeatDetailInfo]>(value: [])
    var updateInterestResult = PublishSubject<Bool>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        ticketList.onNext(
            .init(
                ticketCategory: ["interpark", "yes24", "melonticket", "티켓링크"],
                prereserveOpenTime: Date(timeIntervalSinceNow: 6000),
                normalreserveOpenTime: Date(timeIntervalSinceNow: 4000)
            )
        )
    }
    
    func requestShowDetailData(showID: String) {
        
        showOverview.onNext(ShowDetailOverView(posterImageURLString: "https://enfntsterribles.com/wp-content/uploads/2023/08/enfntsterribles-nothing-but-thieves-01.jpg", title: "나씽 벗 띠브스 내한공연 (Nothing But Thieves Live in Seoul)", time: Date(timeIntervalSinceNow: 7000), location: "KBS 아레나홀"))
        
        artistList.onNext([
            .init(id: "1", state: .none, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
            .init(id: "2", state: .none, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
            .init(id: "3", state: .none, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
            .init(id: "4", state: .none, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
            .init(id: "5", state: .none, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
            .init(id: "6", state: .none, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird")
        ])
        
        let mockGenreList = ["rock", "band", "edm", "classic", "hiphop", "house", "opera", "pop", "rnb", "musical", "metal", "jpop", "jazz"]
        genreList.accept(mockGenreList.compactMap { GenreType(rawValue: $0) })
        
        seatList.accept([
            .init(seatCategoryTitle: "스탠딩 P", seatPrice: "154,000원"),
            .init(seatCategoryTitle: "스탠딩 R", seatPrice: "143,000원"),
            .init(seatCategoryTitle: "지정석 P", seatPrice: "176,000원"),
            .init(seatCategoryTitle: "지정석 R", seatPrice: "165,000원"),
            .init(seatCategoryTitle: "지정석 S", seatPrice: "143,000원"),
            .init(seatCategoryTitle: "지정석 A", seatPrice: "132,000원")
        ])
        
        buttonState.accept(.init(isLiked: [true, false].shuffled()[0], isAlarmSet: [true, false].shuffled()[0]))
    }
    
    func updateShowInterest() {
        LogHelper.debug("공연 관심 등록/취소 요청")
        updateInterestResult.onNext([true, false].shuffled()[0])
    }
}
