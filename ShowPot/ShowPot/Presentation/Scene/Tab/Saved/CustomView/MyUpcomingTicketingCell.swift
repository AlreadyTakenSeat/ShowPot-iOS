//
//  MyUpcomingTicketingCell.swift
//  ShowPot
//
//  Created by 이건준 on 8/13/24.
//

import UIKit

import ScalingCarousel
import SnapKit
import Then

final class MyUpcomingTicketingCell: ScalingCarouselCell, ReusableCell {
    private let backgroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    
    private let showImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    
    private let showTitleLabel = SPLabel(ENFont.H0).then {
        $0.textColor = .gray800
    }
    
    private let showDateLabel = SPLabel(KRFont.B2_regular).then {
        $0.textColor = .gray700
    }
    
    private let showLocationLabel = SPLabel(KRFont.B2_regular).then {
        $0.textColor = .gray700
    }
    
    private let ticketingTitleLabel = SPLabel(ENFont.H5, alignment: .center).then {
        $0.textColor = .gray700
        $0.setText(Strings.myAlarmTicketTitle)
    }
    
    private let ticketingOpenTimeLabel = SPLabel(ENFont.H1, alignment: .center).then {
        $0.textColor = .gray700
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
        mainView = UIView(frame: contentView.bounds)
        contentView.addSubview(mainView)
        mainView.addSubview(backgroundImageView)
        [showImageView, showTitleLabel, showDateLabel, showLocationLabel, ticketingTitleLabel, ticketingOpenTimeLabel].forEach { backgroundImageView.addSubview($0) }
    }
    
    private func setupConstraints() {
        
        mainView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        showImageView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(160)
        }
        
        showTitleLabel.snp.makeConstraints {
            $0.top.equalTo(showImageView.snp.bottom).offset(8)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        showDateLabel.snp.makeConstraints {
            $0.top.equalTo(showTitleLabel.snp.bottom).offset(5)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        showLocationLabel.snp.makeConstraints {
            $0.top.equalTo(showDateLabel.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        ticketingOpenTimeLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        
        ticketingTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(ticketingOpenTimeLabel.snp.top)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.top.greaterThanOrEqualTo(showLocationLabel.snp.bottom)
        }
    }
}

// MARK: - Data Configuration

struct MyUpcomingTicketingCellModel {
    let backgroundImage: UIImage
    let showThubnailURL: URL?
    let showName: String
    let showLocation: String
    let showStartTime: Date?
    let showEndTime: Date?
    let ticketingOpenTime: Date?
}

extension MyUpcomingTicketingCell {
    func configureUI(with model: MyUpcomingTicketingCellModel) {
        self.configureUI(
            backgroundImage: model.backgroundImage,
            showThubnailURL: model.showThubnailURL,
            showName: model.showName,
            showLocation: model.showLocation,
            showStartTime: model.showStartTime,
            showEndTime: model.showEndTime,
            ticketingOpenTime: model.ticketingOpenTime
        )
    }
    
    func configureUI(
        backgroundImage: UIImage,
        showThubnailURL: URL?,
        showName: String,
        showLocation: String,
        showStartTime: Date?,
        showEndTime: Date?,
        ticketingOpenTime: Date?
    ) {
        if let startTime = showStartTime,
           let endTime = showEndTime,
           let openTime = ticketingOpenTime {
            let showDate = DateFormatterFactory.dateWithDot.string(from: startTime) + " - " + DateFormatterFactory.dateWithDot.string(from: endTime)
            showDateLabel.setText(showDate)
            ticketingOpenTimeLabel.setText(DateFormatterFactory.dateWithPerformance.string(from: openTime).uppercased())
        } else {
            showDateLabel.setText("")
            ticketingOpenTimeLabel.setText("")
        }
        backgroundImageView.image = backgroundImage
        showImageView.kf.setImage(with: showThubnailURL)
        showTitleLabel.setText(showName)
        showLocationLabel.setText(showLocation)
    }
}

