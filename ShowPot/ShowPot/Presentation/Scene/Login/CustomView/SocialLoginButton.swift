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
        let attributedTitle = setupButtonAttributedString(with: type)
        let configuration = setupButtonConfiguration(with: type, attributedTitle: attributedTitle)
        self.configuration = configuration
    }
}

// MARK: - Social Login Button Configuration

extension SocialLoginButton {
    
    /// 소셜로그인타입에 따른 UIButton.Configuration을 반환하는 함수
    private func setupButtonConfiguration(with type: SocialLoginType, attributedTitle: AttributedString) -> UIButton.Configuration {
        var configuration: UIButton.Configuration
        switch type {
        case .google:
            configuration = createButtonConfiguration(
                baseBackgroundColor: .btnBgSocialGoogle,
                baseForegroundColor: .gray700,
                image: .icGoogle
            )
        case .kakao:
            configuration = createButtonConfiguration(
                baseBackgroundColor: .btnBgSocialKakao,
                baseForegroundColor: .gray800,
                image: .icKakao
            )
        case .apple:
            configuration = createButtonConfiguration(
                baseBackgroundColor: .gray800,
                baseForegroundColor: .gray000,
                image: .icApple,
                strokeWidth: 1,
                strokeColor: .gray100
            )
        }
        configuration.attributedTitle = attributedTitle
        return configuration
    }
    
    /// 버튼에 대한 configuration을 생성하는 함수
    private func createButtonConfiguration(baseBackgroundColor: UIColor, baseForegroundColor: UIColor, image: UIImage, strokeWidth: CGFloat? = nil, strokeColor: UIColor? = nil) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .fixed
        configuration.background.cornerRadius = 2
        configuration.imagePadding = 12
        configuration.baseBackgroundColor = baseBackgroundColor
        configuration.baseForegroundColor = baseForegroundColor
        configuration.image = image
        configuration.background.strokeWidth = strokeWidth ?? 0.0
        configuration.background.strokeColor = strokeColor
        return configuration
    }
    
    /// SocialLoginType에 따라 사용될 AttributedString을 반환하는 함수
    private func setupButtonAttributedString(with type: SocialLoginType) -> AttributedString {
        let attributedString: AttributedString
        
        switch type {
        case .google:
            attributedString = createButtonAttributedString(string: Strings.socialLoginGoogleButton, font: KRFont.H2.font)
        case .kakao:
            attributedString = createButtonAttributedString(string: Strings.socialLoginKakaoButton, font: KRFont.H2.font)
        case .apple:
            attributedString = createButtonAttributedString(string: Strings.socialLoginAppleButton, font: KRFont.H2.font)
        }
        return attributedString
    }
    
    /// 버튼에 대한 AttributedString을 생성하는 함수
    private func createButtonAttributedString(string: String, font: UIFont) -> AttributedString {
        let buttonTitleLabel = UILabel()
        buttonTitleLabel.setAttributedText(font: KRFont.H2, string: string)
        
        guard let attributedText = buttonTitleLabel.attributedText else {
            fatalError("Attributed text should not be nil")
        }
        var attributedString = AttributedString(attributedText)
        attributedString.font = font
        return attributedString
    }
}
