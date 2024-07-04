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
    var coordinator: Coordinator
    
    init(coordinator: Coordinator) {
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
    
    func transform(input: Input) -> Output {
        
        Observable.merge(
            input.didTappedGoogleLoginButton.map { SocialLoginType.google },
            input.didTappedAppleLoginButton.map { SocialLoginType.apple },
            input.didTappedKakaoLoginButton.map { SocialLoginType.kakao }
        )
        .subscribe(with: self) { owner, type in
            switch type {
            case .google:
                owner.loginWithGoogle()
            case .apple:
                owner.loginWithApple()
            case .kakao:
                owner.loginWithKakao()
            }
        }
        .disposed(by: disposeBag)
        
        input.didTappedBackButton
            .subscribe(with: self) { owner, _ in
                // TODO: - 이건준: 로그인화면 백버튼 클릭 시 coordinator로직 구현
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}

// MARK: - SocialLogin Logics

extension LoginViewModel {
    private func loginWithGoogle() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let presentingViewController = windowScene.windows.first?.rootViewController as? LoginViewController else {
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
extension LoginViewModel {
    
    /// 소셜로그인 종류
    enum SocialLoginType {
        case google
        case kakao
        case apple
    }
}
