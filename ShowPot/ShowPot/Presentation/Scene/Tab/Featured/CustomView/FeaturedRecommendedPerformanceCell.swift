//
//  FeaturedRecommendedPerformanceCell.swift
//  ShowPot
//
//  Created by 이건준 on 7/26/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class FeaturedRecommendedPerformanceCell: UICollectionViewCell, ReusableCell {
    
    private let recommendedPerformanceThumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    
    private let titleContainer = UIView().then { view in
        view.backgroundColor = .clear
    }
    
    private let recommendedPerformanceTitleLabel = SPLabel(ENFont.H4).then {
        $0.textColor = .gray000
        $0.numberOfLines = 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .gray500
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recommendedPerformanceThumbnailImageView.image = nil
        recommendedPerformanceTitleLabel.text = nil
    }
    
    private func setupLayouts() {
        [recommendedPerformanceThumbnailImageView, titleContainer].forEach { contentView.addSubview($0) }
        titleContainer.addSubview(recommendedPerformanceTitleLabel)
    }
    
    private func setupConstraints() {
        recommendedPerformanceThumbnailImageView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(260)
        }
        
        titleContainer.snp.makeConstraints { make in
            make.top.equalTo(recommendedPerformanceThumbnailImageView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        recommendedPerformanceTitleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
            $0.height.lessThanOrEqualToSuperview()
        }
    }
}

struct FeaturedRecommendedPerformanceCellModel {
    let showID: String
    let recommendedPerformanceThumbnailURL: URL?
    let recommendedPerformanceTitle: String
}

extension FeaturedRecommendedPerformanceCell {
    func configureUI(with model: FeaturedRecommendedPerformanceCellModel) {
        recommendedPerformanceThumbnailImageView.kf.setImage(with: model.recommendedPerformanceThumbnailURL)
        recommendedPerformanceTitleLabel.attributedText = NSAttributedString(model.recommendedPerformanceTitle, fontType: ENFont.H4)
    }
}
