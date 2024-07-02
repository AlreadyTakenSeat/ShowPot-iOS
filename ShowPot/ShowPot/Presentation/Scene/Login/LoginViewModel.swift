//
//  LoginViewModel.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/1/24.
//

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
        let didTappedSocialLoginButton: Observable<SocialLoginType>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        input.didTappedSocialLoginButton
            .subscribe(with: self) { owner, type in
                switch type {
                    case .apple:
                        break
                    case .google:
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                              let presentingViewController = windowScene.windows.first?.rootViewController else {
                            return
                        }
                        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
                            guard error == nil else { return }
                            
                        }
                    case .kakao:
                        let loginClosure: (OAuthToken?, Error?) -> Void = { oauthToken, error in
                            guard error == nil else {
                                // TODO: 건준 - 카카오톡 로그인 실패 Alert 띄우기
                                print(error!)
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
            }
            .disposed(by: disposeBag)
        
        return Output()
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
