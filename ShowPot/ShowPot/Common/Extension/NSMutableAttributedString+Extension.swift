//
//  NSAttributedString+Extension.swift
//  ShowPot
//
//  Created by 이건준 on 7/4/24.
//

import UIKit

extension NSMutableAttributedString {
    
    /// 줄 높이를 설정을 위한 attribute를 추가합니다.
    /// - Parameters:
    ///   - lineHeightMultiple: UILabel의 줄 높이 배수 (예: 1.5 = 150%)
    func setLineHeight(lineHeightMultiple: CGFloat) -> Self {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle
        ]
        
        self.addAttributes(attributes, range: NSRange(location: 0, length: self.length))
        return self
    }
    
    /// 자간 설정을 위한 attribute를 추가합니다.
    /// - Parameters:
    ///   - letterSpacingPercent: UILabel의 자간 백분율 (예: -0.025 = -2.5%)
    func setLetterSpacing(letterSpacingPercent: CGFloat) -> Self {
        let attributes: [NSAttributedString.Key: Any] = [
            .kern: letterSpacingPercent
        ]
        
        self.addAttributes(attributes, range: NSRange(location: 0, length: self.length))
        return self
    }
}
