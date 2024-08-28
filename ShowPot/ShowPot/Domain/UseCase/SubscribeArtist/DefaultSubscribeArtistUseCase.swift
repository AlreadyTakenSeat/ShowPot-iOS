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
    var artistList = BehaviorRelay<[FeaturedSubscribeArtistCellModel]>(value: [])
    
    func fetchArtistList() { // FIXME: - 추후 API연동 후 에러처리와 같은 동작 추가 필요
        artistList.accept([
            .init(state: .none, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
            .init(state: .none, artistImageURL: URL(string: "https://i.imgur.com/KsEXGAZ.jpg"), artistName: "Marilia Mendonca"),
            .init(state: .none, artistImageURL: URL(string: "https://cdn.mhns.co.kr/news/photo/201901/157199_206779_07.jpg"), artistName: "The Chainsmokers"),
            .init(state: .none, artistImageURL: URL(string: "https://t3.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/2fG8/image/sxiZQJy0MaesFjfzRRoyNWNRmhM.jpg"), artistName: "Beyonce"),
            .init(state: .none, artistImageURL: URL(string: "https://cdn.redian.org/news/photo/202108/155857_52695_0153.jpg"), artistName: "Adele"),
            .init(state: .none, artistImageURL: URL(string: "https://img1.daumcdn.net/thumb/R800x0/?scode=mtistory2&fname=https%3A%2F%2Ft1.daumcdn.net%2Fcfile%2Ftistory%2F1709EC404F290F7720"), artistName: "Imagine Dragons"),
            .init(state: .none, artistImageURL: URL(string: "https://mblogthumb-phinf.pstatic.net/MjAxOTEwMzBfMjM1/MDAxNTcyNDI4Mzg2NjI2.vFBBiLlc8YhPuny8BFHTYczJzoR1ObVC8ZHX2iAGye4g.BVn1BX_bMjbib22Ks-l2VCQUd70yU7o8vNBLcBhSH1gg.PNG.alvin5092/1572428385660.png?type=w800"), artistName: "Maluma"),
            .init(state: .none, artistImageURL: URL(string: "https://i.namu.wiki/i/jrUaXffKzxPCo876eNO8GRdQb81OBQuNV99GnN1pDlXkGcvEsyTJaEtCsWzEtjy4yVoOnPqP058LrPswAh7KQQ.webp"), artistName: "Bruno Mars"),
            .init(state: .none, artistImageURL: URL(string: "https://cdn2.ppomppu.co.kr/zboard/data3/2019/0827/m_20190827133411_lrzretxm.jpg"), artistName: "Leo J"),
            .init(state: .none, artistImageURL: URL(string: "https://cdn.slist.kr/news/photo/201912/122164_224649_5110.jpg"), artistName: "Marco Jacimus")
        ])
    }
    
    func subscribeArtists(artistID: [String]) async throws -> [String] { // FIXME: - 추후 API연동 후 에러처리와 같은 동작 추가 필요
        guard !artistID.isEmpty else {
            LogHelper.debug("구독할 아티스트를 선택하고 구독해주세요.")
            return [] // FIXME: - 이후 구독리스트 비어있을때 에러 추가
        }
        // 만약 구독 API성공했다면
        return artistID
    }
}
