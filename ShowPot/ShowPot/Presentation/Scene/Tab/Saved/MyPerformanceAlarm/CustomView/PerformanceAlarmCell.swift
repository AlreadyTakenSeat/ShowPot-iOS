//
//  PerformanceAlarmCell.swift
//  ShowPot
//
//  Created by 이건준 on 8/9/24.
//

import UIKit

import Kingfisher
import RxSwift
import RxGesture
import SnapKit
import Then

protocol PerformanceAlarmCellDelegate: AnyObject {
    func didTappedAlarmButton(_ cell: UICollectionViewCell)
}

/// 공연알림정보에 대한 셀
final class PerformanceAlarmCell: PerformanceInfoCollectionViewCell {
    private var disposeBag = DisposeBag()
    weak var delegate: PerformanceAlarmCellDelegate?
    
    let alarmButton = PerformanceAlarmButtonView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
        setupConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func setupLayouts() {
        contentView.addSubview(alarmButton)
    }
    
    private func setupConstraints() {
        
        alarmButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(3)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(34)
            $0.width.equalTo(58)
        }
        
        performanceTimeLabel.snp.remakeConstraints {
            $0.leading.equalTo(performanceTitleLabel)
            $0.trailing.lessThanOrEqualTo(alarmButton.snp.leading)
            $0.top.equalTo(performanceTitleLabel.snp.bottom).offset(5)
            $0.height.equalTo(18)
        }
        
        performanceLocationLabel.snp.remakeConstraints {
            $0.leading.equalTo(performanceTimeLabel)
            $0.trailing.lessThanOrEqualTo(alarmButton.snp.leading)
            $0.top.equalTo(performanceTimeLabel.snp.bottom).offset(1)
            $0.bottom.equalToSuperview().inset(2)
            $0.height.equalTo(18)
        }
    }
    
    private func bind() {
        alarmButton.rx.tapGesture().when(.recognized)
            .subscribe(with: self) { owner, _ in
                owner.delegate?.didTappedAlarmButton(owner)
            }
            .disposed(by: disposeBag)
    }
}
