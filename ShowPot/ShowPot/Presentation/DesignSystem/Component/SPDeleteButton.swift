//
//  SPDeleteButton.swift
//  ShowPot
//
//  Created by 김도형 on 3/29/25.
//

import UIKit

final class SPDeleteButton: UIButton {
    init(style: Style) {
        super.init(frame: .zero)
        
        configuration()
        
        updateStyle(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configuration() {
        var configuration = UIButton.Configuration.plain()
        configuration.background.cornerRadius = 2
        configuration.background.backgroundColor = .gray500
        configuration.imagePadding = .zero
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 5,
            bottom: 5,
            trailing: 10
        )
        configuration.baseForegroundColor = .gray300
        self.configuration = configuration
    }
    
    private func updateStyle(_ style: Style) {
        let nsStr = NSAttributedString(style.title, fontType: KRFont.B2_regular)
            .setForegroundColor(color: .white)
        configuration?.attributedTitle = AttributedString(nsStr)
        switch style {
        case .plain:
            configuration?.image = .icDelete
                .withRenderingMode(.alwaysTemplate)
        case .alarm:
            configuration?.image = .icAlarmCancel
                .withRenderingMode(.alwaysTemplate)
        }
    }
}

// MARK: - Style
extension SPDeleteButton {
    enum Style {
        case plain
        case alarm
        
        var title: String {
            switch self {
            case .plain: return "삭제"
            case .alarm: return "알림 해제"
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    SPDeleteButton(style: .plain)
}
