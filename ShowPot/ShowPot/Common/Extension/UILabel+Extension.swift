//
//  UILabel+Extension.swift
//  ShowPot
//
//  Created by 이건준 on 6/28/24.
//

import UIKit

extension UILabel {
    
    /// UILabel의 자간 및 줄 높이에 대한 attributedText를 설정합니다.
    /// - Parameters:
    ///   - font: LanguageFont 프로토콜을 준수하는 타입
    ///   - string: UILabel에 설정할 텍스트
    func setAttributedText(font: LanguageFont, string: String, alignment: NSTextAlignment = .left) {
        
        let lineHeight = self.font.lineHeight * font.lineHeightMultiple
        
        self.attributedText = NSMutableAttributedString(string: string)
            .setLineHeight(lineHeight: lineHeight, alignment: alignment)
            .setLetterSpacing(letterSpacingPercent: font.letterSpacing)
            .setBaseLineOffset(baselineOffset: (lineHeight - self.font.lineHeight) / 2)
    }
}
