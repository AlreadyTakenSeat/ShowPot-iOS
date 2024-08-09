//
//  UIButton+Extension.swift
//  ShowPot
//
//  Created by 이건준 on 8/9/24.
//

import UIKit
import Then

extension UIBackgroundConfiguration: Then { }

extension UIButton.Configuration {
    
    private static func spButtonEnabled() -> UIButton.Configuration {
        var style = UIButton.Configuration.plain()
        
        style.background = style.background.with {
            $0.cornerRadius = 2
            $0.backgroundColor = .mainOrange
        }
        style.baseForegroundColor = .gray800
        
        return style
    }
    
    private static func spButtonDisabled() -> UIButton.Configuration {
        var style = UIButton.Configuration.plain()
        
        style.background = style.background.with {
            $0.cornerRadius = 2
            $0.backgroundColor = .gray700
        }
        style.baseForegroundColor = .gray400
        
        return style
    }
    
    func spButton(label text: String) -> UIButton.ConfigurationUpdateHandler {
        return { button in
            guard let button = button as? SPButton else { return }
            switch button.state {
            case .normal:
                button.configuration = .spButtonEnabled()
            case .disabled:
                button.configuration = .spButtonDisabled()
            default: break
            }
            button.setText(text)
        }
    }
}
