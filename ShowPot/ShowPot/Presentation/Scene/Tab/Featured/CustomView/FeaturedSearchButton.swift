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
        
        layer.masksToBounds = true
        layer.cornerRadius = 2
        contentHorizontalAlignment = .fill
        
        let attributedTitle = getAttributedString()
        var configuration = getButtonConfiguration()
        configuration.attributedTitle = attributedTitle
        self.configuration = configuration
    }
}

// MARK: - FeaturedSearchButton Setup For UIButtonConfiguration

extension FeaturedSearchButton {
        var attributedTitle = AttributedString("관심 있는 공연과 가수를 검색해보세요")
    private func getAttributedString() -> AttributedString {
        attributedTitle.font = KRFont.B1_semibold // TODO: #37 lineHeight + letterSpacing 적용
        return attributedTitle
    }
    
    private func getButtonConfiguration() -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.image = .icMagnifier36.withTintColor(.white) // TODO: #44 애셋 네이밍 변경 이후 작업 필요
        configuration.background.cornerRadius = 2
        configuration.imagePlacement = .trailing
        configuration.baseBackgroundColor = .gray600
        configuration.baseForegroundColor = .gray400
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 5)
        configuration.imagePadding = -configuration.contentInsets.trailing
        return configuration
    }
}
