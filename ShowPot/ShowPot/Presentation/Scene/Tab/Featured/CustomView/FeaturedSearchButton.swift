//
//  FeaturedSearchButton.swift
//  ShowPot
//
//  Created by 이건준 on 7/11/24.
//

import UIKit

import SnapKit
import Then

final class FeaturedSearchButton: SPButton {
    
    init() {
        super.init()
        setupStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        
        contentHorizontalAlignment = .fill

        self.configuration?.image = .icMagnifier.withTintColor(.white)
        self.configuration?.imagePlacement = .trailing
        self.configuration?.baseBackgroundColor = .gray600
        self.configuration?.baseForegroundColor = .gray400
        self.configuration?.cornerStyle = .fixed
        self.configuration?.background.cornerRadius = 2
        
        let contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 5)
        self.configuration?.contentInsets = contentInsets
        self.configuration?.imagePadding = contentInsets.trailing
        
        self.setText(Strings.homeSearchbarPlaceholder, fontType: KRFont.B1_semibold)
    }
}
