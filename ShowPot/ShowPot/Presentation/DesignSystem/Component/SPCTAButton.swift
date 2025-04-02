//
//  SPCTAButton.swift
//  ShowPot
//
//  Created by 김도형 on 3/29/25.
//

import UIKit

final class SPCTAButton: UIButton {
    init(title: String, style: Style = .primary) {
        super.init(frame: .zero)
        
        configuration()
        
        switch style {
        case .primary: primaryConfiguration(title: title)
        case .secondary: secondaryConfiguration(title: title)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configuration() {
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 14,
            leading: 0,
            bottom: 14,
            trailing: 0
        )
        configuration.background.cornerRadius = 2
        self.configuration = configuration
    }
    
    private func primaryConfiguration(title: String) {
        let nsStr = NSAttributedString(title, fontType: KRFont.H2)
            .setForegroundColor(color: .gray800)
        configuration?.attributedTitle = AttributedString(nsStr)
        configuration?.background.backgroundColor = .mainOrange
        
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
    
    private func secondaryConfiguration(title: String) {
        let nsStr = NSAttributedString(title, fontType: KRFont.H2)
            .setForegroundColor(color: .gray000)
        configuration?.attributedTitle = AttributedString(nsStr)
        configuration?.background.backgroundColor = .gray400
        
        configurationUpdateHandler = { button in
            UIView.fadeAnimate {
                let isDisabled = button.state == .disabled
                let backgroundColor: UIColor = isDisabled ? .gray700 : .gray400
                let titleColor: UIColor = isDisabled ? .gray400 : .gray000
                button.configuration?.background.backgroundColor = backgroundColor
                button.configuration?.attributedTitle = AttributedString(
                    nsStr.setForegroundColor(color: titleColor)
                )
            }
        }
    }
}

extension SPCTAButton {
    enum Style {
        case primary
        case secondary
    }
}
