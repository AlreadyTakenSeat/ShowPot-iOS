//
//  SubscribeButton.swift
//  ShowPot
//
//  Created by 이건준 on 8/5/24.
//

import UIKit

import SnapKit
import Then

final class SubscribeFooterView: UIView {
    
    private let backgroundGradientView = GradientView(
        colors: [
            .gray700.withAlphaComponent(0.0),
            .gray700.withAlphaComponent(1.0)
        ],
        startPoint: .init(x: 0.5, y: 0.0),
        endPoint: .init(x: 0.5, y: 1.0)
    )
        
    let bottomButton = SPButton(.accentBottomEnabled).then {
        $0.setText(Strings.subscribeArtistButton, fontType: KRFont.H2)
        $0.configuration?.background.cornerRadius = 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        addSubview(backgroundGradientView)
        backgroundGradientView.addSubview(bottomButton)
    }
    
    private func setupConstraints() {
        backgroundGradientView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        bottomButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(54)
            $0.height.equalTo(55)
        }
    }
}
