//
//  DefaultInterestShowUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/16/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DefaultInterestShowUseCase: InterestShowUseCase {
    var interestShowList: RxRelay.BehaviorRelay<[ShowSummary]> = BehaviorRelay<[ShowSummary]>(value: [])
    
    func deleteInterestShow(_ show: ShowSummary) {
        var currentShowList = interestShowList.value
        LogHelper.debug("삭제한 공연정보: \(show)")
        let deleteShowID = show.id
        currentShowList.removeAll(where: { $0.id == deleteShowID })
        interestShowList.accept(currentShowList)
    }
    
    func requestInterestShowData() {
        interestShowList.accept([
            .init(id: "1", thumbnailURL: URL(string: "https://media.bunjang.co.kr/product/262127257_1_1714651082_w360.jpg"), title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", location: "KBS 아레나홀", time: Date(timeIntervalSinceNow: 24 * 60 * 60)),
            .init(id: "2", thumbnailURL: URL(string: "https://cdn.pixabay.com/photo/2015/08/22/15/39/giraffes-901009_1280.jpg"), title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", location: "강원도 성남 교회", time: Date(timeIntervalSinceNow: 24 * 60)),
            .init(id: "3", thumbnailURL: URL(string: "https://cdn.pixabay.com/photo/2016/03/05/22/17/food-1239231_1280.jpg"), title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", location: "호주 매직키드마수리", time: Date(timeIntervalSinceNow: 24 * 60 * 60 * 80)),
            .init(id: "4", thumbnailURL: URL(string: "https://cdn.pixabay.com/photo/2015/10/10/13/41/polar-bear-980781_1280.jpg"), title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", location: "보라매 스터디홀", time: Date(timeIntervalSinceNow: 80 * 60 * 60)),
            .init(id: "5", thumbnailURL: URL(string: "https://cdn.pixabay.com/photo/2014/04/05/11/41/butterfly-316740_1280.jpg"), title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", location: "송파구 오금로", time: Date(timeIntervalSinceNow: 50 * 60 * 60)),
            .init(id: "6", thumbnailURL: URL(string: "https://cdn.pixabay.com/photo/2024/03/24/14/47/hippopotamus-8653246_1280.png"), title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", location: "서울 성수 엘리스점", time: Date(timeIntervalSinceNow: 24 * 60 * 60 * 10)),
            .init(id: "7", thumbnailURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", location: "하남 로고스홀", time: Date(timeIntervalSinceNow: 24 * 30 * 60))
        ])
    }
}
