//
//  SPButton.swift
//  ShowPot
//
//  Created by Daegeon Choi on 7/31/24.
//

import UIKit

class SPButton: UIButton {
    
    var textStyle: AttributeStyle?
    
    init(textStyle: AttributeStyle? = nil, configuration: UIButton.Configuration = .filled()) {
        self.textStyle = textStyle
        super.init(frame: .zero)
        self.configuration = configuration
    }
    
    convenience init(fontType: LanguageFont, configuration: UIButton.Configuration = .filled()) {
        let textStyle = AttributeStyle(fontType: fontType, alignment: .center)
        self.init(textStyle: textStyle, configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SPButton {
    
    /// 현재 textStyle 적용된 NSAttributedString 반환
    private func styledAttributedString(_ string: String) -> NSAttributedString {
        
        guard let style = self.textStyle else {
            return NSAttributedString(string: string)
        }
        
        return NSAttributedString(string, style: style)
    }
    
    /// 현재 textStyle을 반영해 타이틀 수정
    private func setText(_ attrStr: NSAttributedString, for state: UIControl.State = .normal) {
        self.configuration?.attributedTitle = AttributedString(attrStr)
    }
}

extension SPButton {
    
    /// 현재 textStyle을 반영해 타이틀 수정
    public func setText(_ string: String, for state: UIControl.State = .normal) {
        let attrStr = self.styledAttributedString(string)
        self.setText(attrStr)
    }
    
    /// 특정 style을 반영하여 타이틀 수정
    public func setText(_ string: String, style: AttributeStyle, for state: UIControl.State = .normal) {
        self.textStyle = style
        self.setText(string)
    }
    
    /// 특정 font를 반영하여 타이틀 수정
    public func setText(_ string: String, fontType: LanguageFont, for state: UIControl.State = .normal) {
        self.textStyle = AttributeStyle(fontType: fontType, alignment: .center)
        self.setText(string)
    }
}
