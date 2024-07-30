//
//  FeaturedSearchButton.swift
//  ShowPot
//
//  Created by 이건준 on 7/11/24.
//

import UIKit

import SnapKit
import Then

final class FeaturedSearchButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        
        contentHorizontalAlignment = .fill
        let attrStr = NSAttributedString(Strings.homeSearchbarPlaceholder, fontType: KRFont.B1_semibold)
        
        var configuration = UIButton.Configuration.filled()
        configuration.image = .icMagnifier.withTintColor(.white)
        configuration.imagePlacement = .trailing
        configuration.baseBackgroundColor = .gray600
        configuration.baseForegroundColor = .gray400
        configuration.cornerStyle = .fixed
        configuration.background.cornerRadius = 2
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 5)
        configuration.imagePadding = -configuration.contentInsets.trailing
        configuration.attributedTitle = AttributedString(attrStr)
        
        self.configuration = configuration
    }
}
