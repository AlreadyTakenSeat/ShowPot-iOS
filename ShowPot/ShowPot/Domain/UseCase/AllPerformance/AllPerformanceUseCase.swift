//
//  AllPerformanceUsecase.swift
//  ShowPot
//
//  Created by 이건준 on 8/3/24.
//

import Foundation
import RxSwift
import RxCocoa

struct FeaturedPerformanceWithTicketOnSaleSoonCellModel: Hashable { // TODO: - UseCase모델은 특정 부분에 의존하면 안되므로 네이밍 수정 필요
    let showID: String
    let performanceState: PerformanceState
    let performanceTitle: String
    let performanceLocation: String
    let performanceImageURL: URL?
    let performanceDate: Date?

    private let identifier = UUID() // TODO: - 추후 공연정보에 대한 아이디로 대체 예정
}

protocol AllPerformanceUseCase {
    var performanceList: BehaviorRelay<[FeaturedPerformanceWithTicketOnSaleSoonCellModel]> { get }
    func fetchAllPerformance(state: ShowFilterState)
}
