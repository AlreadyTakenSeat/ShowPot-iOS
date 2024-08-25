//
//  TicketingAlarmUpdateViewModel.swift
//  ShowPot
//
//  Created by 이건준 on 8/9/24.
//

import UIKit

import RxSwift
import RxCocoa

final class TicketingAlarmUpdateViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    private let showID: String
    
    /// 변경하기 이전 기준이 되는 모델
    private var myTicketingAlarmBeforeModel: [TicketingAlarmCellModel] = []
    
    /// 변경 이후에 따른 추적하는 모델
    private let myTicketingAlarmAfterModel = BehaviorRelay<[TicketingAlarmCellModel]>(value: [])
    
    var dataSource: DataSource?
    private let usecase: MyShowUseCase
    
    init(showID: String, usecase: MyShowUseCase) {
        self.usecase = usecase
        self.showID = showID
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let didTappedTicketingTimeCell: Observable<IndexPath>
        let didTappedUpdateButton: Observable<Void>
    }
    
    struct Output {
        let isEnabledBottomButton: Driver<Bool>
        let alarmUpdateResult: Signal<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let ticketingAlarmModel = usecase.ticketingAlarm.share()
        
        ticketingAlarmModel.take(1)
            .subscribe(with: self) { owner, model in
                owner.myTicketingAlarmBeforeModel = model
            }
            .disposed(by: disposeBag)
        
        ticketingAlarmModel
            .subscribe(with: self) { owner, model in
                owner.myTicketingAlarmAfterModel.accept(model)
                owner.updateDataSource()
            }
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .subscribe(with: self) { owner, _ in
                owner.usecase.requestTicketingAlarm()
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
                let currentTicketingTimeList = owner.myTicketingAlarmAfterModel.value
                owner.usecase.updateTicketingAlarm(model: currentTicketingTimeList, showID: owner.showID)
            }
            .disposed(by: disposeBag)
        
        /// 변경하기 이전과 이후 상태가 다른지 확인하는 Observable
        let isCheckedStateDifferent = myTicketingAlarmAfterModel
            .withUnretained(self)
            .map { owner, afterModels in
                let enabledBeforeModels = owner.myTicketingAlarmBeforeModel.filter { $0.isEnabled }
                let enabledAfterModels = afterModels.filter { $0.isEnabled }
                
                // 두 모델의 isChecked 값을 비교하여 하나라도 다르면 true 반환
                return zip(enabledBeforeModels, enabledAfterModels).contains { $0.isChecked != $1.isChecked }
            }
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(
            isEnabledBottomButton: isCheckedStateDifferent,
            alarmUpdateResult: usecase.updateTicketingAlarmResult.asSignal(onErrorSignalWith: .empty())
        )
    }
}

// MARK: - For NSDiffableDataSource

extension TicketingAlarmUpdateViewModel {
    
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
