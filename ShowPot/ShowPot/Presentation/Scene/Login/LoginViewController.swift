//
//  LoginViewController.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/1/24.
//

import AuthenticationServices
import UIKit

import GoogleSignIn
import KakaoSDKUser
import KakaoSDKAuth
import RxSwift
import RxCocoa
import SnapKit
import Then

final class LoginViewController: ViewController {
    
    let viewHolder: LoginViewHolder = .init()
    let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolderConfigure()
    }
    
    override func setupStyles() {
        
    }
    
    override func bind() {
        
        // TODO: 최대건 - 애플 계정 추가 및 xcconfig 설정값 gitignore처리, SignInApple 추가
        
        let input = LoginViewModel.Input(
            didTappedGoogleLoginButton: viewHolder.googleSignInButton.rx.tap.asObservable(),
            didTappedAppleLoginButton: viewHolder.appleSignInButton.rx.tap.asObservable(),
            didTappedKakaoLoginButton: viewHolder.kakaoSignInButton.rx.tap.asObservable(),
            didTappedBackButton: viewHolder.backButton.rx.tap.asObservable()
        )
        
        viewModel.transform(input: input)
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    /// Apple 인증 요청이 성공적으로 완료되었을 때 호출되는 함수
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
      switch authorization.credential { // Apple ID 인증 정보가 제공된 경우
      case let credentials as ASAuthorizationAppleIDCredential:
        let authorizationCode = String(decoding: credentials.authorizationCode!, as: UTF8.self)
        let identityToken = String(decoding: credentials.identityToken!, as: UTF8.self)
        
      default:
        break
      }
    }
    
    /// Apple 로그인 인증 요청이 실패했을 때 호출되는 함수
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
      // TODO: 이건준 - 애플 로그인 에러 Alert 띄우기
        LogHelper.debug("Apple Login Failed!: \(error)")
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    
    /// Apple ID 로그인 UI를 표시할 윈도우를 지정하는 함수
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
      return view.window!
    }
}
