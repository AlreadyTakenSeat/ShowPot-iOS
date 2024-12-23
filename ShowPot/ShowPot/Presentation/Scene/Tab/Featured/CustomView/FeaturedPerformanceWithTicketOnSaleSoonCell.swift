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
    
    private let performanceBackgroundImageView = GradientImageView(
        colors: [
            .gray700.withAlphaComponent(1.0),
            .gray700.withAlphaComponent(0.3),
            .gray700.withAlphaComponent(0.0)
        ],
        startPoint: .init(x: 0.0, y: 0.5),
        endPoint: .init(x: 1.0, y: 0.5)
    ).then { view in
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
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
        performanceStateView.configureUI(performanceDate: nil, chipColor: nil, chipTitle: nil)
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

extension FeaturedPerformanceWithTicketOnSaleSoonCell {
    func configureUI(with model: FeaturedPerformanceWithTicketOnSaleSoonCellModel) {
        self.configureUI(
            performanceTitle: model.performanceTitle,
            performanceLocation: model.performanceLocation,
            performanceImageURL: model.performanceImageURL,
            performanceDate: model.performanceDate,
            chipColor: model.performanceState.chipColor,
            chipTitle: model.performanceState.title
        )
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
