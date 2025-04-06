//
//  SPDivider.swift
//  ShowPot
//
//  Created by 김도형 on 3/30/25.
//

import UIKit

import SnapKit

final class SPDivider: UIView {
    init(style: Style) {
        super.init(frame: .zero)
        
        backgroundColor = style.color
        snp.makeConstraints { make in
            make.height.equalTo(style.height)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStyle(_ style: Style) {
        backgroundColor = style.color
        snp.updateConstraints { make in
            make.height.equalTo(style.height)
        }
    }
}

extension SPDivider {
    enum Style {
        case short
        case long
        
        var color: UIColor {
            switch self {
            case .short: return .gray500
            case .long: return .gray600
            }
        }
        
        var height: CGFloat {
            switch self {
            case .short: return 1
            case .long: return 8
            }
        }
    }
}
