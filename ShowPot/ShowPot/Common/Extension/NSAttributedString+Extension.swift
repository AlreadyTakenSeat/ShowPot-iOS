//
//  NSAttributedString+Extension.swift
//  ShowPot
//
//  Created by 이건준 on 7/4/24.
//

import UIKit

struct AttributeStyle {
    let fontType: LanguageFont
    let lineBreakMode: NSLineBreakMode
    let alignment: NSTextAlignment
    
    init(
        fontType: LanguageFont,
        lineBreakMode: NSLineBreakMode = .byTruncatingTail,
        alignment: NSTextAlignment = .left
    ) {
        self.fontType = fontType
        self.lineBreakMode = lineBreakMode
        self.alignment = alignment
    }
}

// MARK: attributes 설정 메서드
extension NSAttributedString {
    
    /// 줄 높이를 설정을 위한 attribute를 추가합니다.
    /// - Parameters:
    ///   - lineHeight: UILabel의 줄 높이
    func setParagraphStyle(
        lineHeightMultiple: CGFloat = 0,
        lineBreakMode: NSLineBreakMode = .byTruncatingTail,
        alignment: NSTextAlignment = .left
    ) -> NSAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.alignment = alignment
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle
        ]
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        mutableAttributedString.addAttributes(attributes, range: NSRange(location: 0, length: self.length))
        return NSAttributedString(attributedString: mutableAttributedString)
    }
    
    func setLetterSpacing(letterSpacingPercent: CGFloat) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .kern: letterSpacingPercent
        ]
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        mutableAttributedString.addAttributes(attributes, range: NSRange(location: 0, length: self.length))
        return NSAttributedString(attributedString: mutableAttributedString)
    }
    
    func setBaseLineOffset(baselineOffset: CGFloat) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .baselineOffset: baselineOffset
        ]
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        mutableAttributedString.addAttributes(attributes, range: NSRange(location: 0, length: self.length))
        return NSAttributedString(attributedString: mutableAttributedString)
    }
    
    func setFont(font: UIFont) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        mutableAttributedString.addAttributes(attributes, range: NSRange(location: 0, length: self.length))
        return NSAttributedString(attributedString: mutableAttributedString)
    }
}

// MARK: 커스텀 attributes 사용하는 커스텀 생성자
extension NSAttributedString {
    
    convenience init(_ string: String, style: AttributeStyle) {
        self.init(
            string,
            fontType: style.fontType,
            lineBreakMode: style.lineBreakMode,
            alignment: style.alignment
        )
    }
    
    convenience init(
        _ string: String,
        fontType: LanguageFont,
        lineBreakMode: NSLineBreakMode = .byTruncatingTail,
        alignment: NSTextAlignment = .left
    ) {
        
        let lineHeight = fontType.font.lineHeight * fontType.lineHeightMultiple
        
        let attrStr = NSMutableAttributedString(string: string)
            .setFont(font: fontType.font)
            .setParagraphStyle(
                lineHeightMultiple: fontType.lineHeightMultiple,
                lineBreakMode: lineBreakMode,
                alignment: alignment
            )
            .setLetterSpacing(letterSpacingPercent: fontType.letterSpacing)
            .setBaseLineOffset(baselineOffset: (lineHeight - fontType.font.lineHeight) / 2)
        
        self.init(attributedString: attrStr)
    }
}
