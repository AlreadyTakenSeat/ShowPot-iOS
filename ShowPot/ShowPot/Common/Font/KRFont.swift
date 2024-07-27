//
//  KRFont.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/16/24.
//

import UIKit

// swiftlint:disable identifier_name

/// 한국어 폰트 스타일
enum KRFont: LanguageFont {
    static var font: CustomFont = .pretendard
    static var lineHeightMultiple: CGFloat = 1.26
    static var letterSpacing: CGFloat = -0.03
    
    // 디자인 시스템에 명시된 폰트
    static let H0: UIFont = .customFont(font: font, style: .semiBold, size: 24)
    static let H1: UIFont = .customFont(font: font, style: .semiBold, size: 20)
    static let H2: UIFont = .customFont(font: font, style: .semiBold, size: 18)
    static let B1_semibold: UIFont = .customFont(font: font, style: .semiBold, size: 16)
    static let B1_regular: UIFont = .customFont(font: font, style: .regular, size: 16)
    static let B2_semibold: UIFont = .customFont(font: font, style: .semiBold, size: 14)
    static let B2_regular: UIFont = .customFont(font: font, style: .regular, size: 14)
    static let B3_semibold: UIFont = .customFont(font: font, style: .semiBold, size: 12)
    static let B3_regular: UIFont = .customFont(font: font, style: .regular, size: 12)
}
