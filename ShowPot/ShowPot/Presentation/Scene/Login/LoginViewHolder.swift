//
//  LoginViewHolder.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/11/24.
//

import Foundation
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
        $0.layoutMargins = .init(top: .zero, left: 20, bottom: 56, right: 20)
    }
    
    let kakaoSignInButton = UIButton().then {
        $0.setImage(UIImage(resource: .kakao), for: .normal)
        $0.layer.cornerRadius = 2
        $0.layer.masksToBounds = true
    }
    
    let googleSignInButton = UIButton().then {
        $0.setImage(UIImage(resource: .google), for: .normal)
        $0.layer.cornerRadius = 2
        $0.layer.masksToBounds = true
    }
    
    let appleSignInButton = UIButton().then {
        $0.setImage(UIImage(resource: .apple), for: .normal)
        $0.layer.cornerRadius = 2
        $0.layer.masksToBounds = true
    }
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
            $0.top.equalTo(alertLabel.snp.bottom).offset(42)
            $0.leading.equalToSuperview().inset(114)
            $0.trailing.equalToSuperview().inset(97.65)
        }
        
        socialLoginStackView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(loginImageView.snp.bottom)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
        
        kakaoSignInButton.snp.makeConstraints {
            $0.height.equalTo(55)
        }
        
        googleSignInButton.snp.makeConstraints {
            $0.height.equalTo(55)
        }
        
        appleSignInButton.snp.makeConstraints {
            $0.height.equalTo(55)
        }
    }
    
}
