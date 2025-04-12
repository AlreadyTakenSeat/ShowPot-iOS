//
//  AlarmCell.swift
//  ShowPot
//
//  Created by 김도형 on 4/5/25.
//


import UIKit
import SnapKit
import RxCompose
import RxSwift
import RxCocoa

final class AlarmCell: UICollectionViewCell {
    private let checkBox = SPCheckBox()
    private let titleLabel = UILabel()
    private let disableLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.backgroundColor = .gray500
        contentView.layer.cornerRadius = 2
        contentView.clipsToBounds = true
        
        checkBox.isUserInteractionEnabled = false // 셀 자체에서 상호작용 처리
        
        disableLabel.attributedText = NSAttributedString(
            "해당 시간 선택은 불가능해요",
            fontType: KRFont.B3_semibold
        )
        .setForegroundColor(color: .mainOrange)
        disableLabel.isHidden = true
    }
    
    private func configureLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkBox)
        contentView.addSubview(disableLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.verticalEdges.equalToSuperview().inset(14)
            make.trailing.equalTo(checkBox.snp.leading).inset(8)
        }
        
        checkBox.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(24)
        }
        
        disableLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with time: ReservationTimeEntity) {
        titleLabel.attributedText = NSAttributedString(
            "티켓팅 \(time.beforeMinutes)분 전",
            fontType: KRFont.H2
        )
        .setForegroundColor(color: !time.canReserve ? .gray400 : .gray000)
        
        isUserInteractionEnabled = time.canReserve
        disableLabel.isHidden = time.canReserve
        
        checkBox.isHidden = !time.canReserve
        
        guard time.canReserve else { return }
        
        checkBox.isSelected = time.isReserved
        
        let borderColor = time.isReserved
        ? UIColor.mainOrange.cgColor
        : UIColor.clear.cgColor
        let borderWidth: CGFloat = time.isReserved ? 1 : 0
        
        self.contentView.layer.borderColor = borderColor
        self.contentView.layer.borderWidth = borderWidth
    }
}
