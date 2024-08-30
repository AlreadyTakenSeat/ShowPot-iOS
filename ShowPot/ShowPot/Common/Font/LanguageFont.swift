//
//  LanguageFont.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/16/24.
//

import UIKit

// MARK: 언어별 커스텀 폰트 지정 및 관리

/// 언어별 폰트가 다르기 때문에 폰트, line height, letter spacing 값들을 관리하기 위한 프로토콜
protocol LanguageFont {
    /// 폰트 이름
    var customFont: CustomFont { get }
    
    /// AttributedString에 사용할 lineHeight 배율
    var lineHeightMultiple: CGFloat { get }
    
    /// AttributedString에 사용할 letterSpacing
    var letterSpacing: CGFloat { get }
    
    /// 디자인 가이드에 명시된 font style 적용 `UIFont`
    var font: UIFont { get }
}
