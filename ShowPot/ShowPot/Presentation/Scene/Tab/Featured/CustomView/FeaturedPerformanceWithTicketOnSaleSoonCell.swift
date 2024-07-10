//
//  FeaturedPerformanceWithTicketOnSaleSoonCell.swift
//  ShowPot
//
//  Created by 이건준 on 7/11/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

struct FeaturedPerformanceWithTicketOnSaleSoonCellModel {
    let ticketingOpenTime: String
    let performanceTitle: String
    let performanceLocation: String
    let performanceImageURL: URL?
}

final class FeaturedPerformanceWithTicketOnSaleSoonCell: UICollectionViewCell, ReusableCell {
    
    private let ticketingInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 12.5, left: .zero, bottom: 12.5, right: 7)
        $0.spacing = 3
    }
    
    private let ticketingOpenTimeLabel = UILabel().then {
        $0.font = ENFont.H5
        $0.textColor = .mainYellow
    }
    
    private let performanceTitleLabel = UILabel().then {
        $0.font = ENFont.H3
        $0.textAlignment = .left
        $0.textColor = .white // TODO: #44 애셋 네이밍 변경 이후 작업 필요
    }
    
    private let performanceLocationLabel = UILabel().then {
        $0.font = KRFont.B2_regular
        $0.textAlignment = .left
        $0.textColor = .gray300
    }
    
    private let performanceBackgroundImageView = UIImageView().then { // TODO: Linear적용
        $0.backgroundColor = .yellow
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        performanceBackgroundImageView.image = nil
        performanceTitleLabel.text = nil
        performanceLocationLabel.text = nil
        ticketingOpenTimeLabel.text = nil
    }
    
    private func setupStyles() {
        contentView.backgroundColor = .gray700
    }
    
    private func setupLayouts() {
        [ticketingInfoStackView, performanceBackgroundImageView].forEach { contentView.addSubview($0) }
        [ticketingOpenTimeLabel, performanceTitleLabel, performanceLocationLabel].forEach { ticketingInfoStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        
        performanceBackgroundImageView.snp.makeConstraints {
            $0.trailing.directionalVerticalEdges.equalToSuperview()
            $0.width.equalTo(178.5)
        }
        
        ticketingInfoStackView.snp.makeConstraints {
            $0.leading.directionalVerticalEdges.equalToSuperview()
            $0.trailing.equalTo(performanceBackgroundImageView.snp.leading)
        }
        
        performanceTitleLabel.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        ticketingOpenTimeLabel.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        
        performanceLocationLabel.snp.makeConstraints {
            $0.height.equalTo(21)
        }
    }
    
}

extension FeaturedPerformanceWithTicketOnSaleSoonCell {
    func configureUI(with model: FeaturedPerformanceWithTicketOnSaleSoonCellModel) {
        performanceBackgroundImageView.kf.setImage(with: model.performanceImageURL)
        ticketingOpenTimeLabel.setAttributedText(font: ENFont.self, string: model.ticketingOpenTime)
        performanceTitleLabel.setAttributedText(font: ENFont.self, string: model.performanceTitle)
        performanceLocationLabel.setAttributedText(font: KRFont.self, string: model.performanceLocation)
    }
}

