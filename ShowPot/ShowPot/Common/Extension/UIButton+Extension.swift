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
    
    func toggleButtonImageBySelection(
        backgroundColor: UIColor,
        normalImage: UIImage,
        selectedImage: UIImage
    ) -> UIButton.ConfigurationUpdateHandler {
        return { button in
            guard let button = button as? SPButton else { return }
            button.configuration?.baseBackgroundColor = backgroundColor
            switch button.state {
            case .normal:
                button.configuration?.image = normalImage
            case .selected:
                button.configuration?.image = selectedImage
            default: break
            }
        }
    }
    
    func showDetailAlarmButton(
        label text: String,
        disabledTitle: String? = nil,
        selectedTitle: String
    ) -> UIButton.ConfigurationUpdateHandler {
        return { button in
            guard let button = button as? SPButton else { return }
            switch button.state {
            case .normal, .selected:
                button.configuration = SPButtonStyle.accentBottomEnabled.configuration
                button.setText(button.state == .normal ? text : selectedTitle)
            case .disabled:
                button.configuration = SPButtonStyle.showDetailBottomDisabled.configuration
                button.setText(disabledTitle ?? text)
            default:
                break
            }
        }
    }
}
