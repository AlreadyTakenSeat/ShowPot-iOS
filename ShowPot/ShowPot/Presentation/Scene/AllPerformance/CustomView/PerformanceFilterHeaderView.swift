//
//  PerformanceFilterHeaderView.swift
//  ShowPot
//
//  Created by 이건준 on 8/2/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class PerformanceFilterHeaderView: UICollectionReusableView, ReusableCell {
    
    var didTappedCheckBox: Observable<Bool> {
        checkBoxButton.rx.tap
            .withUnretained(self)
            .map { !$0.0.checkBoxButton.isChecked }
            .asObservable()
            .share(replay: 1)
    }
    
    private let disposeBag = DisposeBag()
    private let checkBoxButton = CheckBoxButton(title: "오픈예정 티켓만 보기")
    private let filterAreaView = UIView().then { // FIXME: - 추후 필터를 위한 UI로 변경 필수
        $0.backgroundColor = .red
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
        setupConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        [checkBoxButton, filterAreaView].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        checkBoxButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.directionalVerticalEdges.equalToSuperview().inset(8)
        }
        
        filterAreaView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(83)
            $0.height.equalTo(40)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func bind() {
        didTappedCheckBox
            .subscribe(checkBoxButton.rx.isChecked)
            .disposed(by: disposeBag)
    }
}
