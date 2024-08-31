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
    
    private let showAPI = SPShowAPI()
    private let disposeBag = DisposeBag()
    
    var performanceList: BehaviorRelay<[FeaturedPerformanceWithTicketOnSaleSoonCellModel]> = BehaviorRelay(value: [])
    
    func fetchAllPerformance(state: ShowFilterState) {
        
        LogHelper.debug("전체공연 검색\n오픈예정유무: \(state.isOnlyUpcoming)\n어떤필터타입: \(state.type)")
        
        showAPI.showList(sort: state.type.rawValue, onlyOpen: state.isOnlyUpcoming)
            .subscribe(with: self) { owner, response in
                owner.performanceList.accept(response.data.map {
                    FeaturedPerformanceWithTicketOnSaleSoonCellModel(
                        showID: $0.id,
                        performanceState: $0.isOpen ? .reserving : .upcoming,
                        performanceTitle: $0.title,
                        performanceLocation: $0.location,
                        performanceImageURL: URL(string: $0.posterImageURL),
                        performanceDate: $0.isOpen ? nil : DateFormatterFactory.dateTime.date(from: $0.ticketingAt)
                    )
                })
            }.disposed(by: disposeBag)
    }
}
