//
//  ShowDeleteButtonView.swift
//  ShowPot
//
//  Created by 이건준 on 8/18/24.
//

import UIKit

import SnapKit
import Then

final class ShowDeleteButtonView: UIView {
    
    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = .icDelete.withTintColor(.gray300)
    }
    
    private let titleLabel = SPLabel(KRFont.B2_regular).then {
        $0.setText(Strings.interestShowDeleteButton)
        $0.textColor = .gray000
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyles()
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        backgroundColor = .gray500
        layer.cornerRadius = 2
        layer.masksToBounds = true
    }
    
    private func setupLayouts() {
        [iconImageView, titleLabel].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        iconImageView.snp.makeConstraints {
            $0.leading.directionalVerticalEdges.equalToSuperview().inset(5)
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing)
            $0.centerY.trailing.equalToSuperview()
        }
    }
}
