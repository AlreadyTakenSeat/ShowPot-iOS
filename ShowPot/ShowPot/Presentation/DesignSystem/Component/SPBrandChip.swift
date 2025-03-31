//
//  SPBrandChip.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import UIKit

import SnapKit

final class SPBrandChip: UIButton {
    init(style: Style) {
        super.init(frame: .zero)
        
        configuration(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configuration
private extension SPBrandChip {
    func configuration(style: Style) {
        var configuration = UIButton.Configuration.plain()
        configuration.background.backgroundColor = style.color
        configuration.background.cornerRadius = 2
        let nsStr = NSAttributedString(
            style.title,
            fontType: KRFont.B2_regular
        ).setForegroundColor(color: .gray000)
        configuration.attributedTitle = AttributedString(nsStr)
        configuration.image = .icArrowRight
            .withTintColor(.gray000)
            .resized(to: CGSize(width: 24, height: 24))
        configuration.imagePadding = 1
        configuration.imagePlacement = .trailing
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 9,
            bottom: 5,
            trailing: 4
        )
        self.configuration = configuration
    }
}

extension SPBrandChip {
    enum Style {
        case `default`(String)
        case yes24
        case interpark
        case melon
        
        var title: String {
            switch self {
            case let .default(title):
                return title
            case .yes24: return "YES24"
            case .interpark: return "인터파크"
            case .melon: return "멜론티켓"
            }
        }
        
        var color: UIColor {
            switch self {
            case .default: return .mainOrange
            case .yes24: return .chipYes24
            case .interpark: return .chipInterpark
            case .melon: return .chipMelonticket
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    SPBrandChip(style: .melon)
}
