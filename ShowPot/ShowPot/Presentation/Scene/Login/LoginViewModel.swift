//
//  LoginViewModel.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/1/24.
//

import AuthenticationServices

import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKUser
import RxSwift

final class LoginViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    var coordinator: LoginCoordinator
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let didTappedGoogleLoginButton: Observable<Void>
        let didTappedAppleLoginButton: Observable<Void>
        let didTappedKakaoLoginButton: Observable<Void>
        let didTappedBackButton: Observable<Void>
    }
    
    struct Output {
        
    }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        let didTappedGoogleLoginButton = input.didTappedGoogleLoginButton.map { SocialLoginType.google }
        let didTappedAppleLoginButton = input.didTappedGoogleLoginButton.map { SocialLoginType.apple }
        let didTappedKakaoLoginButton = input.didTappedGoogleLoginButton.map { SocialLoginType.kakao }
        
        Observable.merge(
            didTappedGoogleLoginButton,
            didTappedAppleLoginButton,
            didTappedKakaoLoginButton
        )
        .subscribe(with: self) { owner, type in
            owner.requestSocialLogin(with: type)
        }
        .disposed(by: disposeBag)
        
        input.didTappedBackButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.didTappedBackButton()
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}

// MARK: - SocialLogin Logics

extension LoginViewModel {
    private func requestSocialLogin(with type: SocialLoginType) {
        switch type {
        case .google:
            loginWithGoogle()
        case .kakao:
            loginWithKakao()
        case .apple:
            loginWithApple()
        }
    }
    
    private func loginWithGoogle() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController as? UINavigationController,
              let presentingViewController = rootViewController.topViewController as? LoginViewController else {
            return
        }
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
            guard error == nil else {
                LogHelper.error("Google SocialLogin Failed: \(error!)")
                return
            }
            
        }
    }
    
    private func loginWithKakao() {
        let loginClosure: (OAuthToken?, Error?) -> Void = { oauthToken, error in
            guard error == nil else {
                // TODO: 건준 - 카카오톡 로그인 실패 Alert 띄우기
                LogHelper.error("Kakao SocialLogin Failed: \(error!)")
                return
            }
            
        }
        
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 로그인 api 호출 결과를 클로저로 전달
            UserApi.shared.loginWithKakaoTalk(completion: loginClosure)
        } else { // 웹으로 로그인 호출
            UserApi.shared.loginWithKakaoAccount(completion: loginClosure)
        }
    }
    
    private func loginWithApple() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController as? UINavigationController,
              let presentingViewController = rootViewController.topViewController as? LoginViewController else {
            return
        }
    
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = presentingViewController
        controller.presentationContextProvider = presentingViewController
        controller.performRequests()
    }
}

// MARK: - SocialLoginType

/// 소셜로그인 종류
enum SocialLoginType { // TODO: 추후 Usecase로 빼서 작업 필요
    case google
    case kakao
    case apple
}
