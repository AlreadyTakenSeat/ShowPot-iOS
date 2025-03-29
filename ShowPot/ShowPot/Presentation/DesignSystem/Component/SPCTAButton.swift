//
//  SPCTAButton.swift
//  ShowPot
//
//  Created by 김도형 on 3/29/25.
//

import UIKit

final class SPCTAButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        
        configuration(title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configuration(_ title: String) {
        var configuration = UIButton.Configuration.plain()
        let nsStr = NSAttributedString(title, fontType: KRFont.H2)
        configuration.attributedTitle = AttributedString(nsStr)
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 14,
            leading: 0,
            bottom: 14,
            trailing: 0
        )
        configuration.background.backgroundColor = .mainOrange
        configuration.background.cornerRadius = 2
        self.configuration = configuration
        
        configurationUpdateHandler = { button in
            UIView.fadeAnimate {
                let isDisabled = button.state == .disabled
                let backgroundColor: UIColor = isDisabled ? .gray700 : .mainOrange
                let titleColor: UIColor = isDisabled ? .gray400 : .gray800
                button.configuration?.background.backgroundColor = backgroundColor
                button.configuration?.attributedTitle = AttributedString(
                    nsStr.setForegroundColor(color: titleColor)
                )
            }
        }
    }
}
