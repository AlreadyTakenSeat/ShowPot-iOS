//
//  LoginViewController.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/1/24.
//

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
        
        // TODO: 최대건 - 애플 계정 추가 및 Google clientID, URL Schemes xcconfig로 빼기
        
        viewHolder.googleSignInButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let input = LoginViewModel.Input(didTappedSocialLoginButton: .just(.google))
                _ = owner.viewModel.transform(input: input)
            }
            .disposed(by: disposeBag)
        
        viewHolder.kakaoSignInButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let input = LoginViewModel.Input(didTappedSocialLoginButton: .just(.kakao))
                _ = owner.viewModel.transform(input: input)
            }
            .disposed(by: disposeBag)
        
        viewHolder.appleSignInButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let input = LoginViewModel.Input(didTappedSocialLoginButton: .just(.apple))
                _ = owner.viewModel.transform(input: input)
            }
            .disposed(by: disposeBag)
    }
}
