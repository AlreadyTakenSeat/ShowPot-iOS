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
final class SocialLoginButton: UIButton {
    
    private let type: SocialLoginType
    
    init(type: SocialLoginType) {
        self.type = type
        super.init(frame: .zero)
        setupStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        var configuration = setButtonConfiguration(with: type)
        var attributedTitle = setButtonAttributedString(with: type)
        configuration.attributedTitle = attributedTitle
        self.configuration = configuration
    }
}

// MARK: - Helper For UIButton+Configuration

extension SocialLoginButton {
    private func setButtonConfiguration(with type: SocialLoginType) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.background.cornerRadius = 2
        configuration.imagePadding = 12
        
        switch type {
        case .google:
            configuration.baseBackgroundColor = .googleWhite
            configuration.image = .google // TODO: #44 애셋 네이밍 변경 이후 작업 필요
            configuration.baseForegroundColor = .gray700
        case .kakao:
            configuration.baseBackgroundColor = .kakaoYellow
            configuration.image = .kakao // TODO: #44 애셋 네이밍 변경 이후 작업 필요
            configuration.baseForegroundColor = .gray800
        case .apple:
            configuration.baseBackgroundColor = .gray800
            configuration.image = .apple // TODO: #44 애셋 네이밍 변경 이후 작업 필요
            configuration.baseForegroundColor = .white // TODO: #44 애셋 네이밍 변경 이후 작업 필요
            layer.borderColor = UIColor.gray100.cgColor
            layer.borderWidth = 1
        }
        return configuration
    }
    
    private func setButtonAttributedString(with type: SocialLoginType) -> AttributedString {
        var attributedTitle: AttributedString
        
        switch type {
        case .google:
            attributedTitle = AttributedString(Strings.socialLoginGoogleButton) // TODO: #37 lineHeight + letterSpacing 적용
        case .kakao:
            attributedTitle = AttributedString(Strings.socialLoginKakaoButton) // TODO: #37 lineHeight + letterSpacing 적용
        case .apple:
            attributedTitle = AttributedString(Strings.socialLoginAppleButton) // TODO: #37 lineHeight + letterSpacing 적용
        }
        
        attributedTitle.font = KRFont.H2 // TODO: #37 lineHeight + letterSpacing 적용
        return attributedTitle
    }
}
