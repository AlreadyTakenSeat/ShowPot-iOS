//
//  MyPerformanceAlarmViewModel.swift
//  ShowPot
//
//  Created by 이건준 on 8/9/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MyPerformanceAlarmViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    private let myPerformanceRelay = BehaviorRelay<[PerformanceInfoCollectionViewCellModel]>(value: [])
    private let showTicketingAlarmBottomSheetRelay = PublishRelay<PerformanceInfoCollectionViewCellModel>()
    
    var coordinator: MyPerformanceAlarmCoordinator
    var dataSource: DataSource?
    
    init(coordinator: MyPerformanceAlarmCoordinator) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let initializePerformanceList: Observable<Void>
        let didTappedBackButton: Observable<Void>
        let didTappedAlarmRemoveButton: Observable<IndexPath>
        let didTappedAlarmUpdateButton: Observable<IndexPath>
        let didTappedPerformanceInfoButton: Observable<Void>
    }
    
    struct Output {
        let isEmptyViewHidden: Driver<Bool>
        let showTicketingAlarmBottomSheet: Signal<PerformanceInfoCollectionViewCellModel>
    }
    
    func transform(input: Input) -> Output {
        
        input.initializePerformanceList
            .subscribe(with: self) { owner, model in
                owner.myPerformanceRelay.accept([
                    .init(performanceImageURL: URL(string: "https://img.newspim.com/news/2023/09/21/2309210928580280.jpg"), performanceTitle: "에스파단독고연", performanceTime: Date(timeIntervalSinceNow: 24 * 60 * 60), performanceLocation: "KBS 아레나홀"),
                    .init(performanceImageURL: URL(string: "https://image.bugsm.co.kr/essential/images/500/39/3978.jpg"), performanceTitle: "샘스미스단독공연", performanceTime: Date(timeIntervalSinceNow: 24 * 60), performanceLocation: "KBS 아레나홀"),
                    .init(performanceImageURL: URL(string: "https://img.newspim.com/news/2023/03/06/2303060940437270.jpg"), performanceTitle: "안젤리나졸리단독고연", performanceTime: Date(timeIntervalSinceNow: 24 * 60 * 60 * 60), performanceLocation: "KBS 아레나홀"),
                    .init(performanceImageURL: URL(string: "https://www.gugakpeople.com/data/gugakpeople_com/mainimages/202407/2024071636209869.jpg"), performanceTitle: "브루노마스단독고연", performanceTime: Date(timeIntervalSinceNow: 24), performanceLocation: "KBS 아레나홀"),
                    .init(performanceImageURL: URL(string: "https://img.newspim.com/news/2023/06/05/2306051642145540.jpg"), performanceTitle: "워시단독고연", performanceTime: Date(timeIntervalSinceNow: 24 * 60 * 60), performanceLocation: "KBS 아레나홀")
                ])
                owner.updateDataSource()
            }
            .disposed(by: disposeBag)
        
        input.didTappedAlarmRemoveButton
            .subscribe(with: self) { owner, indexPath in
                LogHelper.debug("알림 해제하기 인덱스: \(indexPath.row)")
                var performanceList = owner.myPerformanceRelay.value
                let performanceTitle = performanceList[indexPath.row].performanceTitle
                performanceList.removeAll(where: { $0.performanceTitle == performanceTitle })
                owner.myPerformanceRelay.accept(performanceList)
                owner.updateDataSource()
            }
            .disposed(by: disposeBag)
        
        input.didTappedBackButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.popViewController()
            }
            .disposed(by: disposeBag)
        
        input.didTappedPerformanceInfoButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.goToPerformanceInfoScreen()
            }
            .disposed(by: disposeBag)
        
        input.didTappedAlarmUpdateButton
            .subscribe(with: self) { owner, indexPath in
                // TODO: - 추후 API연동되면 showID를 이용해 티켓팅 바텀시트에 전달하는 코드로 수정
                owner.showTicketingAlarmBottomSheetRelay.accept(owner.myPerformanceRelay.value[indexPath.row])
            }
            .disposed(by: disposeBag)
        
        let isEmptyViewHidden = myPerformanceRelay
            .map { $0.isEmpty }
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(
            isEmptyViewHidden: isEmptyViewHidden,
            showTicketingAlarmBottomSheet: showTicketingAlarmBottomSheetRelay.asSignal()
        )
    }
}

// MARK: - For NSDiffableDataSource

extension MyPerformanceAlarmViewModel {
    
    typealias Item = PerformanceInfoCollectionViewCellModel
    typealias DataSource = UICollectionViewDiffableDataSource<MyPerformanceSection, Item>
    
    /// 내 공연 알림 섹션 타입
    enum MyPerformanceSection {
        case main
    }
    
    private func updateDataSource() {
        let performanceList = myPerformanceRelay.value
        var snapshot = NSDiffableDataSourceSnapshot<MyPerformanceSection, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(performanceList)
        dataSource?.apply(snapshot)
    }
}
