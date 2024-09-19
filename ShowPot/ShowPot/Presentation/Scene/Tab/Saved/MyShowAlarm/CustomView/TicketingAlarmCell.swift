//
//  TicketingAlarmCell.swift
//  ShowPot
//
//  Created by 이건준 on 8/9/24.
//

import UIKit

import SnapKit
import Then

final class TicketingAlarmCell: UICollectionViewCell, ReusableCell {
    
    private var isChecked: Bool = false
    private var isEnabled: Bool = true
    
    private let timeInfoLabel = SPLabel(KRFont.H2).then {
        $0.textColor = .gray000
    }
    
    private lazy var checkImageView = UIImageView().then {
        $0.image = .icCheckboxOff
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var disEnabledAlertLabel = SPLabel(KRFont.B3_semibold, alignment: .right).then {
        $0.setText(Strings.myShowDisenabledTitle)
        $0.textColor = .mainOrange
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
    
    private func setupStyles() {
        contentView.layer.borderWidth = 1
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .gray500
    }
    
    private func setupLayouts() {
        [timeInfoLabel, checkImageView].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        timeInfoLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }
        
        checkImageView.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(timeInfoLabel.snp.trailing)
            $0.trailing.equalToSuperview().inset(15)
            $0.size.equalTo(24)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func updateLayoutIfNeeded() {
        if !isEnabled {
            checkImageView.removeFromSuperview()
            checkImageView.snp.removeConstraints()
            contentView.addSubview(disEnabledAlertLabel)
            disEnabledAlertLabel.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(18)
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(timeInfoLabel)
            }
            timeInfoLabel.textColor = .gray400
            contentView.layer.borderColor = UIColor.gray500.cgColor
            return
        }
        
        contentView.layer.borderColor = isChecked ? UIColor.mainOrange.cgColor : UIColor.gray500.cgColor
        checkImageView.image = isChecked ? .icCheckboxOn : .icCheckboxOff
    }
}

// MARK: - Data Configuration

struct TicketingAlarmCellModel: Hashable {
    var isChecked: Bool
    let isEnabled: Bool
    let ticketingAlertText: String
    
    private let identifier = UUID()
}

extension TicketingAlarmCell {
    
    func configureUI(with model: TicketingAlarmCellModel) {
        self.configureUI(
            isChecked: model.isChecked,
            isEnabled: model.isEnabled,
            ticketingAlertText: model.ticketingAlertText
        )
    }
    
    func configureUI(
        isChecked: Bool,
        isEnabled: Bool,
        ticketingAlertText: String
    ) {
        self.isEnabled = isEnabled
        self.isChecked = isChecked
        timeInfoLabel.setText(ticketingAlertText)
        updateIfNeeded()
    }
}
