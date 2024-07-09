//
//  SocialLoginButton.swift
//  ShowPot
//
//  Created by 이건준 on 7/10/24.
//

import UIKit

import SnapKit
import Then

/// 소셜로그인에 사용되는 버튼 UI
final class SocialLoginButton: UIView {
    
    private let type: SocialLoginType
    
    let button = UIButton()
    
    private let containerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.alignment = .center
    }
    
    private let socialLoginImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let socialLoginDescriptionLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = KRFont.H2 // TODO: #37 lineHeight + letterSpacing 적용
    }
    
    init(type: SocialLoginType) {
        self.type = type
        super.init(frame: .zero)
        setupLayouts()
        setupConstraints()
        setupStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        [containerStackView, button].forEach { addSubview($0) }
        [socialLoginImageView, socialLoginDescriptionLabel].forEach { containerStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        containerStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        socialLoginImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
    
    private func setupStyles() {
        
        layer.cornerRadius = 2
        layer.masksToBounds = true
        
        switch type {
            case .google:
                backgroundColor = .white
                socialLoginImageView.image = UIImage(resource: .google) // TODO: #44 애셋 네이밍 변경 이후 작업 필요
                socialLoginDescriptionLabel.textColor = .gray700
                socialLoginDescriptionLabel.text = Strings.socialLoginGoogleButton
            case .kakao:
                backgroundColor = UIColor(resource: .kakaoYellow)
                socialLoginImageView.image = UIImage(resource: .kakao) // TODO: #44 애셋 네이밍 변경 이후 작업 필요
                socialLoginDescriptionLabel.textColor = .gray800
                socialLoginDescriptionLabel.text = Strings.socialLoginKakaoButton
            case .apple:
                backgroundColor = .gray800
                socialLoginImageView.image = UIImage(resource: .apple) // TODO: #44 애셋 네이밍 변경 이후 작업 필요
                socialLoginDescriptionLabel.textColor = .white
                socialLoginDescriptionLabel.text = Strings.socialLoginAppleButton
                layer.borderColor = UIColor.gray100.cgColor
                layer.borderWidth = 1
        }
    }
    
}
