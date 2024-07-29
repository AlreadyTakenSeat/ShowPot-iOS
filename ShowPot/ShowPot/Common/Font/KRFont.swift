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
    
    case H0, H1, H2
    case B1_semibold, B1_regular, B2_semibold, B2_regular, B3_semibold, B3_regular
    
    var customFont: CustomFont {
        return .pretendard
    }
    
    var lineHeightMultiple: CGFloat {
        return 1.26
    }
    
    var letterSpacing: CGFloat {
        return -0.03
    }
    
    /// UIFont 반환
    var font: UIFont {
        let font = self.customFont
        switch self {
        case .H0:
            return .customFont(font: font, style: .semiBold, size: 24)
        case .H1:
            return .customFont(font: font, style: .semiBold, size: 20)
        case .H2:
            return .customFont(font: font, style: .semiBold, size: 18)
        case .B1_semibold:
            return .customFont(font: font, style: .semiBold, size: 16)
        case .B1_regular:
            return .customFont(font: font, style: .regular, size: 16)
        case .B2_semibold:
            return .customFont(font: font, style: .semiBold, size: 14)
        case .B2_regular:
            return .customFont(font: font, style: .regular, size: 14)
        case .B3_semibold:
            return .customFont(font: font, style: .semiBold, size: 12)
        case .B3_regular:
            return .customFont(font: font, style: .regular, size: 12)
        }
    }
}
