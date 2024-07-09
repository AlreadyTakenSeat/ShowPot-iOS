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
        $0.setImage(UIImage(resource: .icArrow36Left).withTintColor(.white), for: .normal)
    }
    
    let logoImageView = UIImageView().then {
        $0.image = UIImage(resource: .showpot)
        $0.contentMode = .scaleAspectFit
    }
    
    let alertLabel = UILabel().then {
        $0.text = Strings.socialLoginDescription
        $0.textColor = .white
        $0.font = KRFont.H2
        $0.textAlignment = .center
    }
    
    let loginImageView = UIImageView().then {
        $0.image = UIImage(resource: .group1171275072)
        $0.contentMode = .scaleAspectFit
    }
    
    let socialLoginStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.spacing = 12
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: .zero, left: 16, bottom: 56, right: 16)
    }
    
    let kakaoSignInButton = SocialLoginButton(type: .kakao)
    
    let googleSignInButton = SocialLoginButton(type: .google)
    
    let appleSignInButton = SocialLoginButton(type: .apple)
}

extension LoginViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        _ = [backButton, logoImageView, alertLabel, loginImageView, socialLoginStackView].map { view.addSubview($0) }
        _ = [kakaoSignInButton, googleSignInButton, appleSignInButton].map { socialLoginStackView.addArrangedSubview($0) }
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
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
        
        [kakaoSignInButton, googleSignInButton, appleSignInButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(55)
            }
        }
    }
    
}

// MARK: - 소셜로그인버튼 UI

extension LoginViewHolder {
    final class SocialLoginButton: UIView {
        
        private let type: SocialLoginType
        
        let button = UIButton()
        
        private let containerView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.alignment = .center
        }
        
        private let socialLoginImageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
        }
        
        private let socialLoginDescriptionLabel = UILabel().then {
            $0.textAlignment = .left
            $0.font = KRFont.H2
        }
        
        init(type: SocialLoginType) {
            self.type = type
            super.init(frame: .zero)
            setupLayouts()
            setupConstraints()
            setupStyles(type: type)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupLayouts() {
            _ = [containerView, button].map { addSubview($0) }
            _ = [socialLoginImageView, socialLoginDescriptionLabel].map { containerView.addArrangedSubview($0) }
        }
        
        private func setupConstraints() {
            containerView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
            button.snp.makeConstraints {
                $0.directionalEdges.equalToSuperview()
            }
            
            socialLoginImageView.snp.makeConstraints {
                $0.size.equalTo(24)
            }
        }
        
        private func setupStyles(type: SocialLoginType) {
            
            layer.cornerRadius = 2
            layer.masksToBounds = true
            
            switch type {
                case .google:
                    backgroundColor = .white
                    socialLoginImageView.image = UIImage(resource: .google)
                    socialLoginDescriptionLabel.textColor = .gray700
                    socialLoginDescriptionLabel.text = Strings.socialLoginGoogleTitle
                case .kakao:
                    backgroundColor = UIColor(resource: .kakaoYellow)
                    socialLoginImageView.image = UIImage(resource: .kakao)
                    socialLoginDescriptionLabel.textColor = .gray800
                    socialLoginDescriptionLabel.text = Strings.socialLoginKakaoTitle
                case .apple:
                    backgroundColor = .gray800
                    socialLoginImageView.image = UIImage(resource: .apple)
                    socialLoginDescriptionLabel.textColor = .white
                    socialLoginDescriptionLabel.text = Strings.socialLoginAppleTitle
                    layer.borderColor = UIColor.gray100.cgColor
                    layer.borderWidth = 1
            }
        }
        
    }

}
