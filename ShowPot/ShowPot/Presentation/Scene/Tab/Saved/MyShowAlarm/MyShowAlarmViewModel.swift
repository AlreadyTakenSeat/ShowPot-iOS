//
//  MyShowAlarmViewModel.swift
//  ShowPot
//
//  Created by 이건준 on 8/9/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MyShowAlarmViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    private let myShowRelay = BehaviorRelay<[PerformanceInfoCollectionViewCellModel]>(value: [])
    private let showTicketingAlarmBottomSheetRelay = PublishRelay<PerformanceInfoCollectionViewCellModel>()
    
    var coordinator: MyShowAlarmCoordinator
    var dataSource: DataSource?
    private let usecase: MyShowUseCase
    
    init(coordinator: MyShowAlarmCoordinator, usecase: MyShowUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let didTappedBackButton: Observable<Void>
        let didTappedAlarmRemoveButton: Observable<IndexPath>
        let didTappedAlarmUpdateButton: Observable<IndexPath>
        let didTappedShowInfoButton: Observable<Void>
        let didTappedMyShow: Observable<IndexPath>
    }
    
    struct Output {
        let isEmptyViewHidden: Driver<Bool>
        let showTicketingAlarmBottomSheet: Signal<String>
    }
    
    func transform(input: Input) -> Output {
        
        usecase.showList
            .subscribe(with: self) { owner, model in
                owner.myShowRelay.accept(model)
                owner.updateDataSource()
            }
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .subscribe(with: self) { owner, model in
                owner.usecase.fetchShowList()
            }
            .disposed(by: disposeBag)
        
        input.didTappedAlarmRemoveButton
            .subscribe(with: self) { owner, indexPath in
                owner.usecase.deleteShowAlarm(indexPath: indexPath)
            }
            .disposed(by: disposeBag)
        
        input.didTappedBackButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.popViewController()
            }
            .disposed(by: disposeBag)
        
        input.didTappedShowInfoButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.goToAllShowScreen()
            }
            .disposed(by: disposeBag)
        
        input.didTappedMyShow
            .subscribe(with: self) { owner, indexPath in
                owner.coordinator.goToShowDetailScreen(showID: owner.myShowRelay.value[indexPath.row].showID)
            }
            .disposed(by: disposeBag)
        
        input.didTappedAlarmUpdateButton
            .subscribe(with: self) { owner, indexPath in
                // TODO: - 추후 API연동되면 showID를 이용해 티켓팅 바텀시트에 전달하는 코드로 수정
                owner.showTicketingAlarmBottomSheetRelay.accept(owner.myShowRelay.value[indexPath.row])
            }
            .disposed(by: disposeBag)
        
        let isEmptyViewHidden = myShowRelay
            .map { $0.isEmpty }
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(
            isEmptyViewHidden: isEmptyViewHidden,
            showTicketingAlarmBottomSheet: showTicketingAlarmBottomSheetRelay.map { $0.showID }.asSignal(onErrorSignalWith: .empty())
        )
    }
}

// MARK: - For NSDiffableDataSource

extension MyShowAlarmViewModel {
    
    typealias Item = PerformanceInfoCollectionViewCellModel
    typealias DataSource = UICollectionViewDiffableDataSource<MyPerformanceSection, Item>
    
    /// 내 공연 알림 섹션 타입
    enum MyPerformanceSection {
        case main
    }
    
    private func updateDataSource() {
        let showList = myShowRelay.value
        var snapshot = NSDiffableDataSourceSnapshot<MyPerformanceSection, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(showList)
        dataSource?.apply(snapshot)
    }
}
