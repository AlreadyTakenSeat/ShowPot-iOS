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
        
        let attributedTitle = createButtonAttributedString(string: Strings.homeSearchbarPlaceholder)
        var configuration = createButtonConfiguration(
            image: .icMagnifier.withTintColor(.white),
            baseBackgroundColor: .gray600,
            baseForegroundColor: .gray400,
            cornerRadius: 2,
            contentInsets: NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 5),
            with: attributedTitle
        )
        configuration.attributedTitle = attributedTitle
        self.configuration = configuration
    }
}

// MARK: - FeaturedSearchButton Setup For UIButtonConfiguration

extension FeaturedSearchButton {
    
    /// UIButton.Configuration에 사용될 AttributedString을 리턴하는 함수
    private func createButtonAttributedString(string: String) -> AttributedString {
        let labelWithAttributedText = UILabel().then {
            $0.setAttributedText(font: KRFont.B1_semibold, string: string) // TODO: #61 UIButton AttributedString에 대한 attribute적용 공통함수로 중복코드삭제
        }
        let attributedText = labelWithAttributedText.attributedText ?? NSAttributedString(string: string)
        
        var attributedString = AttributedString(attributedText)
        attributedString.font = KRFont.B1_semibold.font
        return attributedString
    }
    
    /// 버튼에서 사용할 Configuration을 생성하는 함수
    private func createButtonConfiguration(
        image: UIImage,
        baseBackgroundColor: UIColor,
        baseForegroundColor: UIColor,
        cornerRadius: CGFloat,
        contentInsets: NSDirectionalEdgeInsets,
        with attributedTitle: AttributedString
    ) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.image = image
        configuration.imagePlacement = .trailing
        configuration.baseBackgroundColor = baseBackgroundColor
        configuration.baseForegroundColor = baseForegroundColor
        configuration.cornerStyle = .fixed
        configuration.background.cornerRadius = cornerRadius
        configuration.contentInsets = contentInsets
        configuration.imagePadding = -configuration.contentInsets.trailing
        configuration.attributedTitle = attributedTitle
        return configuration
    }
}
