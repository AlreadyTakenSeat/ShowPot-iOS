//
//  MyPageViewModel.swift
//  ShowPot
//
//  Created by Daegeon Choi on 5/25/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MyPageViewModel: ViewModelType {
    
    var coordinator: MyPageCoordinator
    private let disposeBag = DisposeBag()
    private let usecase: MyPageUseCase
    
    private let menuListRelay = BehaviorRelay<[MypageMenuData]>(value: [])
    
    var menuList: [MypageMenuData] {
        menuListRelay.value
    }
    
    var isLoggedIn: Bool {
        LoginState.current == .loggedIn
    }
    
    var userProfileInfo: UserProfileInfo? {
        guard isLoggedIn else { return nil }
        return UserDefaultsManager.shared.get(objectForkey: .userProfileInfo, type: UserProfileInfo.self)
    }
    
    init(coordinator: MyPageCoordinator, usecase: MyPageUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let didTappedCell: Observable<IndexPath>
        let didTappedSettingButton: Observable<Void>
        let didTappedLoginButton: Observable<Void>
    }
    
    struct Output { }
    
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
        
        input.viewDidLoad
            .subscribe(with: self) { owner, _ in
                owner.usecase.requestMenuData()
            }
            .disposed(by: disposeBag)
        
        input.didTappedCell
            .subscribe(with: self) { owner, indexPath in
                switch MypageMenuType.allCases[indexPath.row] {
                case .artist:
                    owner.coordinator.goToSubscribeArtistScreen()
                case .genre:
                    owner.coordinator.goToSubscribeGenreScreen()
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
        
        return Output()
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
