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
import RxCocoa

final class LoginViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    private let usecase: SignInUseCase
    
    private var fcmToken: String {
        TokenManager.shared.readToken(.pushToken) ?? ""
    }
    
    var coordinator: LoginCoordinator
    
    init(coordinator: LoginCoordinator, usecase: SignInUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        let didTappedGoogleLoginButton: Observable<Void>
        let didTappedAppleLoginButton: Observable<Void>
        let didTappedKakaoLoginButton: Observable<Void>
        let didTappedBackButton: Observable<Void>
    }
    
    struct Output {
        let trySignInResult = PublishRelay<Bool>()
    }
    
    func transform(input: Input) -> Output {
        
        let didTappedGoogleLoginButton = input.didTappedGoogleLoginButton
        let didTappedAppleLoginButton = input.didTappedAppleLoginButton
        let didTappedKakaoLoginButton = input.didTappedKakaoLoginButton
        
        didTappedGoogleLoginButton
            .subscribe(with: self) { owner, _ in
                owner.loginWithGoogle()
            }
            .disposed(by: disposeBag)
        
        didTappedKakaoLoginButton
            .subscribe(with: self) { owner, _ in
                owner.loginWithKakao()
            }
            .disposed(by: disposeBag)
        
        input.didTappedBackButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.didTappedBackButton()
            }
            .disposed(by: disposeBag)
        
        let output = Output()
        usecase.signInResult
            .bind(to: output.trySignInResult)
            .disposed(by: disposeBag)
        
        return output
    }
}

// MARK: - SocialLogin Logics

extension LoginViewModel { // TODO: - 로그인 성공시 UserManager isLoggedIn, nickname 상태값 처리 필수
    
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
        let loginClosure: (OAuthToken?, Error?) -> Void = { [weak self] oauthToken, error in
            guard error == nil else {
                // TODO: 건준 - 카카오톡 로그인 실패 Alert 띄우기
                LogHelper.error("Kakao SocialLogin Failed: \(error!)")
                return
            }
            guard let self = self,
                  let identifier = oauthToken?.idToken else { return }
            self.usecase.signIn(request: .init(
                socialType: SocialLoginType.kakao.rawValue,
                identifier: identifier,
                fcmToken: fcmToken
            ))
        }
        
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 로그인 api 호출 결과를 클로저로 전달
            UserApi.shared.loginWithKakaoTalk(completion: loginClosure)
        } else { // 웹으로 로그인 호출
            UserApi.shared.loginWithKakaoAccount(completion: loginClosure)
        }
    }
    
    func loginWithApple(userId: String) {
        self.usecase.signIn(request: .init(
            socialType: SocialLoginType.apple.rawValue,
            identifier: userId,
            fcmToken: fcmToken
        ))
    }
}

// MARK: - SocialLoginType

/// 소셜로그인 종류
enum SocialLoginType: String { // TODO: 추후 Usecase로 빼서 작업 필요
    case google = "GOOGLE"
    case kakao = "KAKAO"
    case apple = "APPLE"
    
    var buttonTitle: String {
        switch self {
        case .google:
            return Strings.socialLoginGoogleButton
        case .kakao:
            return Strings.socialLoginKakaoButton
        case .apple:
            return Strings.socialLoginAppleButton
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .google:
            return .btnBgSocialGoogle
        case .kakao:
            return .btnBgSocialKakao
        case .apple:
            return .gray800
        }
    }
    
    var foregroundColor: UIColor {
        switch self {
        case .google:
            return .gray700
        case .kakao:
            return .gray800
        case .apple:
            return .gray000
        }
    }
    
    var iconImage: UIImage {
        switch self {
        case .google:
            return .icGoogle
        case .kakao:
            return .icKakao
        case .apple:
            return .icApple
        }
    }
    
    var strokeWidth: CGFloat? {
        switch self {
        case .apple:
            return 1
        default:
            return nil
        }
    }
    
    var strokeColor: UIColor? {
        switch self {
        case .apple:
            return .gray100
        default:
            return nil
        }
    }
}
