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
    
    init(coordinator: MyShowAlarmCoordinator) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let didTappedBackButton: Observable<Void>
        let didTappedAlarmRemoveButton: Observable<IndexPath>
        let didTappedAlarmUpdateButton: Observable<IndexPath>
        let didTappedShowInfoButton: Observable<Void>
    }
    
    struct Output {
        let isEmptyViewHidden: Driver<Bool>
        let showTicketingAlarmBottomSheet: Signal<PerformanceInfoCollectionViewCellModel>
    }
    
    func transform(input: Input) -> Output {
        
        input.viewDidLoad
            .subscribe(with: self) { owner, model in
                owner.myShowRelay.accept([
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
                var showList = owner.myShowRelay.value
                let showTitle = showList[indexPath.row].performanceTitle
                showList.removeAll(where: { $0.performanceTitle == showTitle })
                owner.myShowRelay.accept(showList)
                owner.updateDataSource()
            }
            .disposed(by: disposeBag)
        
        input.didTappedBackButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.popViewController()
            }
            .disposed(by: disposeBag)
        
        input.didTappedShowInfoButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.goToShowInfoScreen()
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
            showTicketingAlarmBottomSheet: showTicketingAlarmBottomSheetRelay.asSignal()
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
