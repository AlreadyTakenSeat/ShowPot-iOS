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
        $0.layoutMargins = .init(top: 12.5, left: .zero, bottom: 12.5, right: .zero)
        $0.spacing = 3
    }
    
    private let performanceStateView = PerformanceStateView()
    
    private let performanceTitleLabel = SPLabel(ENFont.H3).then {
        $0.textColor = .gray000
    }
    
    private let performanceLocationLabel = SPLabel(KRFont.B2_regular).then {
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
        [performanceStateView, performanceTitleLabel, performanceLocationLabel].forEach { ticketingInfoStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        performanceBackgroundImageView.snp.makeConstraints {
            $0.leading.equalTo(self.snp.centerX)
            $0.trailing.directionalVerticalEdges.equalToSuperview()
        }
        
        ticketingInfoStackView.snp.makeConstraints {
            $0.leading.directionalVerticalEdges.equalToSuperview()
            $0.trailing.equalTo(performanceBackgroundImageView.snp.leading).offset(30)
        }
        
        performanceTitleLabel.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        performanceStateView.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        
        performanceLocationLabel.snp.makeConstraints {
            $0.height.equalTo(21)
        }
        contentView.bringSubviewToFront(ticketingInfoStackView)
    }
    
}

struct FeaturedPerformanceWithTicketOnSaleSoonCellModel {
    let performanceState: PerformanceState
    let performanceTitle: String
    let performanceLocation: String
    let performanceImageURL: URL?
    let performanceDate: Date?
}

extension FeaturedPerformanceWithTicketOnSaleSoonCell {
    func configureUI(with model: FeaturedPerformanceWithTicketOnSaleSoonCellModel) {
        performanceBackgroundImageView.kf.setImage(with: model.performanceImageURL)
        performanceStateView.configureUI(
            performanceDate: model.performanceDate,
            chipColor: model.performanceState.chipColor,
            chipTitle: model.performanceState.title
        )
        performanceTitleLabel.setText(model.performanceTitle)
        performanceLocationLabel.setText(model.performanceLocation)
        
        performanceBackgroundImageView.layoutIfNeeded()
    }
    
    func configureUI(
        performanceTitle: String,
        performanceLocation: String,
        performanceImageURL: URL?,
        performanceDate: Date?,
        chipColor: UIColor,
        chipTitle: String
    ) {
        performanceBackgroundImageView.kf.setImage(with: performanceImageURL)
        performanceStateView.configureUI(
            performanceDate: performanceDate,
            chipColor: chipColor,
            chipTitle: chipTitle
        )
        performanceTitleLabel.setText(performanceTitle)
        performanceLocationLabel.setText(performanceLocation)

        performanceBackgroundImageView.layoutIfNeeded()
    }
}
