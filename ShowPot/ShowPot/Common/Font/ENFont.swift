//
//  ENFont.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/16/24.
//

import UIKit

// swiftlint:disable identifier_name

/// 영어 폰트 스타일
enum ENFont: LanguageFont {
    static var font: CustomFont = .oswald
    static var lineHeightMultiple: CGFloat = 1.5
    static var letterSpacing: CGFloat = 0.0
    
    // 디자인 시스템에 명시된 폰트
    static let H0: UIFont = .customFont(font: font, style: .regular, size: 30)
    static let H1: UIFont = .customFont(font: font, style: .regular, size: 24)
    static let H2: UIFont = .customFont(font: font, style: .regular, size: 22)
    static let H3: UIFont = .customFont(font: font, style: .regular, size: 20)
    static let H4: UIFont = .customFont(font: font, style: .regular, size: 18)
    static let H5: UIFont = .customFont(font: font, style: .regular, size: 16)
}
