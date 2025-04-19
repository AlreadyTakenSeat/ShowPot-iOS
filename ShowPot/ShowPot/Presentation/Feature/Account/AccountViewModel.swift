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
        case viewDidLoad
        case mutatedProfile(ProfileEntity)
        case mutatedLoginMessage(String)
        case mutatedDismiss
        case bottomSheetButtonTapped
        case loginViewModel(LoginViewModel.Action)
        case delegate(Delegate)
        
        enum Delegate {
            case loginDone
        }
    }
    
    struct State {
        var profile: ProfileEntity?
        @PresentState
        var showLogoutAlert = false
        @PresentState
        var showWithdrawAlert = false
        @PresentState
        var loginMessage: String?
        @PresentState
        var dismiss = false
        @PresentState
        var loginViewModel: LoginViewModel?
        @PresentState
        var isLoading: Bool = false
    }
    
    @Dependency(AccountUseCase.self)
    private var useCase
    
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
            return .run { [useCase = self.useCase] effect in
                try await useCase.logout()
                effect.onNext(.send(.mutatedDismiss))
            }
        case .withdrawAlertButtonTapped:
            state.showWithdrawAlert = false
            return .run { [useCase = self.useCase] effect in
                try await useCase.withdrawal()
                try await useCase.appleRevoke()
                effect.onNext(.send(.mutatedDismiss))
            } catch: { error in
                print(error)
                return .none
            }
        case .viewDidLoad:
            state.isLoading = true
            return fetchProfile()
        case let .mutatedProfile(profile):
            state.profile = profile
            state.isLoading = false
            return .none
        case let .mutatedLoginMessage(message):
            state.loginMessage = message
            return .none
        case .mutatedDismiss:
            state.dismiss = true
            return .none
        case .bottomSheetButtonTapped:
            let viewModel = LoginViewModel()
            state.loginViewModel = viewModel
            return .run(viewModel.action.map {
                .loginViewModel($0)
            })
        case .loginViewModel(.delegate(.loginDone)):
            return .merge(
                fetchProfile(),
                .send(.delegate(.loginDone))
            )
        case .loginViewModel: return .none
        case .delegate: return .none
        }
    }
}

// MARK: - Functions
private extension AccountViewModel {
    func fetchProfile() -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            let response = try await useCase.profile()
            effect.onNext(.send(.mutatedProfile(response)))
        } catch: { error in
            switch error {
            case SPError.tokenNotFound,
                 SPError.reissueFail:
                return .send(.mutatedLoginMessage("로그인 후 다채로운\n내한공연을 만나보세요."))
            default: return .none
            }
        }
    }
}
