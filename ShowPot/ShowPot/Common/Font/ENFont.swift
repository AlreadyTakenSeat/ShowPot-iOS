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
    
    case H0, H1, H2, H3, H4, H5
    
    var customFont: CustomFont {
        return .oswald
    }
    
    var lineHeightMultiple: CGFloat {
        return 1.26
    }
    
    var letterSpacing: CGFloat {
        return 0.0
    }
    
    // 디자인 시스템에 명시된 폰트
    var font: UIFont {
        let font = self.customFont
        switch self {
        case .H0:
            return .customFont(font: font, style: .regular, size: 30)
        case .H1:
            return .customFont(font: font, style: .regular, size: 24)
        case .H2:
            return .customFont(font: font, style: .regular, size: 22)
        case .H3:
            return .customFont(font: font, style: .regular, size: 20)
        case .H4:
            return .customFont(font: font, style: .regular, size: 18)
        case .H5:
            return .customFont(font: font, style: .regular, size: 16)
        }
    }
}
