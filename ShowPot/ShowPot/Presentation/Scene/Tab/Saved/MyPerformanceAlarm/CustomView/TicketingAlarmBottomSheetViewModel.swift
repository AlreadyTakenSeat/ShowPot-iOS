//
//  TicketingAlarmBottomSheetViewModel.swift
//  ShowPot
//
//  Created by 이건준 on 8/9/24.
//

import UIKit

import RxSwift
import RxCocoa

final class TicketingAlarmBottomSheetViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    private let performanceModel: PerformanceInfoCollectionViewCellModel
    
    /// 변경하기 이전 기준이 되는 모델
    private var myTicketingAlarmBeforeModel: [TicketingAlarmCellModel] = []
    
    /// 변경 이후에 따른 추적하는 모델
    private let myTicketingAlarmAfterModel = BehaviorRelay<[TicketingAlarmCellModel]>(value: [])
    
    var dataSource: DataSource?
    
    init(performanceModel: PerformanceInfoCollectionViewCellModel) { // TODO: - 추후 showID를 인자로 받아와 처리필요
        self.performanceModel = performanceModel
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let didTappedTicketingTimeCell: Observable<IndexPath>
        let didTappedUpdateButton: Observable<Void>
    }
    
    struct Output {
        let isEnabledBottomButton: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        input.viewDidLoad
            .subscribe(with: self) { owner, _ in
                
                let beforeTicketingModel: [TicketingAlarmCellModel] = [
                    .init(isChecked: true, isEnabled: true, ticketingAlertText: "티켓팅 24시간 전"),
                    .init(isChecked: true, isEnabled: false, ticketingAlertText: "티켓팅 6시간 전"),
                    .init(isChecked: false, isEnabled: true, ticketingAlertText: "티켓팅 1시간 전")
                ]
                
                owner.myTicketingAlarmBeforeModel = beforeTicketingModel
                owner.myTicketingAlarmAfterModel.accept(beforeTicketingModel)
                owner.updateDataSource()
            }
            .disposed(by: disposeBag)
        
        input.didTappedTicketingTimeCell
            .subscribe(with: self) { owner, indexPath in
                var currentTicketingTimeList = owner.myTicketingAlarmAfterModel.value
                LogHelper.debug("티켓팅 알림 시간 선택: \(currentTicketingTimeList[indexPath.row].ticketingAlertText)")
                guard currentTicketingTimeList[indexPath.row].isEnabled else { return }
                currentTicketingTimeList[indexPath.row].isChecked.toggle()
                owner.myTicketingAlarmAfterModel.accept(currentTicketingTimeList)
                owner.updateDataSource()
            }
            .disposed(by: disposeBag)
        
        input.didTappedUpdateButton
            .subscribe(with: self) { owner, _ in
                var currentTicketingTimeList = owner.myTicketingAlarmAfterModel.value
                LogHelper.debug("티켓팅 알림 업데이트 정보: \(currentTicketingTimeList)\n공연제목: \(owner.performanceModel.performanceTitle)")
                // TODO: - 티켓팅 시간정보를 가지고 API를 호출 필요
            }
            .disposed(by: disposeBag)
        
        /// 변경하기 이전과 이후 상태가 다른지 확인하는 Observable
        let isCheckedStateDifferent = myTicketingAlarmAfterModel
            .withUnretained(self)
            .map { owner, afterModels in
                // isEnabled 값이 true인 beforeModels만 필터링
                let enabledBeforeModels = owner.myTicketingAlarmBeforeModel.filter { $0.isEnabled }
                
                // isEnabled 값이 true인 afterModels만 필터링
                let enabledAfterModels = afterModels.filter { $0.isEnabled }
                
                // enabledBeforeModels와 enabledAfterModels의 isChecked 값을 비교
                for (index, afterModel) in enabledAfterModels.enumerated() {
                    // 배열 크기 체크 및 isChecked 값이 다른 경우
                    if index < enabledBeforeModels.count &&
                        enabledBeforeModels[index].isChecked != afterModel.isChecked {
                        return true
                    }
                }
                return false
            }
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(isEnabledBottomButton: isCheckedStateDifferent)
    }
}

// MARK: - For NSDiffableDataSource

extension TicketingAlarmBottomSheetViewModel {
    
    typealias Item = TicketingAlarmCellModel
    typealias DataSource = UICollectionViewDiffableDataSource<TicketingAlarmSection, Item>
    
    /// 티켓팅 알람 섹션 타입
    enum TicketingAlarmSection {
        case main
    }
    
    private func updateDataSource() {
        let ticketingTimeList = myTicketingAlarmAfterModel.value
        var snapshot = NSDiffableDataSourceSnapshot<TicketingAlarmSection, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(ticketingTimeList)
        dataSource?.apply(snapshot)
    }
}
