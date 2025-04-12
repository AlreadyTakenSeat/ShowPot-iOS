//
//  AccountViewModel.swift
//  ShowPot
//
//  Created by 김도형 on 4/6/25.
//

import Foundation

import Dependencies
import RxCompose
import RxSwift
import RxCocoa

final class AccountViewModel: Composer {
    enum Action {
        case logoutCellTapped
        case withdrawCellTapped
        case logoutAlertButtonTapped
        case withdrawAlertButtonTapped
    }
    
    struct State {
        var profile: ProfileEntity = .mock
        @PresentState
        var showLogoutAlert = false
        @PresentState
        var showWithdrawAlert = false
    }
    
    /// 임시
    @Dependency(\.usersRepository)
    private var usersRepository
    
    @ComposableState
    var state = State()
    var action = PublishRelay<Action>()
    var disposeBag = DisposeBag()
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .logoutCellTapped:
            state.showLogoutAlert = true
            return .none
        case .withdrawCellTapped:
            state.showWithdrawAlert = true
            return .none
        case .logoutAlertButtonTapped:
            state.showLogoutAlert = false
            return .run { [repository = self.usersRepository] effect in
                try await repository.logout()
            }
        case .withdrawAlertButtonTapped:
            state.showWithdrawAlert = false
            return .run { [repository = self.usersRepository] effect in
                try await repository.withdrawal()
            }
        }
    }
}
