//
//  Font.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/16/24.
//

import UIKit

// MARK: 커스텀 폰트 관리

/// 커스텀 폰트 종류
enum CustomFont: String {
    case pretendard = "Pretendard"
    case oswald = "Oswald"
}

/// 커스텀 폰트의 스타일 종류
/// - Warning: 폰트 종류에 따라 지원하지 않는 Style이 있을 수 있어 주의 요망
enum CustomFontStyle: String {
    case black = "Black"
    case extraBold = "ExtraBold"
    case bold = "Bold"
    case semiBold = "SemiBold"
    case medium = "Medium"
    case regular = "Regular"
    case light = "Light"
    case extraLight = "ExtraLight"
    case thin = "Thin"
}

extension UIFont {
    /**
     미리 정의된 `CustomFont` `CustomFontStyle` 열거형을 사용해 원하는 폰트를 가져온다
     - Parameters:
        - font: 폰트 종류  (*i.e.* Pretendard, Osward)
        - style: 폰트 스타일 (*i.e* regular, semibold)
        - size: 폰트 크기
     - Returns: {font}-{style} 이름의 폰트가 있는 경우 해당 폰트 반환, 폰트가 없는 경우 기본 시스템 폰트 반환
     */
    static func customFont(font: CustomFont, style: CustomFontStyle, size: CGFloat) -> UIFont {
        
        let customFontName: String = "\(font.rawValue)-\(style.rawValue)"
        guard let font = UIFont(name: customFontName, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        
        return font
    }
}
