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
    
    private let recommendedPerformanceTitleLabel = PaddingLabel(withInsets: 11, 11, 14, 14).then {
        $0.font = ENFont.H4.font
        $0.textAlignment = .left
        $0.textColor = .white
        $0.backgroundColor = .gray500
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
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
        recommendedPerformanceThumbnailImageView.image = nil
        recommendedPerformanceTitleLabel.text = nil
    }
    
    private func setupLayouts() {
        [recommendedPerformanceThumbnailImageView, recommendedPerformanceTitleLabel].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        recommendedPerformanceThumbnailImageView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(260)
        }
        
        recommendedPerformanceTitleLabel.snp.makeConstraints {
            $0.top.equalTo(recommendedPerformanceThumbnailImageView.snp.bottom)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }
}

struct FeaturedRecommendedPerformanceCellModel {
    let recommendedPerformanceThumbnailURL: URL?
    let recommendedPerformanceTitle: String
}

extension FeaturedRecommendedPerformanceCell {
    func configureUI(with model: FeaturedRecommendedPerformanceCellModel) {
        recommendedPerformanceThumbnailImageView.kf.setImage(with: model.recommendedPerformanceThumbnailURL)
        recommendedPerformanceTitleLabel.setAttributedText(font: ENFont.H4, string: model.recommendedPerformanceTitle)
        recommendedPerformanceTitleLabel.lineBreakMode = .byTruncatingTail // TODO: - attribute적용이후 lineBreakMode적용안되는 문제 해결 필요
    }
}
