//
//  InterestShowListViewModel.swift
//  ShowPot
//
//  Created by 이건준 on 8/16/24.
//

import UIKit
import RxSwift
import RxCocoa

final class InterestShowListViewModel: ViewModelType {
    
    var coordinator: InterestShowListCoordinator
    private let disposeBag = DisposeBag()
    private let usecase: InterestShowUseCase
    
    var dataSource: DataSource?
    
    private let showListRelay = BehaviorRelay<[ShowSummary]>(value: [])
    
    init(coordinator: InterestShowListCoordinator, usecase: InterestShowUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let didTappedDeleteButton: Observable<IndexPath>
        let didTappedShowCell: Observable<IndexPath>
        let didTappedBackButton: Observable<Void>
        let didTappedEmptyButton: Observable<Void>
    }
    
    struct Output {
        let isEmpty: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        input.viewDidLoad
            .subscribe(with: self) { owner, model in
                owner.usecase.requestInterestShowData()
            }
            .disposed(by: disposeBag)
        
        input.didTappedDeleteButton
            .subscribe(with: self) { owner, indexPath in
                let deleteShow = owner.usecase.interestShowList.value[indexPath.row]
                owner.usecase.deleteInterestShow(deleteShow)
            }
            .disposed(by: disposeBag)
        
        input.didTappedShowCell
            .subscribe(with: self) { owner, indexPath in
                owner.coordinator.goToShowDetailScreen(showID: owner.showListRelay.value[indexPath.row].id)
            }
            .disposed(by: disposeBag)
        
        input.didTappedBackButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.popViewController()
            }
            .disposed(by: disposeBag)
        
        input.didTappedEmptyButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.goToFullPerformanceScreen()
            }
            .disposed(by: disposeBag)
        
        usecase.interestShowList
            .subscribe(with: self) { owner, model in
                owner.showListRelay.accept(model)
                owner.updateDataSource()
            }
            .disposed(by: disposeBag)
        
        let isEmpty = showListRelay.map { $0.isEmpty }.asDriver(onErrorDriveWith: .empty())
        
        return Output(isEmpty: isEmpty)
    }
}

// MARK: - For NSDiffableDataSource

extension InterestShowListViewModel {
    
    typealias Item = ShowSummary
    typealias DataSource = UICollectionViewDiffableDataSource<InterestShowSection, Item>
    
    /// 관심 공연 섹션 타입
    enum InterestShowSection {
        case main
    }
    
    private func updateDataSource() {
        let currentShowList = showListRelay.value
        var snapshot = NSDiffableDataSourceSnapshot<InterestShowSection, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(currentShowList)
        dataSource?.apply(snapshot)
    }
}
