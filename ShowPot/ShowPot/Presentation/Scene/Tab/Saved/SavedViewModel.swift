//
//  SavedViewModel.swift
//  ShowPot
//
//  Created by Daegeon Choi on 5/25/24.
//

import UIKit

import RxSwift
import RxCocoa

struct MyShowMenuData {
    let type: MyAlarmMenuType
    let badgeCount: Int?
}

struct ShowData {
    let artistName: String
    let remainDay: Int?
    let backgroundImage: UIImage
    let thubnailURL: URL?
    let name: String
    let location: String
    let startTime: Date?
    let endTime: Date?
    let ticketingOpenTime: Date?
}

final class SavedViewModel: ViewModelType {
    
    var coordinator: SavedCoordinator
    private let usecase: MyAlarmUseCase
    private let disposeBag = DisposeBag()
    
    private var isLoggedIn: Bool {
        UserDefaultsManager.shared.get(for: .isLoggedIn) ?? false
    }
    
    private let alarmMenuModelRelay = BehaviorRelay<[MyShowMenuData]>(value: [])
    private let upcomingTicketingModelRelay = BehaviorRelay<[ShowData]>(value: [])
    private let currentHeaderModelRelay = BehaviorRelay<ShowData?>(value: nil)
    
    init(coordinator: SavedCoordinator, usecase: MyAlarmUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let didTappedMenu: Observable<IndexPath>
        let didEndScrolling: Observable<IndexPath>
        let didTappedLoginButton: Observable<Void>
        let didTappedUpcomingCell: Observable<IndexPath>
    }
    
    struct Output {
        let alarmMenuModel: Driver<[MyShowMenuData]>
        let upcomingTicketingModel: Driver<[ShowData]>
        let currentHeaderModel: Driver<ShowData>
        let upcomingIsEmpty: Driver<(Bool, Bool)>
    }
    
    func transform(input: Input) -> Output {
        
        Observable.just(MyAlarmMenuType.allCases)
            .subscribe(with: self) { owner, model in
                owner.alarmMenuModelRelay.accept(model.map { .init(type: $0, badgeCount: nil) })
            }
            .disposed(by: disposeBag)
        
        let shareShowObservable = usecase.upcomingShowList.share()
        
        shareShowObservable
            .filter { !$0.isEmpty }
            .take(1)
            .subscribe(with: self) { owner, model in
                guard let firstModel = model.first else { return }
                owner.currentHeaderModelRelay.accept(firstModel)
            }
            .disposed(by: disposeBag)
        
        shareShowObservable
            .bind(to: upcomingTicketingModelRelay)
            .disposed(by: disposeBag)
        
        usecase.menuList
            .bind(to: alarmMenuModelRelay)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .subscribe(with: self) { owner, _ in
                owner.usecase.requestMenuData()
                owner.usecase.requestUpcomingShow()
            }
            .disposed(by: disposeBag)
        
        input.didTappedMenu
            .subscribe(with: self) { owner, indexPath in
                let menuModel = MyAlarmMenuType.allCases[indexPath.row]
                switch menuModel {
                case .alarmPerformance:
                    owner.coordinator.goToMyPerformanceAlarmScreen()
                case .interestShow:
                    owner.coordinator.goToInterestShowScreen()
                case .endShow:
                    owner.coordinator.goToEndShowScreen()
                }
            }
            .disposed(by: disposeBag)
        
        input.didTappedLoginButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.goToLoginScreen()
            }
            .disposed(by: disposeBag)
        
        input.didTappedUpcomingCell
            .subscribe(with: self) { owner, indexPath in
                var model = owner.usecase.upcomingShowList.value
                LogHelper.debug("선택된 셀 모델: \(model[indexPath.row])")
            }
            .disposed(by: disposeBag)
        
        input.didEndScrolling
            .distinctUntilChanged()
            .subscribe(with: self) { owner, indexPath in
                let currentVisibleModel = owner.usecase.upcomingShowList.value[indexPath.row]
                owner.currentHeaderModelRelay.accept(currentVisibleModel)
            }
            .disposed(by: disposeBag)
        
        return Output(
            alarmMenuModel: alarmMenuModelRelay.asDriver(),
            upcomingTicketingModel: upcomingTicketingModelRelay.asDriver(),
            currentHeaderModel: currentHeaderModelRelay.compactMap { $0 }.asDriver(onErrorDriveWith: .empty()), 
            upcomingIsEmpty: upcomingTicketingModelRelay.map { ($0.isEmpty, self.isLoggedIn) }.asDriver(onErrorDriveWith: .empty())
        )
    }
}
