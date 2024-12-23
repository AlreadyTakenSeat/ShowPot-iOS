//
//  InterestShowListEmptyView.swift.swift
//  ShowPot
//
//  Created by 이건준 on 8/17/24.
//

import UIKit

import SnapKit
import Then

final class InterestShowListEmptyView: UIView {
    
    private let emptyImageView = UIImageView().then {
        $0.image = .interestShowEmpty
        $0.contentMode = .scaleAspectFit
    }
    
    private let emptyLabel = SPLabel(KRFont.H0, alignment: .center).then {
        $0.textColor = .gray400
        $0.numberOfLines = .max
        $0.setText(Strings.interestShowEmptyTitle)
    }
    
    let footerButton = SPButton(fontType: KRFont.H2).then {
        $0.configuration?.baseForegroundColor = .gray000
        $0.configuration?.baseBackgroundColor = .gray500
        $0.configuration?.background.cornerRadius = 2
        $0.setText(Strings.interestShowEmptyButton)
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
        [emptyImageView, emptyLabel, footerButton].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        emptyImageView.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(emptyImageView.snp.width)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(snp.centerY)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(16)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        
        footerButton.snp.makeConstraints {
            $0.top.equalTo(emptyLabel.snp.bottom).offset(96)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(55)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
}
