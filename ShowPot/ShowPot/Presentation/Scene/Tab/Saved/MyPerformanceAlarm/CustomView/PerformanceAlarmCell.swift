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
final class PerformanceAlarmCell: UICollectionViewCell, ReusableCell {
    private var disposeBag = DisposeBag()
    weak var delegate: PerformanceAlarmCellDelegate?
    
    private let performanceImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    
    private let performanceTitleLabel = SPLabel(ENFont.H2).then {
        $0.textColor = .gray000
    }
    
    private let performanceTimeLabel = SPLabel(KRFont.B3_regular).then {
        $0.textColor = .gray200
    }
    
    private let performanceLocationLabel = SPLabel(KRFont.B3_regular).then {
        $0.textColor = .gray200
    }
    
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
        performanceImageView.image = nil
        performanceTitleLabel.text = nil
        performanceTimeLabel.text = nil
        performanceLocationLabel.text = nil
        disposeBag = DisposeBag()
    }
    
    private func setupLayouts() {
        [performanceImageView, performanceTitleLabel, performanceTimeLabel, performanceLocationLabel, alarmButton].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        performanceImageView.snp.makeConstraints {
            $0.leading.directionalVerticalEdges.equalToSuperview()
            $0.size.equalTo(80)
        }
        
        performanceTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(3)
            $0.leading.equalTo(performanceImageView.snp.trailing).offset(14)
            $0.trailing.lessThanOrEqualToSuperview()
            $0.height.equalTo(33)
        }
        
        alarmButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(3)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(34)
            $0.width.equalTo(58)
        }
        
        performanceTimeLabel.snp.makeConstraints {
            $0.leading.equalTo(performanceTitleLabel)
            $0.trailing.lessThanOrEqualTo(alarmButton.snp.leading)
            $0.top.equalTo(performanceTitleLabel.snp.bottom).offset(5)
            $0.height.equalTo(18)
        }
        
        performanceLocationLabel.snp.makeConstraints {
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

extension PerformanceAlarmCell {
    func configureUI(with model: PerformanceInfoCollectionViewCellModel) {
        self.configureUI(
            performanceImageURL: model.performanceImageURL,
            performanceTitle: model.performanceTitle,
            performanceTime: model.performanceTime,
            performanceLocation: model.performanceLocation
        )
    }
    
    func configureUI(
        performanceImageURL: URL?,
        performanceTitle: String,
        performanceTime: Date?,
        performanceLocation: String
    ) {
        let formattedTime: String
        if let time = performanceTime {
            formattedTime = DateFormatterFactory.dateWithDot.string(from: time)
        } else {
            LogHelper.error("서버에서 내려준 포맷과 일치하지않습니다, 확인해주세요.")
            formattedTime = ""
        }
        
        performanceImageView.kf.setImage(with: performanceImageURL)
        performanceTitleLabel.setText(performanceTitle)
        performanceTimeLabel.setText(formattedTime)
        performanceLocationLabel.setText(performanceLocation)
    }
}
