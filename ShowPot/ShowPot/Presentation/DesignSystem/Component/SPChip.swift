//
//  SPChip.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import UIKit

final class SPChip: UIButton {
    init(title: String, style: Style) {
        super.init(frame: .zero)
        
        configuration(title: title)
        
        switch style {
        case .default: break
        case .cancel: cancelConfiguration()
        case .filter:
            configurationUpdateHandler = { [weak self] _ in
                self?.filterConfiguration(title: title)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configuration
private extension SPChip {
    func configuration(title: String) {
        var configuration = UIButton.Configuration.plain()
        configuration.cornerStyle = .capsule
        configuration.background.backgroundColor = .gray700
        configuration.background.strokeColor = .gray400
        configuration.background.strokeWidth = 1
        let nsStr = NSMutableAttributedString(
            title,
            fontType: KRFont.B1_regular
        ).setForegroundColor(color: .gray000)
        configuration.attributedTitle = AttributedString(nsStr)
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 14,
            bottom: 8,
            trailing: 14
        )
        self.configuration = configuration
    }
    
    func cancelConfiguration() {
        configuration?.imagePlacement = .trailing
        configuration?.imagePadding = 0
        configuration?.image = .icCancel
            .withTintColor(.gray300)
            .resized(to: CGSize(width: 24, height: 24))
        configuration?.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 14,
            bottom: 8,
            trailing: 8
        )
    }
    
    func filterConfiguration(title: String) {
        let strokeColor: UIColor = isSelected ? .gray000 : .gray600
        configuration?.background.strokeColor = strokeColor
        let nsStr = NSAttributedString(title, fontType: KRFont.B1_regular)
            .setForegroundColor(color: isSelected ? .gray000 : .gray400)
        configuration?.attributedTitle = AttributedString(nsStr)
    }
}

extension SPChip {
    enum Style {
        case `default`
        case cancel
        case filter
    }
}

@available(iOS 17.0, *)
#Preview {
    let chip = SPChip(title: "크리스토퍼", style: .cancel)
    chip.isSelected = true
    return chip
}
