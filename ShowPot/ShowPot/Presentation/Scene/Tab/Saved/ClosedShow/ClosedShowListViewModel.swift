//
//  ClosedShowListViewModel.swift
//  ShowPot
//
//  Created by 이건준 on 8/17/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ClosedShowListViewModel: ViewModelType {
    
    var coordinator: ClosedShowListCoordinator
    private let disposeBag = DisposeBag()
    private let usecase: ClosedShowUseCase
    
    private let showListRelay = BehaviorRelay<[ShowSummary]>(value: [])
    
    init(coordinator: ClosedShowListCoordinator, usecase: ClosedShowUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        let didTappedBackButton: Observable<Void>
        let didTappedShowCell: Observable<IndexPath>
        let didTappedEmptyButton: Observable<Void>
    }
    
    struct Output {
        let showList: Driver<[ShowSummary]>
        let isEmpty: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
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
                owner.coordinator.goToMyShowAlarmScreen()
            }
            .disposed(by: disposeBag)
        
        usecase.closedShowList
            .bind(to: showListRelay)
            .disposed(by: disposeBag)
        
        let showList = showListRelay.asDriver()
        let isEmpty = showListRelay.map { $0.isEmpty }.asDriver(onErrorDriveWith: .empty())
        
        return Output(showList: showList, isEmpty: isEmpty)
    }
    
    func fetchClosedShowList() {
        usecase.requestClosedShowData()
    }
}
