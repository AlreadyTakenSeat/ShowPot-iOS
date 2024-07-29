//
//  FeaturedRecentSearchCell.swift
//  ShowPot
//
//  Created by 이건준 on 7/22/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

/// 최근검색키워드에 대한 셀
final class FeaturedRecentSearchCell: UICollectionViewCell, ReusableCell {
    
    var didTappedRemoveKeywordButton: Observable<Void> {
        removeKeywordButton.rx.tap.asObservable()
    }
    
    private let recentSearchKeywordLabel = SPLabel(KRFont.B1_regular).then {
        $0.textColor = .gray000
    }
    
    private let removeKeywordButton = UIButton().then {
        $0.setImage(.icCancel.withTintColor(.gray300), for: .normal)
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
        contentView.backgroundColor = .gray700
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 18
        contentView.layer.borderColor = UIColor.gray400.cgColor
        contentView.layer.borderWidth = 1
    }
    
    private func setupLayouts() {
        [recentSearchKeywordLabel, removeKeywordButton].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        recentSearchKeywordLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.directionalVerticalEdges.equalToSuperview().inset(8)
        }
        
        removeKeywordButton.snp.makeConstraints {
            $0.directionalVerticalEdges.trailing.equalToSuperview().inset(8)
            $0.leading.equalTo(recentSearchKeywordLabel.snp.trailing)
            $0.size.equalTo(24)
        }
    }
}

extension FeaturedRecentSearchCell {
    func configureUI(with searchKeyword: String) {
        recentSearchKeywordLabel.setText(searchKeyword)
    }
}
