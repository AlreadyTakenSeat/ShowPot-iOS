//
//  PerformanceStateView.swift
//  ShowPot
//
//  Created by 이건준 on 7/31/24.
//

import UIKit

import SnapKit
import Then

/// 티켓팅 공연에 대한 현재 상태
enum PerformanceState {
    case upcoming(String)
    case reserving
    
    var title: String {
        switch self {
        case .upcoming:
            return "오픈예정"
        case .reserving:
            return "예매중"
        }
    }
}

final class PerformanceStateView: UIView {
    
    private let stateContainer = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 2
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 0.5
    }
    
    private let performanceStateView = UILabel().then {
        $0.font = KRFont.B2_regular
    }
    
    private lazy var ticketingOpenTimeLabel = UILabel().then {
        $0.font = ENFont.H5
        $0.textColor = .mainYellow
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
        [stateContainer, ticketingOpenTimeLabel].forEach { addSubview($0) }
        stateContainer.addSubview(performanceStateView)
    }
    
    private func setupConstraints() {
        stateContainer.snp.makeConstraints {
            $0.leading.directionalVerticalEdges.equalToSuperview()
        }
        
        performanceStateView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(8)
            $0.directionalVerticalEdges.equalToSuperview()
        }
        
        ticketingOpenTimeLabel.snp.makeConstraints {
            $0.leading.equalTo(stateContainer.snp.trailing).offset(6)
            $0.directionalVerticalEdges.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
    }
}

extension PerformanceStateView {
    func configureUI(with model: PerformanceState) {
        switch model {
        case .upcoming(let string):
            performanceStateView.textColor = .mainYellow
            stateContainer.layer.borderColor = UIColor.mainYellow.cgColor
            ticketingOpenTimeLabel.setAttributedText(font: ENFont.self, string: string, alignment: .left)
            ticketingOpenTimeLabel.lineBreakMode = .byTruncatingTail // TODO: - attribute적용이후 lineBreakMode적용안되는 문제 해결 필요
        case .reserving:
            performanceStateView.textColor = .mainBlue
            stateContainer.layer.borderColor = UIColor.mainBlue.cgColor
        }
        performanceStateView.setAttributedText(font: KRFont.self, string: model.title, alignment: .center)
    }
}

