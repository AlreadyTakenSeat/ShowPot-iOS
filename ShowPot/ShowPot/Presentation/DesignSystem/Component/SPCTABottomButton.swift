//
//  SPCTABottomButton.swift
//  ShowPot
//
//  Created by 김도형 on 3/29/25.
//

import UIKit

import SnapKit

final class SPCTABottomButton: UIView {
    let ctaButton: SPCTAButton
    
    private let style: Style
    
    init(title: String, style: Style) {
        self.ctaButton = SPCTAButton(title: title)
        self.style = style
        
        super.init(frame: .zero)
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard style == .gradation else { return }
        updateGradientLayerFrame()
    }
}

//MARK: - Configure View
extension SPCTABottomButton {
    func configureUI() {
        if style == .gradation {
            applyLinearGradient(
                colors: [
                    UIColor(red: 0.09, green: 0.09, blue: 0.106, alpha: 0),
                    UIColor(red: 0.09, green: 0.09, blue: 0.106, alpha: 1)
                ],
                startPoint: CGPoint(x: 0, y: 0),
                endPoint: CGPoint(x: 0, y: 1),
                locations: [0, 1]
            )
        } else {
            backgroundColor = .clear
        }
        addSubview(ctaButton)
    }
    
    func configureLayout() {
        ctaButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
}

// MARK: - Style
extension SPCTABottomButton {
    enum Style {
        case gradation
        case plain
    }
}

@available(iOS 17.0, *)
#Preview {
    let button = SPCTABottomButton(title: "SHOWPOT 시작하기", style: .plain)
    button.ctaButton.isEnabled = false
    button.snp.makeConstraints { make in
        make.width.equalTo(390)
    }
    return button
}
