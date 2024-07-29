//
//  UILabel+Extension.swift
//  ShowPot
//
//  Created by 이건준 on 6/28/24.
//

import UIKit

extension UILabel {
    
    func setAttributedText(font fontType: LanguageFont, string: String, alignment: NSTextAlignment = .left) {
        self.attributedText = NSAttributedString(
            string,
            style: AttributeStyle(fontType: fontType, alignment: alignment)
        )
    }
}
