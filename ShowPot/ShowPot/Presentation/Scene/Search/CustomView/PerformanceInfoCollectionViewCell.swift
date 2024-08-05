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

/// 공연정보에 대한 셀
final class PerformanceInfoCollectionViewCell: UICollectionViewCell, ReusableCell {
    
    private let performanceImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    
    private let performanceTitleLabel = SPLabel(ENFont.H2).then {
        $0.textColor = .gray000
    }
    
    private let performanceTimeLabel = SPLabel(KRFont.B3_regular).then {
        $0.textColor = .gray200
    }
    
    private let performanceLocationLabel = SPLabel(KRFont.B3_regular).then {
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
        performanceImageView.image = nil
        performanceTitleLabel.text = nil
        performanceTimeLabel.text = nil
        performanceLocationLabel.text = nil
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
    let performanceTime: Date?
    let performanceLocation: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    private let identifier = UUID() // TODO: - 추후 공연정보에 대한 아이디로 대체
}

extension PerformanceInfoCollectionViewCell {
    func configureUI(with model: PerformanceInfoCollectionViewCellModel) {
        self.configureUI(
            performanceImageURL: model.performanceImageURL,
            performanceTitle: model.performanceTitle,
            performanceTime: model.performanceTime,
            performanceLocation: model.performanceLocation
        )
    }
    
    func configureUI(
        performanceImageURL: URL?,
        performanceTitle: String,
        performanceTime: Date?,
        performanceLocation: String
    ) {
        let formattedTime: String
        if let time = performanceTime {
            formattedTime = DateFormatterFactory.dateWithDot.string(from: time)
        } else {
            LogHelper.error("서버에서 내려준 포맷과 일치하지않습니다, 확인해주세요.")
            formattedTime = ""
        }
        
        performanceImageView.kf.setImage(with: performanceImageURL)
        performanceTitleLabel.setText(performanceTitle)
        performanceTimeLabel.setText(formattedTime)
        performanceLocationLabel.setText(performanceLocation)
    }
}
