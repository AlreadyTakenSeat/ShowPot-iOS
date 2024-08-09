//
//  AlarmSettingBottomSheetViewController.swift
//  ShowPot
//
//  Created by 이건준 on 8/9/24.
//

import UIKit

import SnapKit
import Then

final class AlarmSettingBottomSheetViewController: BottomSheetViewController {
    
    private let titleLabel = SPLabel(KRFont.H1).then {
        $0.textColor = .gray100
        $0.setText(Strings.myPerformanceAlarmBottomsheetTitle)
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.layoutMargins = .init(top: 16, left: 16, bottom: .zero, right: 16)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    let alarmUpdateButton = SPButton().then {
        $0.configuration?.baseBackgroundColor = .gray400
        $0.configuration?.baseForegroundColor = .gray000
        $0.configuration?.background.cornerRadius = 2
        $0.setText(Strings.myPerformanceAlarmBottomsheetButton1, fontType: KRFont.H2)
    }
    
    let alarmRemoveButton = SPButton().then {
        $0.configuration?.baseBackgroundColor = .gray400
        $0.configuration?.baseForegroundColor = .gray000
        $0.configuration?.background.cornerRadius = 2
        $0.setText(Strings.myPerformanceAlarmBottomsheetButton2, fontType: KRFont.H2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        setupConstraints()
    }
    
    private func setupLayouts() {
        [titleLabel, buttonStackView].forEach { contentView.addSubview($0) }
        [alarmUpdateButton, alarmRemoveButton].forEach { buttonStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        [alarmUpdateButton, alarmRemoveButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(55)
            }
        }
    }
}
