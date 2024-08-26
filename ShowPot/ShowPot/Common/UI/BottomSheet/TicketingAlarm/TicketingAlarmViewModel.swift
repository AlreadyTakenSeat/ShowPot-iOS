//
//  TicketingAlarmViewModel.swift
//  ShowPot
//
//  Created by 이건준 on 8/24/24.
//

import UIKit

import RxSwift
import RxCocoa

struct TicketingAlarmState {
    let isSelected: Bool
    let isEnabled: Bool
    let alertTitle: String
}

final class TicketingAlarmViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    private let showID: String
    
    /// 알림 설정을 위한 모델
    private let myTicketingAlarmModel = BehaviorRelay<[TicketingAlarmCellModel]>(value: [])
    
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
        
        usecase.ticketingAlarm
            .subscribe(with: self) { owner, model in
                owner.myTicketingAlarmModel.accept(model)
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
                var currentTicketingTimeList = owner.myTicketingAlarmModel.value
                LogHelper.debug("티켓팅 알림 시간 선택: \(currentTicketingTimeList[indexPath.row].ticketingAlertText)")
                guard currentTicketingTimeList[indexPath.row].isEnabled else { return }
                currentTicketingTimeList[indexPath.row].isChecked.toggle()
                owner.myTicketingAlarmModel.accept(currentTicketingTimeList)
                owner.updateDataSource()
            }
            .disposed(by: disposeBag)
        
        input.didTappedUpdateButton
            .subscribe(with: self) { owner, _ in
                let currentTicketingTimeList = owner.myTicketingAlarmModel.value
                owner.usecase.updateTicketingAlarm(model: currentTicketingTimeList, showID: owner.showID)
            }
            .disposed(by: disposeBag)
        
        let isEnabledBottomButton = myTicketingAlarmModel
            .map { !$0.filter { $0.isEnabled && $0.isChecked }.isEmpty }
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(
            isEnabledBottomButton: isEnabledBottomButton,
            alarmUpdateResult: usecase.updateTicketingAlarmResult.asSignal(onErrorSignalWith: .empty())
        )
    }
}

// MARK: - For NSDiffableDataSource

extension TicketingAlarmViewModel {
    
    typealias Item = TicketingAlarmCellModel
    typealias DataSource = UICollectionViewDiffableDataSource<TicketingAlarmSection, Item>
    
    /// 티켓팅 알람 섹션 타입
    enum TicketingAlarmSection {
        case main
    }
    
    private func updateDataSource() {
        let ticketingTimeList = myTicketingAlarmModel.value
        var snapshot = NSDiffableDataSourceSnapshot<TicketingAlarmSection, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(ticketingTimeList)
        dataSource?.apply(snapshot)
    }
}
