//
//  SavedViewModel.swift
//  ShowPot
//
//  Created by Daegeon Choi on 5/25/24.
//

import UIKit

import RxSwift
import RxCocoa

struct MyMenuData {
    let type: MyAlarmMenuType
    let badgeCount: Int
}

struct ArtistShowInfo {
    let artistName: String
    let remainDay: String
}

struct MyShowData {
    let backgroundImage: UIImage
    let showThubnailURL: URL?
    let showName: String
    let showLocation: String
    let showStartTime: Date?
    let showEndTime: Date?
    let ticketingOpenTime: Date?
}

final class SavedViewModel: ViewModelType {
    
    var coordinator: SavedCoordinator
    private let usecase: MyAlarmUseCase
    private let disposeBag = DisposeBag()
    
    private var isLoggedIn: Bool {
        UserDefaultsManager.shared.get(for: .isLoggedIn) ?? false
    }
    
    private let alarmMenuModelRelay = BehaviorRelay<[MyMenuData]>(value: [])
    private let upcomingTicketingModelRelay = BehaviorRelay<[MyShowData]>(value: [])
    private let currentHeaderModelRelay = BehaviorRelay<ArtistShowInfo?>(value: nil)
    
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
        let alarmMenuModel: Driver<[MyMenuData]>
        let upcomingTicketingModel: Driver<[MyShowData]>
        let currentHeaderModel: Driver<ArtistShowInfo>
        let upcomingIsEmpty: Driver<(Bool, Bool)>
    }
    
    func transform(input: Input) -> Output {
        
        usecase.showArtistList
            .subscribe(with: self) { owner, data in
                guard let firstData = data.first else { return }
                owner.currentHeaderModelRelay.accept(.init(
                    artistName: firstData.artistName,
                    remainDay: firstData.remainDay
                ))
            }
            .disposed(by: disposeBag)
        
        usecase.upcomingShowList
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
                let menuModel = owner.alarmMenuModelRelay.value
                switch menuModel[indexPath.row].type {
                case .alarmPerformance:
                    owner.coordinator.goToMyPerformanceAlarmScreen()
                case .artist:
                    owner.coordinator.goToSubscribeArtistScreen()
                case .genre:
                    owner.coordinator.goToSubscribeGenreScreen()
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
                let currentVisibleModel = owner.usecase.showArtistList.value[indexPath.row]
                owner.currentHeaderModelRelay.accept(.init(
                    artistName: currentVisibleModel.artistName,
                    remainDay: currentVisibleModel.remainDay
                ))
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

/// 내 알림 메뉴 타입
enum MyAlarmMenuType: CaseIterable {
    case alarmPerformance
    case artist
    case genre
    
    var menuTitle: String {
        switch self {
        case .alarmPerformance:
            return Strings.myAlarmMenuButton1
        case .artist:
            return Strings.myAlarmMenuButton2
        case .genre:
            return Strings.myAlarmMenuButton3
        }
    }
    
    var menuImage: UIImage {
        switch self {
        case .alarmPerformance:
            return .icAlarm.withTintColor(.gray300)
        case .artist:
            return .icArtist.withTintColor(.gray300)
        case .genre:
            return .icGenre.withTintColor(.gray300)
        }
    }
    
    static func menuType(title: String) -> Self {
        guard let type = MyAlarmMenuType.allCases.first(where: { $0.menuTitle == title }) else {
            fatalError("Not Found MyAlarmMenuType")
        }
        return type
    }
}
