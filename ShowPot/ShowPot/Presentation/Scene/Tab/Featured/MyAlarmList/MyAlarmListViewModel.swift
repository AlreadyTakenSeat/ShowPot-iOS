//
//  MyAlarmListViewModel.swift
//  ShowPot
//
//  Created by 이건준 on 9/23/24.
//

import Foundation

import RxSwift
import RxCocoa

final class MyAlarmListViewModel: ViewModelType {

    private let disposeBag = DisposeBag()
    private let usecase: MyAlarmListUseCase
    
    var coordinator: MyAlarmListCoordinator

    init(coordinator: MyAlarmListCoordinator, usecase: MyAlarmListUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }

    struct Input {
        let didTappedBackButton: Observable<Void>
        let didTappedAlarmCell: Observable<IndexPath>
    }

    struct Output {
        let myAlarmModel = BehaviorRelay<[MyAlarmInfo]>(value: [])
        let isAlarmEmpty = PublishRelay<Bool>()
    }

    func transform(input: Input) -> Output {
        
        let output = Output()
        
        input.didTappedBackButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.popViewController()
            }
            .disposed(by: disposeBag)
        
        input.didTappedAlarmCell
            .subscribe(with: self) { owner, indexPath in
                let selectedAlarmModel = owner.usecase.myAlarmModel.value[indexPath.row]
                LogHelper.debug("선택된 알림 정보: \(selectedAlarmModel)")
            }
            .disposed(by: disposeBag)
        
        let sharedAlarmModel = usecase.myAlarmModel.share(replay: 1)

        sharedAlarmModel
            .map { $0.isEmpty }
            .bind(to: output.isAlarmEmpty)
            .disposed(by: disposeBag)
        
        sharedAlarmModel
            .bind(to: output.myAlarmModel)
            .disposed(by: disposeBag)
        
        return output
    }
}

struct MyAlarmInfo {
    let thumbnailImageURL: URL?
    let mainAlarm: String
    let subAlarm: String
    let timeLeft: String
}
