//
//  SPLabel.swift
//  ShowPot
//
//  Created by Daegeon Choi on 7/30/24.
//

import UIKit

/// Warning:
class SPLabel: UILabel {
    
    var style: AttributeStyle
    
    override var numberOfLines: Int {
        didSet {
            self.style.multiline = isMultiline()
        }
    }
    
    init(style: AttributeStyle) {
        self.style = style
        super.init(frame: .zero)
    }
    
    convenience init(
        _ fontType: LanguageFont,
        lineBreakMode: NSLineBreakMode = .byTruncatingTail,
        alignment: NSTextAlignment = .left
    ) {
        let style = AttributeStyle(fontType: fontType, lineBreakMode: lineBreakMode, alignment: alignment)
        self.init(style: style)
        self.numberOfLines = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SPLabel {
    
    public func setText(_ string: String) {
        self.attributedText = NSAttributedString(string, style: self.style)
    }
    
    public func setStyle(
        fontType: LanguageFont? = nil,
        lineBreakMode: NSLineBreakMode? = nil,
        alignment: NSTextAlignment? = nil
    ) {
        let newStyle = AttributeStyle(
            fontType: fontType ?? self.style.fontType,
            lineBreakMode: lineBreakMode ?? self.style.lineBreakMode,
            alignment: alignment ?? self.style.alignment,
            multiline: isMultiline()
        )
        
        self.style = newStyle
    }
}

extension SPLabel {
    
    private func isMultiline() -> Bool {
        return self.numberOfLines != 1
    }
}
