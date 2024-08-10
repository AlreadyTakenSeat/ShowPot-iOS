//
//  UIButton+Extension.swift
//  ShowPot
//
//  Created by 이건준 on 8/9/24.
//

import UIKit
import Then

extension UIButton.Configuration {
    
    func enabledToggleButton(label text: String) -> UIButton.ConfigurationUpdateHandler {
        return { button in
            guard let button = button as? SPButton else { return }
            switch button.state {
            case .normal:
                button.configuration = SPButtonStyle.accentBottomEnabled.configuration
            case .disabled:
                button.configuration = SPButtonStyle.bottomDisabled.configuration
            default: break
            }
            button.setText(text)
        }
    }
}
