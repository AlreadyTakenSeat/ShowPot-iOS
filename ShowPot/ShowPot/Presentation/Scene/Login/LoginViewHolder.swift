//
//  LoginViewHolder.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/11/24.
//

import UIKit

import SnapKit
import GoogleSignIn

final class LoginViewHolder {
    
    let backButton = UIButton().then {
        $0.setImage(.icArrow36Left.withTintColor(.gray000), for: .normal) // TODO: #44 애셋 네이밍 변경 이후 작업 필요
    }
    
    let logoImageView = UIImageView().then {
        $0.image = .showpot // TODO: #44 애셋 네이밍 변경 이후 작업 필요
        $0.contentMode = .scaleAspectFit
    }
    
    let alertLabel = UILabel().then {
        $0.textColor = .gray000
        $0.font = KRFont.H2
        $0.setAttributedText(font: KRFont.self, string: Strings.socialLoginDescription)
        $0.textAlignment = .center
    }
    
    let loginImageView = UIImageView().then {
        $0.image = .group1171275072 // TODO: #44 애셋 네이밍 변경 이후 작업 필요
        $0.contentMode = .scaleAspectFit
    }
    
    let socialLoginStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.spacing = 12
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: .zero, left: 16, bottom: .zero, right: 16)
    }
    
    let kakaoSignInButton = SocialLoginButton(type: .kakao)
    
    let googleSignInButton = SocialLoginButton(type: .google)
    
    let appleSignInButton = SocialLoginButton(type: .apple)
}

extension LoginViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        [backButton, logoImageView, alertLabel, loginImageView, socialLoginStackView].forEach { view.addSubview($0) }
        [kakaoSignInButton, googleSignInButton, appleSignInButton].forEach { socialLoginStackView.addArrangedSubview($0) }
    }
    
    func configureConstraints(for view: UIView) {
        
        backButton.snp.makeConstraints {
            $0.size.equalTo(36)
            $0.leading.equalToSuperview().inset(6)
            $0.top.equalToSuperview().inset(63)
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(29 + 8)
            $0.leading.equalToSuperview().inset(126)
            $0.trailing.equalToSuperview().inset(128.42)
        }
        
        alertLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(8)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(27)
        }
        
        loginImageView.snp.makeConstraints {
            $0.top.equalTo(alertLabel.snp.bottom).offset(21)
            $0.leading.equalToSuperview().inset(114)
            $0.trailing.equalToSuperview().inset(97.65)
        }
        
        socialLoginStackView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(loginImageView.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-56)
        }
        
        [kakaoSignInButton, googleSignInButton, appleSignInButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(55)
            }
        }
    }
}
