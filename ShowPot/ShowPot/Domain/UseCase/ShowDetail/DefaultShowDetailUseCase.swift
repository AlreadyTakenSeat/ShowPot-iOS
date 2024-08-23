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
    var buttonState = BehaviorRelay<ShowDetailButtonState>(value: .init(isLiked: false, isAlarmSet: false))
    var ticketList = BehaviorSubject<[String]>(value: [])
    var artistList = BehaviorSubject<[FeaturedSubscribeArtistCellModel]>(value: [])
    var genreList = BehaviorRelay<[GenreType]>(value: [])
    var seatList = BehaviorRelay<[SeatDetailInfo]>(value: [])
    var updateInterestResult = PublishSubject<Bool>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        ticketList.onNext(["interpark", "yes24", "melonticket", "티켓링크"])
    }
    
    func requestShowDetailData() {
        artistList.onNext([
            .init(state: .none, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
            .init(state: .none, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
            .init(state: .none, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
            .init(state: .none, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
            .init(state: .none, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
            .init(state: .none, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird")
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
