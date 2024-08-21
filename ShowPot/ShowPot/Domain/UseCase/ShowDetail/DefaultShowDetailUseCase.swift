//
//  DefaultShowDetailUseCase.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/15/24.
//

import Foundation
import RxSwift

class DefaultShowDetailUseCase: ShowDetailUseCase {
    
    var ticketList = BehaviorSubject<[String]>(value: [])
    var artistList = BehaviorSubject<[FeaturedSubscribeArtistCellModel]>(value: [])
    
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
    }
}
