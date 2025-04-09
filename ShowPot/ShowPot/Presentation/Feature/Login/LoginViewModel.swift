//
//  LoginViewModel.swift
//  ShowPot
//
//  Created by 김도형 on 4/8/25.
//

import Foundation

import Dependencies
import RxCompose
import RxSwift
import RxCocoa

final class LoginViewModel: Composer {
    enum Action {
        case kakaoLoginButtonTapped
        case googleLoginButtonTapped
        case appleLoginButtonTapped
        case login(LoginEntity)
        case loginDone
    }
    
    struct State {
        @PresentState
        var loginDone = false
    }
    
    @ComposableState
    var state = State()
    var action = PublishRelay<Action>()
    var disposeBag = DisposeBag()
    
    @Dependency(LoginUseCase.self)
    var useCase
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .kakaoLoginButtonTapped:
            return .run { [useCase = self.useCase] effect in
                let fcmToken = try await useCase.fetchFCMToken()
                let response = try await useCase.kakaoLogin()
                let loginEntity = LoginEntity(
                    socialType: .kakao,
                    identifier: response.idToken,
                    fcmToken: fcmToken
                )
                effect.onNext(.send(.login(loginEntity)))
            }
        case .googleLoginButtonTapped:
            return .run { [useCase = self.useCase] effect in
                let fcmToken = try await useCase.fetchFCMToken()
                let response = try await useCase.googleLogin()
                let loginEntity = LoginEntity(
                    socialType: .google,
                    identifier: response.idToken,
                    fcmToken: fcmToken
                )
                effect.onNext(.send(.login(loginEntity)))
            }
        case .appleLoginButtonTapped:
            return .run { [useCase = self.useCase] effect in
                let fcmToken = try await useCase.fetchFCMToken()
                let response = try await useCase.appleLogin()
                let loginEntity = LoginEntity(
                    socialType: .apple,
                    identifier: response.idToken,
                    fcmToken: fcmToken
                )
                try await useCase.appleToken()
                
                effect.onNext(.send(.login(loginEntity)))
            } catch: { error in
                print(error)
                return .none
            }
        case let .login(loginEntity):
            return .run { [useCase = self.useCase] effect in
                try await useCase.login(loginEntity)
                effect.onNext(.send(.loginDone))
            }
        case .loginDone:
            state.loginDone = true
            return .none
        }
    }
}
