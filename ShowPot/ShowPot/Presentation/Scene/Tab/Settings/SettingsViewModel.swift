//
//  SettingViewModel.swift
//  ShowPot
//
//  Created by Daegeon Choi on 5/25/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingsViewModel: ViewModelType {
    
    var coordinator: SettingsCoordinator
    private let disposeBag = DisposeBag()
    private let usecase: MyPageUseCase
    
    private let menuListRelay = BehaviorRelay<[MypageMenuData]>(value: [])
    private let recentShowListRelay = BehaviorRelay<[ShowSummary]>(value: [])
    
    var menuList: [MypageMenuData] {
        menuListRelay.value
    }
    
    var recentShowList: [ShowSummary] {
        recentShowListRelay.value
    }

    var nickname: String? {
        UserDefaultsManager.shared.get(for: .nickname)
    }
    
    init(coordinator: SettingsCoordinator, usecase: MyPageUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let didTappedCell: Observable<IndexPath>
        let didTappedSettingButton: Observable<Void>
        let didTappedLoginButton: Observable<Void>
    }
    
    struct Output {
        let menuData: Driver<[MypageMenuData]>
        let recentShowData: Driver<[ShowSummary]>
    }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        Observable.just(MypageMenuType.allCases)
            .subscribe(with: self) { owner, menu in
                owner.menuListRelay.accept(menu.map { .init(type: $0, badgeCount: nil) })
            }
            .disposed(by: disposeBag)
        
        usecase.menuData
            .bind(to: menuListRelay)
            .disposed(by: disposeBag)
        
        usecase.recentShowData
            .bind(to: recentShowListRelay)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .subscribe(with: self) { owner, _ in
                owner.usecase.requestShowData()
                owner.usecase.requestMenuData()
            }
            .disposed(by: disposeBag)
        
        input.didTappedCell
            .subscribe(with: self) { owner, indexPath in
                switch MypageSectionType.allCases[indexPath.section] {
                case .menu:
                    switch MypageMenuType.allCases[indexPath.row] {
                    case .artist:
                        owner.coordinator.goToSubscribeArtistScreen()
                    case .genre:
                        owner.coordinator.goToSubscribeGenreScreen()
                    }
                case .recentShow:
                    LogHelper.debug("선택한 공연 모델: \(owner.recentShowListRelay.value[indexPath.row])")
                }
            }
            .disposed(by: disposeBag)
        
        input.didTappedSettingButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.goToSettingScreen()
            }
            .disposed(by: disposeBag)
        
        input.didTappedLoginButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.goToLoginScreen()
            }
            .disposed(by: disposeBag)
        
        let mypageMenuData = menuListRelay.asDriver()
        let mypageRecentShowData = recentShowListRelay.asDriver()
        
        return Output(
            menuData: mypageMenuData, 
            recentShowData: mypageRecentShowData
        )
    }
}

struct ShowSummary: Hashable {
    let id: String
    let thumbnailURL: URL?
    let title: String
    let location: String
    let time: Date?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct MypageMenuData {
    let type: MypageMenuType
    let badgeCount: Int?
}

enum MypageMenuType: CaseIterable {
    case artist
    case genre
    
    var title: String {
        switch self {
        case .artist:
            return Strings.myPageSubscribeArtistButtonTitle
        case .genre:
            return Strings.myPageSubscribeGenreButtonTitle
        }
    }
    
    var iconImage: UIImage {
        switch self {
        case .artist:
            return .icArtist.withTintColor(.gray300)
        case .genre:
            return .icGenre.withTintColor(.gray300)
        }
    }
}
