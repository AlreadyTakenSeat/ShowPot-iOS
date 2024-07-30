//
//  FeaturedPerformanceWithTicketOnSaleSoonCell.swift
//  ShowPot
//
//  Created by 이건준 on 7/26/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

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
        $0.textColor = .white
    }
    
    private let performanceLocationLabel = UILabel().then {
        $0.font = KRFont.B2_regular
        $0.textAlignment = .left
        $0.textColor = .gray300
    }
    
    private let performanceBackgroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.applyLinearGradient(
            colors: [
                .gray700.withAlphaComponent(1.0),
                .gray700.withAlphaComponent(0.3),
                .gray700.withAlphaComponent(0.0)
            ],
            startPoint: .init(x: 0.0, y: 0.5),
            endPoint: .init(x: 1.0, y: 0.5)
        )
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        performanceBackgroundImageView.updateGradientLayerFrame()
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

struct FeaturedPerformanceWithTicketOnSaleSoonCellModel {
    let ticketingOpenTime: String
    let performanceTitle: String
    let performanceLocation: String
    let performanceImageURL: URL?
}

extension FeaturedPerformanceWithTicketOnSaleSoonCell {
    func configureUI(with model: FeaturedPerformanceWithTicketOnSaleSoonCellModel) {
        performanceBackgroundImageView.kf.setImage(with: model.performanceImageURL)
        ticketingOpenTimeLabel.setAttributedText(font: ENFont.self, string: model.ticketingOpenTime)
        performanceTitleLabel.setAttributedText(font: ENFont.self, string: model.performanceTitle)
        performanceLocationLabel.setAttributedText(font: KRFont.self, string: model.performanceLocation)
        
        // TODO: - attribute적용이후 lineBreakMode적용안되는 문제 해결 필요
        ticketingOpenTimeLabel.lineBreakMode = .byTruncatingTail
        performanceTitleLabel.lineBreakMode = .byTruncatingTail
        performanceLocationLabel.lineBreakMode = .byTruncatingTail
        performanceBackgroundImageView.layoutIfNeeded()
    }
}
