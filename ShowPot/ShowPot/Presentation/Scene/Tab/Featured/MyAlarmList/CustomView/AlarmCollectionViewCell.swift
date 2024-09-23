//
//  AlarmCollectionViewCell.swift
//  ShowPot
//
//  Created by 이건준 on 9/23/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class AlarmCollectionViewCell: UICollectionViewCell, ReusableCell {
    
    private let showThumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    
    private let mainAlarmLabel = SPLabel(KRFont.B1_semibold).then {
        $0.textColor = .gray000
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let subAlarmLabel = SPLabel(KRFont.B1_regular).then {
        $0.textColor = .gray200
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let timeLeftLabel = SPLabel(KRFont.B3_regular).then {
        $0.textColor = .gray200
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
        showThumbnailImageView.image = nil
        mainAlarmLabel.text = nil
        subAlarmLabel.text = nil
        timeLeftLabel.text = nil
    }
    
    private func setupLayouts() {
        [showThumbnailImageView, mainAlarmLabel, subAlarmLabel, timeLeftLabel].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        showThumbnailImageView.snp.makeConstraints {
            $0.leading.directionalVerticalEdges.equalToSuperview()
            $0.size.equalTo(80)
        }
        
        mainAlarmLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(3)
            $0.leading.equalTo(showThumbnailImageView.snp.trailing).offset(14)
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        subAlarmLabel.snp.makeConstraints {
            $0.leading.equalTo(mainAlarmLabel)
            $0.top.equalTo(mainAlarmLabel.snp.bottom).offset(4)
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        timeLeftLabel.snp.makeConstraints {
            $0.top.equalTo(subAlarmLabel.snp.bottom).offset(5)
            $0.leading.equalTo(mainAlarmLabel)
            $0.trailing.bottom.lessThanOrEqualToSuperview()
        }
    }
}

// MARK: - Data Configuration

extension AlarmCollectionViewCell {
    func configureUI(
        thumbnailImageURL: URL?,
        mainAlarm: String,
        subAlarm: String,
        timeLeft: String
    ) {
        showThumbnailImageView.kf.setImage(with: thumbnailImageURL)
        mainAlarmLabel.setText(mainAlarm)
        subAlarmLabel.setText(subAlarm)
        timeLeftLabel.setText(timeLeft)
    }
}
