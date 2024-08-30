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
    var multiline: Bool
    
    init(
        fontType: LanguageFont,
        lineBreakMode: NSLineBreakMode = .byTruncatingTail,
        alignment: NSTextAlignment = .left,
        multiline: Bool = false
    ) {
        self.fontType = fontType
        self.lineBreakMode = lineBreakMode
        self.alignment = alignment
        self.multiline = multiline
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
    
    func setUnderline(to targetText: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        let fullText = self.string
        
        if let range = fullText.range(of: targetText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
        }
        
        return attributedString
    }
    
    func setLink(to targetText: String, actionID: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        let fullText = self.string
        if let range = fullText.range(of: targetText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.link, value: actionID, range: nsRange)
        }
        return attributedString
    }
    
    func setForegroundColor(color: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        let fullRange = NSRange(location: 0, length: attributedString.length)
        
        attributedString.addAttribute(.foregroundColor, value: color, range: fullRange)
        
        return attributedString
    }
}

// MARK: 커스텀 attributes 사용하는 커스텀 생성자
extension NSAttributedString {
    
    convenience init(_ string: String, style: AttributeStyle) {
        self.init(
            string,
            fontType: style.fontType,
            lineBreakMode: style.lineBreakMode,
            alignment: style.alignment,
            multiline: style.multiline
        )
    }
    
    convenience init(
        _ string: String,
        fontType: LanguageFont,
        lineBreakMode: NSLineBreakMode = .byTruncatingTail,
        alignment: NSTextAlignment = .left,
        multiline: Bool = false
    ) {
        let lineHeight = fontType.font.lineHeight * fontType.lineHeightMultiple
        
        var attrStr = NSMutableAttributedString(string: string)
            .setFont(font: fontType.font)
            .setParagraphStyle(
                lineHeightMultiple: multiline ? fontType.lineHeightMultiple : 0,
                lineBreakMode: lineBreakMode,
                alignment: alignment
            )
            .setLetterSpacing(letterSpacingPercent: fontType.letterSpacing)
        
        if multiline {
            attrStr = attrStr.setBaseLineOffset(baselineOffset: (lineHeight - fontType.font.lineHeight) / 2)
        }
        
        self.init(attributedString: attrStr)
    }
}
