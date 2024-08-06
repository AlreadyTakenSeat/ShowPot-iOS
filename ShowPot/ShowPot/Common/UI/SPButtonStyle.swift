//
//  SPButtonStyle.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/1/24.
//

import UIKit

struct SPButtonStyle {
    let textStyle: AttributeStyle
    let configuration: UIButton.Configuration
}

extension SPButton {
    convenience init(_ style: SPButtonStyle) {
        self.init(textStyle: style.textStyle, configuration: style.configuration)
    }
}

// MARK: Style 리스트

extension SPButtonStyle {
    
    static let basicBottomEnabled: SPButtonStyle = {
        let textStyle = AttributeStyle(fontType: KRFont.H2, alignment: .center)
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .gray000
        configuration.baseBackgroundColor = .gray700
        configuration.background.cornerRadius = 2
        return SPButtonStyle(textStyle: textStyle, configuration: configuration)
    }()
    
    static let accentBottomEnabled: SPButtonStyle = {
        let textStyle = AttributeStyle(fontType: KRFont.H2, alignment: .center)
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .gray800
        configuration.baseBackgroundColor = .mainOrange
        configuration.background.cornerRadius = 2
        return SPButtonStyle(textStyle: textStyle, configuration: configuration)
    }()
    
    static let bottomDisabled: SPButtonStyle = {
        let textStyle = AttributeStyle(fontType: KRFont.H2, alignment: .center)
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .gray700
        configuration.baseBackgroundColor = .gray400
        configuration.background.cornerRadius = 2
        return SPButtonStyle(textStyle: textStyle, configuration: configuration)
    }()
    
    static let disclosureButton: SPButtonStyle = {
        let textStyle = AttributeStyle(fontType: KRFont.B1_semibold, alignment: .center)
        var configuration = UIButton.Configuration.filled()
        configuration.imagePlacement = .trailing
        configuration.image = .icArrowRight.withTintColor(.gray400)
        configuration.baseBackgroundColor = .gray600
        configuration.baseForegroundColor = .gray100
        configuration.cornerStyle = .fixed
        configuration.background.cornerRadius = 2
        return SPButtonStyle(textStyle: textStyle, configuration: configuration)
    }()
}
