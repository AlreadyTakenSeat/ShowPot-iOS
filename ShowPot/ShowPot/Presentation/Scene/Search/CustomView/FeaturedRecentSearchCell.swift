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

final class FeaturedRecentSearchCell: UICollectionViewCell, ReusableCell {
    
    var didTappedXButton: Observable<Void> {
        xButton.rx.tap.asObservable()
    }
    
    private let recentSearchQueryLabel = UILabel().then {
        $0.textColor = .white
        $0.font = KRFont.B1_regular
    }
    
    private let xButton = UIButton().then {
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
        [recentSearchQueryLabel, xButton].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        recentSearchQueryLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.directionalVerticalEdges.equalToSuperview().inset(8)
        }
        
        xButton.snp.makeConstraints {
            $0.directionalVerticalEdges.trailing.equalToSuperview().inset(8)
            $0.leading.equalTo(recentSearchQueryLabel.snp.trailing)
            $0.size.equalTo(24)
        }
    }
}

struct FeaturedRecentSearchCellModel {
    let recentSearchQuery: String
}

extension FeaturedRecentSearchCell {
    func configureUI(with model: FeaturedRecentSearchCellModel) {
        recentSearchQueryLabel.setAttributedText(font: KRFont.self, string: model.recentSearchQuery) 
        recentSearchQueryLabel.lineBreakMode = .byTruncatingTail // TODO: - attribute적용 이후 lineBreakMode적용안되는 문제 해결 필요
    }
}
