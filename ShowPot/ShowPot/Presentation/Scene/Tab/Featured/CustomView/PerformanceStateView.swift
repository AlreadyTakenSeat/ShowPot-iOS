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
    case upcoming
    case reserving
    
    var title: String {
        switch self {
        case .upcoming:
            return "오픈예정"
        case .reserving:
            return "예매중"
        }
    }
    
    var chipColor: UIColor {
        switch self {
        case .upcoming:
            return .mainYellow
        case .reserving:
            return .mainBlue
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
    
    private let performanceStateView = SPLabel(KRFont.B2_regular, alignment: .center)
    
    private lazy var ticketingOpenTimeLabel = SPLabel(ENFont.H5).then {
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
    func configureUI(
        performanceDate: Date?,
        chipColor: UIColor?,
        chipTitle: String?
    ) {
        if let performanceDate = performanceDate {
            let dateFormatter = DateFormatter() // TODO: #95 Date관련 공통함수로 코드 개선
            dateFormatter.dateFormat = "MM.dd(EEE) HH:mm"
            dateFormatter.locale = Locale(identifier: "en_US")
            ticketingOpenTimeLabel.setText(dateFormatter.string(from: performanceDate))
        }
        performanceStateView.textColor = chipColor
        stateContainer.layer.borderColor = chipColor?.cgColor
        performanceStateView.setText(chipTitle ?? "")
    }
}
