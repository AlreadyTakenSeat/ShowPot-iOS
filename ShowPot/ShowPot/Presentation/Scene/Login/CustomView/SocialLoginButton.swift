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
final class SocialLoginButton: SPButton {
    
    private let type: SocialLoginType
    
    init(type: SocialLoginType) {
        self.type = type
        super.init()
        setupStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        self.configuration?.cornerStyle = .fixed
        self.configuration?.background.cornerRadius = 2
        self.configuration?.imagePadding = 12
        self.configuration?.baseBackgroundColor = type.backgroundColor
        self.configuration?.baseForegroundColor = type.foregroundColor
        self.configuration?.image = type.iconImage
        self.configuration?.background.strokeWidth = type.strokeWidth ?? 0.0
        self.configuration?.background.strokeColor = type.strokeColor
        self.setText(type.buttonTitle, fontType: KRFont.H2)
    }
}
