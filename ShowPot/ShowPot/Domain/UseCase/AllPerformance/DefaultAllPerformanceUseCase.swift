//
//  DefaultAllPerformanceUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/3/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DefaultAllPerformanceUseCase: AllPerformanceUseCase {
    
    var performanceList: BehaviorRelay<[FeaturedPerformanceWithTicketOnSaleSoonCellModel]> = BehaviorRelay(value: [])
    
    func fetchAllPerformance(isOnlyUpcoming: Bool) {
        if !isOnlyUpcoming {
            performanceList.accept(
                [ // FIXME: - 추후 전체공연조회 API연동예정
                    .init(
                        performanceState: .reserving, performanceTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", performanceLocation: "KBS 아레나홀", performanceImageURL: URL(string: "https://media.bunjang.co.kr/product/262127257_1_1714651082_w360.jpg"), performanceDate: nil),
                    .init(
                        performanceState: .upcoming, performanceTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", performanceLocation: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", performanceImageURL: URL(string: "https://cdn.pixabay.com/photo/2015/08/22/15/39/giraffes-901009_1280.jpg"), performanceDate: Date(timeIntervalSinceNow: 24 * 60 * 60)),
                    .init(
                        performanceState: .upcoming, performanceTitle: "Nothing But Thieves But Thieves ", performanceLocation: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", performanceImageURL: URL(string: "https://cdn.pixabay.com/photo/2016/03/05/22/17/food-1239231_1280.jpg"), performanceDate: Date(timeIntervalSinceNow: 24 * 60)),
                    .init(
                        performanceState: .upcoming, performanceTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", performanceLocation: "KBS 아레나홀", performanceImageURL: URL(string: "https://cdn.pixabay.com/photo/2015/10/10/13/41/polar-bear-980781_1280.jpg"), performanceDate: Date(timeIntervalSinceNow: 24 * 60 * 60 * 60)),
                    .init(
                        performanceState: .upcoming, performanceTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", performanceLocation: "KBS 아레나홀", performanceImageURL: URL(string: "https://cdn.pixabay.com/photo/2014/04/05/11/41/butterfly-316740_1280.jpg"), performanceDate: Date(timeIntervalSinceNow: 24 * 60 * 60 * 60 * 60)),
                    .init(
                        performanceState: .upcoming, performanceTitle: "Nothing But Thieves But Thieves ", performanceLocation: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", performanceImageURL: URL(string: "https://cdn.pixabay.com/photo/2024/03/24/14/47/hippopotamus-8653246_1280.png"), performanceDate: Date(timeIntervalSinceNow: 24 * 60 * 60 * 60 * 60 * 60))
                ]
            )
        } else {
            performanceList.accept([ // FIXME: - 추후 오픈예정기준에 대한 프로퍼티를 이용해 스냅샷 필터 예정
                .init(
                    performanceState: .upcoming, performanceTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", performanceLocation: "KBS 아레나홀", performanceImageURL: URL(string: "https://cdn.pixabay.com/photo/2015/10/10/13/41/polar-bear-980781_1280.jpg"), performanceDate: Date(timeIntervalSinceNow: 24 * 60 * 60 * 60)),
                .init(
                    performanceState: .upcoming, performanceTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", performanceLocation: "KBS 아레나홀", performanceImageURL: URL(string: "https://cdn.pixabay.com/photo/2014/04/05/11/41/butterfly-316740_1280.jpg"), performanceDate: Date(timeIntervalSinceNow: 24 * 60 * 60 * 60 * 60)),
                .init(
                    performanceState: .upcoming, performanceTitle: "Nothing But Thieves But Thieves ", performanceLocation: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", performanceImageURL: URL(string: "https://cdn.pixabay.com/photo/2024/03/24/14/47/hippopotamus-8653246_1280.png"), performanceDate: Date(timeIntervalSinceNow: 24 * 60 * 60 * 60 * 60 * 60))
            ])
        }
    }
}
