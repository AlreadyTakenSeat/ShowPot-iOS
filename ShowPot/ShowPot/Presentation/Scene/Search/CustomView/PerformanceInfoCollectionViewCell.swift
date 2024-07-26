//
//  PerformanceInfoCollectionViewCell.swift
//  ShowPot
//
//  Created by 이건준 on 7/24/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class PerformanceInfoCollectionViewCell: UICollectionViewCell, ReusableCell {
    
    private let performanceImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    
    private let performanceTitleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = ENFont.H2
    }
    
    private let performanceTimeLabel = UILabel().then {
        $0.textColor = .gray200
        $0.font = KRFont.B3_regular
    }
    
    private let performanceLocationLabel = UILabel().then {
        $0.textColor = .gray200
        $0.font = KRFont.B3_regular
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
        [performanceImageView, performanceTitleLabel, performanceTimeLabel, performanceLocationLabel].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        performanceImageView.snp.makeConstraints {
            $0.leading.directionalVerticalEdges.equalToSuperview()
            $0.size.equalTo(80)
        }
        
        performanceTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(3)
            $0.leading.equalTo(performanceImageView.snp.trailing).offset(14)
            $0.trailing.lessThanOrEqualToSuperview()
            $0.height.equalTo(33)
        }
        
        performanceTimeLabel.snp.makeConstraints {
            $0.leading.equalTo(performanceTitleLabel)
            $0.trailing.lessThanOrEqualToSuperview()
            $0.top.equalTo(performanceTitleLabel.snp.bottom).offset(5)
            $0.height.equalTo(18)
        }
        
        performanceLocationLabel.snp.makeConstraints {
            $0.leading.equalTo(performanceTimeLabel)
            $0.trailing.lessThanOrEqualToSuperview()
            $0.top.equalTo(performanceTimeLabel.snp.bottom).offset(1)
            $0.bottom.equalToSuperview().inset(2)
            $0.height.equalTo(18)
        }
    }
}

struct PerformanceInfoCollectionViewCellModel: Hashable {
    let performanceImageURL: URL?
    let performanceTitle: String
    let performanceTime: String
    let performanceLocation: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    private let identifier = UUID() // TODO: - 추후 공연정보에 대한 아이디로 대체
}

extension PerformanceInfoCollectionViewCell {
    func configureUI(with model: PerformanceInfoCollectionViewCellModel) {
        performanceImageView.kf.setImage(with: model.performanceImageURL)
        performanceTitleLabel.setAttributedText(font: ENFont.self, string: model.performanceTitle)
        performanceTimeLabel.setAttributedText(font: KRFont.self, string: model.performanceTime)
        performanceLocationLabel.setAttributedText(font: KRFont.self, string: model.performanceLocation)
    }
}
