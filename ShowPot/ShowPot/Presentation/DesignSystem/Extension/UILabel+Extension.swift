//
//  UILabel+Extension.swift
//  ShowPot
//
//  Created by 김도형 on 4/6/25.
//

import UIKit

// MARK: - UILabel Tap Detection Extension
extension UILabel {
    func indexOfAttributedTextCharacter(at point: CGPoint) -> Int? {
        guard let attributedText = self.attributedText else { return nil }
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: bounds.size)
        let textStorage = NSTextStorage(attributedString: attributedText)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.size = bounds.size
        
        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index < attributedText.length ? index : nil
    }
}
