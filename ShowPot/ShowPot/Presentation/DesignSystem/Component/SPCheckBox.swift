//
//  SPCheckBox.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import UIKit

final class SPCheckBox: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configuration()
        
        configurationUpdateHandler = { button in
            let image = button.configuration?.image
            switch button.state {
            case .selected:
                button.configuration?.image = image?.withTintColor(.gray000)
                button.configuration?.background.backgroundColor = .mainOrange
            default:
                button.configuration?.image = image?.withTintColor(.gray500)
                button.configuration?.background.backgroundColor = .gray400
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configuration
private extension SPCheckBox {
    func configuration() {
        var configuration = UIButton.Configuration.plain()
        configuration.background.cornerRadius = 0
        let size = CGSize(width: 24, height: 24)
        configuration.image = .icCheck.resized(to: size)
        configuration.contentInsets = .zero
        self.configuration = configuration
    }
}

@available(iOS 17.0, *)
#Preview {
    let checkBox = SPCheckBox()
    checkBox.isSelected = true
    return checkBox
}
