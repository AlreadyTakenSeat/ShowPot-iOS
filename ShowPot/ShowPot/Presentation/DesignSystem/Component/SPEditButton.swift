//
//  SPEditButton.swift
//  ShowPot
//
//  Created by 김도형 on 3/29/25.
//

import UIKit

import RxSwift
import RxCocoa

final class SPEditButton: UIButton {
    init(style: Style) {
        super.init(frame: .zero)
        
        configuration()
        
        updateStyle(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configuration() {
        var configuration = UIButton.Configuration.plain()
        configuration.background.cornerRadius = 0
        configuration.background.backgroundColor = .gray700
        configuration.imagePlacement = .leading
        configuration.imagePadding = 2
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 20,
            bottom: 8,
            trailing: 20
        )
        configuration.baseForegroundColor = .gray100
        self.configuration = configuration
    }
    
    fileprivate func updateStyle(_ style: Style) {
        let nsStr = NSAttributedString(style.title, fontType: KRFont.H2)
            .setForegroundColor(color: .gray100)
        configuration?.attributedTitle = AttributedString(nsStr)
        
        switch style {
        case .plain:
            configuration?.image = .icEdit.withRenderingMode(.alwaysTemplate)
        case .complete:
            configuration?.image = .icEdit.withRenderingMode(.alwaysTemplate)
        }
    }
}

// MARK: - Style
extension SPEditButton {
    enum Style {
        case plain
        case complete
        
        var title: String {
            switch self {
            case .plain: return "수정"
            case .complete: return "수정완료"
            }
        }
    }
}

extension Reactive where Base == SPEditButton {
    var style: Binder<SPEditButton.Style> {
        Binder(base) { button, style in
            button.updateStyle(style)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    SPEditButton(style: .plain)
}
