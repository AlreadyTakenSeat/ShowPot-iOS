//
//  SubscribeArtistTopView.swift
//  ShowPot
//
//  Created by 이건준 on 8/5/24.
//

import UIKit

import SnapKit
import Then

final class SubscribeArtistTopView: UIView {
    
    let navigationBar = SPNavigationBarView(style: .init(
        title: Strings.subscribeArtistNavigationTitle,
        titleColor: .gray100,
        leftIcon: .icArrowLeft.withTintColor(.gray000),
        rightIcon: nil
    ))
    
    private let descriptionLabel = SPLabel(KRFont.H2).then {
        $0.setText(Strings.subscribeArtistNavigationDescription)
        $0.textColor = .gray300
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
        [navigationBar, descriptionLabel].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        
        navigationBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(SPNavigationBarView.height)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualToSuperview()
            $0.bottom.equalToSuperview().inset(14)
        }
    }
}
