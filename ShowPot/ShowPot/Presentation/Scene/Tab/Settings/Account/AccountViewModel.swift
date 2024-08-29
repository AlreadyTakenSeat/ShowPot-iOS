//
//  AccountViewModel.swift
//  ShowPot
//
//  Created by 이건준 on 8/29/24.
//

import UIKit
import RxSwift
import RxCocoa

final class AccountViewModel: ViewModelType {
    var coordinator: AccountCoordinator
    
    private let disposeBag = DisposeBag()
    private let menuListRelay = BehaviorRelay<[AccountMenuType]>(value: [])
    
    var isLoggedIn: Bool {
        LoginState.current == .loggedIn
    }
    
    var menuList: [AccountMenuType] {
        menuListRelay.value
    }
    
    init(coordinator: AccountCoordinator) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let didTappedBackButton: Observable<Void>
        let didTappedCell: Observable<IndexPath>
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        
        Observable.just(AccountMenuType.allCases)
            .subscribe(with: self) { owner, menu in
                owner.menuListRelay.accept(menu)
            }
            .disposed(by: disposeBag)
        
        input.didTappedBackButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.popViewController()
            }
            .disposed(by: disposeBag)
        
        input.didTappedCell
            .subscribe(with: self) { owner, indexPath in
                switch AccountMenuType.allCases[indexPath.row] {
                case .logout:
                    LogHelper.debug("로그아웃 클릭")
                case .deleteAccount:
                    LogHelper.debug("계정 탈퇴 클릭")
                }
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}

enum AccountMenuType: CaseIterable {
    case logout
    case deleteAccount
    
    var title: String {
        switch self {
        case .logout:
            return "로그아웃"
        case .deleteAccount:
            return "회원 탈퇴"
        }
    }
    
    var iconImage: UIImage {
        switch self {
        case .logout:
            return .icLogout.withTintColor(.gray400)
        case .deleteAccount:
            return .icProfileDelete.withTintColor(.gray400)
        }
    }
}
