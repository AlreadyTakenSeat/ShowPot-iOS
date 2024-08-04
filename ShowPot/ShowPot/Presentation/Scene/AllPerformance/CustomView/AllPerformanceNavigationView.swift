//
//  AllPerformanceNavigationView.swift
//  ShowPot
//
//  Created by 이건준 on 8/2/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class AllPerformanceNavigationView: UIView {
    
    var didTappedBackButton: Observable<Void> {
        backButton.rx.tap.asObservable()
    }
    
    var didTappedSearchButton: Observable<Void> {
        searchButton.rx.tap.asObservable()
    }
    
    private let backButton = UIButton().then {
        $0.setImage(.icArrowLeft.withTintColor(.gray000), for: .normal)
    }
    
    private let navigationTitleLabel = SPLabel(KRFont.H1).then {
        $0.textColor = .gray100
        $0.text = Strings.allPerformanceTitle
    }
    
    private let searchButton = UIButton().then {
        $0.setImage(.icMagnifier.withTintColor(.gray100), for: .normal)
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
        [backButton, navigationTitleLabel, searchButton].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(6)
            $0.directionalVerticalEdges.equalToSuperview().inset(4)
            $0.size.equalTo(36)
        }
        
        navigationTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing).offset(4)
            $0.centerY.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.directionalVerticalEdges.equalToSuperview().inset(4)
            $0.size.equalTo(36)
        }
    }
}
