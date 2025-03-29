//
//  LabelMenuCell.swift
//  ShowPot
//
//  Created by 이건준 on 8/25/24.
//

import UIKit

import SnapKit
import Then

final class LabelMenuCell: MenuCell {
    
    private let descriptionLabel = SPLabel(KRFont.B1_regular, alignment: .right).then {
        $0.textColor = .gray200
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
        indicatorView.removeFromSuperview()
        contentView.addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        descriptionLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(menuTitleLabel.snp.trailing)
        }
    }
}

extension LabelMenuCell {
    func configureUI(
        menuImage: UIImage,
        menuTitle: String,
        description: String
    ) {
        super.configureUI(menuImage: menuImage, menuTitle: menuTitle)
        descriptionLabel.setText(description)
    }
}

