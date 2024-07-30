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
        let attributedTitle = NSAttributedString(type.buttonTitle, fontType: KRFont.H2)
        let configuration = setupButtonConfiguration(with: type, attributedTitle: AttributedString(attributedTitle))
        self.configuration = configuration
    }
}

// MARK: - Social Login Button Configuration

extension SocialLoginButton {
    
    /// 소셜로그인타입에 따른 UIButton.Configuration을 반환하는 함수
    private func setupButtonConfiguration(with type: SocialLoginType, attributedTitle: AttributedString) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .fixed
        configuration.background.cornerRadius = 2
        configuration.imagePadding = 12
        configuration.baseBackgroundColor = type.backgroundColor
        configuration.baseForegroundColor = type.foregroundColor
        configuration.image = type.iconImage
        configuration.background.strokeWidth = type.strokeWidth ?? 0.0
        configuration.background.strokeColor = type.strokeColor
        configuration.attributedTitle = attributedTitle
        return configuration
    }
}
