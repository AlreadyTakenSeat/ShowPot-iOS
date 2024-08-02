//
//  AllPerformanceViewModel.swift
//  ShowPot
//
//  Created by 이건준 on 8/2/24.
//

import UIKit

import RxSwift
import RxCocoa

final class AllPerformanceViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    var coordinator: AllPerformanceCoordinator
    
    private let isOnlyUpcomingRelay = BehaviorRelay<Bool>(value: false)
    private let performanceListRelay = BehaviorRelay<[FeaturedPerformanceWithTicketOnSaleSoonCellModel]>(value: [])

    var dataSource: DataSource?
    
    init(coordinator: AllPerformanceCoordinator) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let initializePerformance: Observable<Void>
        let didTappedCheckBoxButton: Observable<Bool>
        let didTappedPerformance: Observable<IndexPath>
        let didTappedBackButton: Observable<Void>
        let didTappedSearchButton: Observable<Void>
    }
    
    struct Output {}
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        input.initializePerformance
            .subscribe(with: self) { owner, _ in
                owner.fetchAllPerformanceList()
            }
            .disposed(by: disposeBag)
        
        input.didTappedBackButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.popViewController()
            }
            .disposed(by: disposeBag)
        
        input.didTappedSearchButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.goToSearchScreen()
            }
            .disposed(by: disposeBag)
        
        input.didTappedCheckBoxButton
            .map { !$0 }
            .subscribe(with: self) { owner, isChecked in
                isChecked ? owner.fetchOnlyUpcomingPerformance() : owner.fetchAllPerformanceList()
            }
            .disposed(by: disposeBag)
        
        input.didTappedPerformance
            .subscribe(with: self) { owner, indexPath in
                print("선택한 공연정보: \(owner.performanceListRelay.value[indexPath.row])")
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}

extension AllPerformanceViewModel {
    
    private func fetchAllPerformanceList() {
        performanceListRelay.accept([ // FIXME: - 추후 전체공연조회 API연동예정
            .init(
                ticketingOpenTime: "OPEN : 06.10(MON) AM 11:00", performanceTitle: "Nothing But Thieves But Thieves ", performanceLocation: "KBS 아레나홀", performanceImageURL: URL(string: "https://media.bunjang.co.kr/product/262127257_1_1714651082_w360.jpg")),
            .init(
                ticketingOpenTime: "OPEN : 06.10(MON) AM 11:00", performanceTitle: "Nothing But Thieves But Thieves ", performanceLocation: "KBS 아레나홀", performanceImageURL: URL(string: "https://media.bunjang.co.kr/product/262127257_1_1714651082_w360.jpg")),
            .init(
                ticketingOpenTime: "OPEN : 06.10(MON) AM 11:00", performanceTitle: "Nothing But Thieves But Thieves ", performanceLocation: "KBS 아레나홀", performanceImageURL: URL(string: "https://media.bunjang.co.kr/product/262127257_1_1714651082_w360.jpg")),
            .init(
                ticketingOpenTime: "OPEN : 06.10(MON) AM 11:00", performanceTitle: "Nothing But Thieves But Thieves ", performanceLocation: "KBS 아레나홀", performanceImageURL: URL(string: "https://media.bunjang.co.kr/product/262127257_1_1714651082_w360.jpg")),
            .init(
                ticketingOpenTime: "OPEN : 06.10(MON) AM 11:00", performanceTitle: "Nothing But Thieves But Thieves ", performanceLocation: "KBS 아레나홀", performanceImageURL: URL(string: "https://media.bunjang.co.kr/product/262127257_1_1714651082_w360.jpg")),
            .init(
                ticketingOpenTime: "OPEN : 06.10(MON) AM 11:00", performanceTitle: "Nothing But Thieves But Thieves ", performanceLocation: "KBS 아레나홀", performanceImageURL: URL(string: "https://media.bunjang.co.kr/product/262127257_1_1714651082_w360.jpg")),
            .init(
                ticketingOpenTime: "OPEN : 06.10(MON) AM 11:00", performanceTitle: "Nothing But Thieves But Thieves ", performanceLocation: "KBS 아레나홀", performanceImageURL: URL(string: "https://media.bunjang.co.kr/product/262127257_1_1714651082_w360.jpg"))
        ])
        updateDataSource()
    }
    
    private func fetchOnlyUpcomingPerformance() {
        performanceListRelay.accept([ // FIXME: - 추후 오픈예정기준에 대한 프로퍼티를 이용해 스냅샷 필터 예정
            .init(
                ticketingOpenTime: "OPEN : 06.10(MON) AM 11:00", performanceTitle: "Nothing But Thieves But Thieves ", performanceLocation: "KBS 아레나홀", performanceImageURL: URL(string: "https://media.bunjang.co.kr/product/262127257_1_1714651082_w360.jpg")),
            .init(
                ticketingOpenTime: "OPEN : 06.10(MON) AM 11:00", performanceTitle: "Nothing But Thieves But Thieves ", performanceLocation: "KBS 아레나홀", performanceImageURL: URL(string: "https://media.bunjang.co.kr/product/262127257_1_1714651082_w360.jpg")),
            .init(
                ticketingOpenTime: "OPEN : 06.10(MON) AM 11:00", performanceTitle: "Nothing But Thieves But Thieves ", performanceLocation: "KBS 아레나홀", performanceImageURL: URL(string: "https://media.bunjang.co.kr/product/262127257_1_1714651082_w360.jpg")),
        ])
        updateDataSource()

    }
    
}

// MARK: - For NSDiffableDataSource

extension AllPerformanceViewModel {
    
    typealias Item = FeaturedPerformanceWithTicketOnSaleSoonCellModel
    typealias DataSource = UICollectionViewDiffableDataSource<PerformanceSection, Item>
    
    /// 최근 검색어 리스트 섹션 타입
    enum PerformanceSection {
        case main
    }
    
    private func updateDataSource() {
        let performanceList = performanceListRelay.value
        var snapshot = NSDiffableDataSourceSnapshot<PerformanceSection, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(performanceList)
        dataSource?.apply(snapshot)
    }
}
