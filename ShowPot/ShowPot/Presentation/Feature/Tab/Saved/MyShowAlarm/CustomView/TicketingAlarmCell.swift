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
    
    private let timeInfoLabel = SPLabel(KRFont.H2)
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        timeInfoLabel.text = nil
        checkImageView.image = nil
        contentView.layer.borderColor = nil
        disEnabledAlertLabel.removeFromSuperview()
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
}

extension TicketingAlarmCell {
    private func updateCellStateChanges() {
        updateLayout()
        updateUI()
    }
    
    private func updateLayout() {
        if !isEnabled {
            if disEnabledAlertLabel.superview == nil {
                contentView.addSubview(disEnabledAlertLabel)
                disEnabledAlertLabel.snp.makeConstraints {
                    $0.trailing.equalToSuperview().inset(18)
                    $0.centerY.equalToSuperview()
                    $0.leading.equalTo(timeInfoLabel)
                }
            }
            checkImageView.removeFromSuperview()
        } else {
            if checkImageView.superview == nil {
                contentView.addSubview(checkImageView)
                setupConstraints()
            }
            disEnabledAlertLabel.removeFromSuperview()
        }
    }
    
    private func updateUI() {
        timeInfoLabel.textColor = isEnabled ? .gray000 : .gray400
        contentView.layer.borderColor = isEnabled ? (isChecked ? UIColor.mainOrange.cgColor : UIColor.gray500.cgColor) : UIColor.gray500.cgColor
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
        updateCellStateChanges()
    }
}
