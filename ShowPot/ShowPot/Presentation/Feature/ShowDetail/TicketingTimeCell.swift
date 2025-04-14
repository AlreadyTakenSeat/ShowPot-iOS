//
//  TicketingTimeCell.swift
//  ShowPot
//
//  Created by 김도형 on 4/4/25.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class TicketingTimeCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        titleLabel.textColor = .gray300
        titleLabel.font = KRFont.B2_regular.font
        contentView.addSubview(titleLabel)
        
        timeLabel.textColor = .gray200
        timeLabel.font = KRFont.B1_regular.font
        contentView.addSubview(timeLabel)
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.centerY.equalTo(titleLabel)
            make.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    func configure(with ticketingTime: ShowDetailEntity.TicketingTime) {
        let title = ticketingTime.ticketingAPIType == .normal ? "일반예매 오픈" : "선예매 오픈"
        titleLabel.text = "\(title)"
        let date = ticketingTime.ticketingAt.toDate(.default) ?? .now
        
        timeLabel.text = "\(date.toString(.ticketTime))"
    }
}
