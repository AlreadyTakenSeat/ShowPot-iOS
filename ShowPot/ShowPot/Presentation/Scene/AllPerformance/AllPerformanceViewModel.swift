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
    
    private let usecase: AllPerformanceUseCase
    private let performanceListRelay = BehaviorRelay<[FeaturedPerformanceWithTicketOnSaleSoonCellModel]>(value: [])
    private let showPrioritySubject = BehaviorSubject<ShowFilterType>(value: .popular)
    private let isUpcomingSubject = BehaviorSubject<Bool>(value: false)

    var dataSource: DataSource?
    
    init(coordinator: AllPerformanceCoordinator, usecase: AllPerformanceUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        let didTappedCheckBoxButton: Observable<Bool>
        let didTappedPerformance: Observable<IndexPath>
        let didTappedBackButton: Observable<Void>
        let didTappedSearchButton: Observable<Void>
        let didTappedDropDown: Observable<String>
    }
    
    struct Output {
        let dropdownOptions: Observable<[String]>
        let defaultSelectedOption: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        
        usecase.performanceList
            .subscribe(with: self) { owner, model in
                owner.performanceListRelay.accept(model)
                owner.updateDataSource()
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
            .bind(to: isUpcomingSubject)
            .disposed(by: disposeBag)
        
        input.didTappedDropDown
            .compactMap { ShowFilterType.from(text: $0) }
            .bind(to: showPrioritySubject)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            isUpcomingSubject,
            showPrioritySubject
        )
        .subscribe(with: self) { owner, result in
            let (isOnlyUpcoming, type) = result
            owner.usecase.fetchAllPerformance(state: .init(type: type, isOnlyUpcoming: isOnlyUpcoming))
        }
        .disposed(by: disposeBag)
        
        input.didTappedPerformance
            .subscribe(with: self) { owner, indexPath in
                owner.coordinator.goToShowDetailScreen(showID: owner.performanceListRelay.value[indexPath.row].showID)
            }
            .disposed(by: disposeBag)
        
        let dropdownOptions = Observable.just([ShowFilterType.recent.text])
        let defaultSelectedOption = Observable.just(ShowFilterType.popular.text)
        
        return Output(dropdownOptions: dropdownOptions, defaultSelectedOption: defaultSelectedOption)
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

enum ShowFilterType: String, CaseIterable {
    case popular = "POPULAR"
    case recent = "RECENT"
    
    var text: String {
        switch self {
        case .popular:
            return Strings.allShowDropdownPopularTitle
        case .recent:
            return Strings.allShowDropdownRecentTitle
        }
    }
    
    static func from(text: String) -> Self? {
        ShowFilterType.allCases.first(where: { $0.text == text })
    }
}

struct ShowFilterState {
    let type: ShowFilterType
    let isOnlyUpcoming: Bool
}
