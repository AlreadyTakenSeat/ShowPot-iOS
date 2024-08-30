//
//  FeaturedOnlyTitleHeaderView.swift
//  ShowPot
//
//  Created by 이건준 on 7/26/24.
//

import UIKit

import SnapKit
import Then

final class FeaturedOnlyTitleHeaderView: UICollectionReusableView, ReusableCell {
    
    private let titleLabel = SPLabel(KRFont.H1).then {
        $0.textColor = .gray100
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
        backgroundColor = .gray700
    }
    
    private func setupLayouts() {
        addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

extension FeaturedOnlyTitleHeaderView {
    func configureUI(with title: String) {
        titleLabel.setText(title)
    }
}
