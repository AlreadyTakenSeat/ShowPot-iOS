//
//  ShowDetailSeatInfoView.swift
//  ShowPot
//
//  Created by 이건준 on 8/22/24.
//

import UIKit

import SnapKit
import Then

final class ShowDetailSeatInfoView: UIView {
    
    private let titleLabel = SPLabel(KRFont.H2).then { label in
        label.textColor = .gray000
        label.setText(Strings.showSeatPriceInfo)
    }
    
    private let showSeatListViewLayout = LeftAlignedCollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 8
        $0.scrollDirection = .vertical
    }
    
    private let showSeatListContainerView = UIView().then {
        $0.backgroundColor = .gray600
    }
    
    lazy var showSeatListView = AutoSizingCollectionView(frame: .zero, collectionViewLayout: showSeatListViewLayout).then {
        $0.register(ShowSeatCell.self)
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
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
        [titleLabel, showSeatListContainerView].forEach { addSubview($0) }
        showSeatListContainerView.addSubview(showSeatListView)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        showSeatListContainerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(14)
        }
        
        showSeatListView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview().inset(12)
        }
    }
}

final class ShowSeatCell: UICollectionViewCell, ReusableCell {

    private let seatCategoryLabel = SPLabel(KRFont.B1_regular).then {
        $0.textColor = .gray300
    }
    
    private let priceLabel = SPLabel(KRFont.B1_regular).then {
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        seatCategoryLabel.text = nil
        priceLabel.text = nil
    }
    
    private func setupLayouts() {
        [seatCategoryLabel, priceLabel].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        seatCategoryLabel.snp.makeConstraints {
            $0.leading.directionalVerticalEdges.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints {
            $0.leading.equalTo(seatCategoryLabel.snp.trailing).offset(10)
            $0.directionalVerticalEdges.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
    }
}

extension ShowSeatCell {
    func configureUI(
        seatCategory: String,
        seatPrice: String?
    ) {
        seatCategoryLabel.setText(seatCategory)
        if let seatPrice = seatPrice {
            priceLabel.setText("\(seatPrice)원")
        } else {
            priceLabel.setText("가격정보 없음")
        }
    }
}
