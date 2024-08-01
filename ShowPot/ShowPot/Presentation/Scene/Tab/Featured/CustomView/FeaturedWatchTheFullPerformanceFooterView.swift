//
//  FeaturedWatchTheFullPerformanceFooterView.swift
//  ShowPot
//
//  Created by 이건준 on 7/26/24.
//

import UIKit

import RxCocoa
import SnapKit
import Then

final class FeaturedWatchTheFullPerformanceFooterView: UICollectionReusableView, ReusableCell {
    
    static let identifier = String(describing: FeaturedWatchTheFullPerformanceFooterView.self) // TODO: #46 identifier 지정코드로 변환
    
    var didTappedButton: ControlEvent<Void> {
        watchTheFullPerformanceButton.rx.tap
    }
    
    private let watchTheFullPerformanceButton = SPButton(.disclosureButton).then { button in
        button.setText(Strings.homeTicketingPerformanceButtonTitle)
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
        addSubview(watchTheFullPerformanceButton)
    }
    
    private func setupConstraints() {
        watchTheFullPerformanceButton.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(42)
        }
    }
}
