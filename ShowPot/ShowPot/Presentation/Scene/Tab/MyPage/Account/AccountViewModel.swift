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
    private let usecase: AccountUseCase
    private let menuListRelay = BehaviorRelay<[AccountMenuType]>(value: [])
    
    private var isLoggedIn: Bool {
        LoginState.current == .loggedIn
    }
    
    var userProfileInfo: UserProfileInfo? {
        guard isLoggedIn else { return nil }
        return UserDefaultsManager.shared.get(objectForkey: .userProfileInfo, type: UserProfileInfo.self)
    }
    
    var menuList: [AccountMenuType] {
        menuListRelay.value
    }
    
    init(coordinator: AccountCoordinator, usecase: AccountUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let didTappedBackButton: Observable<Void>
        let didTappedCell: Observable<IndexPath>
    }
    
    struct Output { 
        /// 로그아웃 요청 결과
        var logoutResult = PublishSubject<Bool>()
        /// 회원 탈퇴 요청 결과
        var deleteAccountResult = PublishSubject<Bool>()
    }
    
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
                    owner.usecase.logout()
                case .deleteAccount:
                    owner.usecase.deleteAccount()
                }
            }
            .disposed(by: disposeBag)
        
        let output = Output()
        
        usecase.logoutResult
            .do(onNext: { [weak self] success in
                guard let self = self else { return }
                if success {
                    self.coordinator.popViewController(logoutSuccess: success)
                }
            })
            .bind(to: output.logoutResult)
            .disposed(by: disposeBag)
        
        usecase.deleteAccountResult
            .do(onNext: { [weak self] success in
                guard let self = self else { return }
                if success {
                    self.coordinator.popViewController(withdrawSuccess: success)
                }
            })
            .bind(to: output.deleteAccountResult)
            .disposed(by: disposeBag)
        
        return output
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
