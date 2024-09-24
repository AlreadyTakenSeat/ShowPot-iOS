//
//  ShowAlarmButtonView.swift
//  ShowPot
//
//  Created by 이건준 on 8/9/24.
//

import UIKit

import SnapKit
import Then

final class ShowAlarmButtonView: UIView {
    
    private let containerView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.layoutMargins = .init(top: 5, left: 5, bottom: 5, right: 5)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.backgroundColor = .gray500
    }
    
    private let alarmView = UIImageView().then {
        $0.image = .icAlarmSmall.withTintColor(.gray000)
        $0.contentMode = .scaleAspectFit
    }
    
    private let indicatorView = UIImageView().then {
        $0.image = .icArrowDown.withTintColor(.gray300)
        $0.contentMode = .scaleAspectFit
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
        addSubview(containerView)
        [alarmView, indicatorView].forEach { containerView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }

    }
}
