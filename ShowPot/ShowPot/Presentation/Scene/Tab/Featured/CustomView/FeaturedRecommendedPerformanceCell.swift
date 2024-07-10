//
//  FeaturedRecommendedPerformanceCell.swift
//  ShowPot
//
//  Created by 이건준 on 7/11/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

struct FeaturedRecommendedPerformanceCellModel {
    let recommendedPerformanceThumbnailURL: URL?
    let recommendedPerformanceTitle: String
}

final class FeaturedRecommendedPerformanceCell: UICollectionViewCell, ReusableCell {
    
    private let recommendedPerformanceThumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let recommendedPerformanceTitleLabel = PaddingLabel(withInsets: 11, 11, 14, 14).then {
        $0.font = ENFont.H4
        $0.textAlignment = .left
        $0.textColor = .white // TODO: #44 애셋 네이밍 변경 이후 작업 필요
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

extension FeaturedRecommendedPerformanceCell {
    func configureUI(with model: FeaturedRecommendedPerformanceCellModel) {
        recommendedPerformanceThumbnailImageView.kf.setImage(with: model.recommendedPerformanceThumbnailURL)
        recommendedPerformanceTitleLabel.setAttributedText(font: ENFont.self, string: model.recommendedPerformanceTitle)
    }
}


