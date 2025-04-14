//
//  ShowInfoCell.swift
//  ShowPot
//
//  Created by 김도형 on 4/4/25.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ShowInfoCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let dateTitleLabel = UILabel()
    private let dateLabel = UILabel()
    private let venueTitleLabel = UILabel()
    private let venueLabel = UILabel()
    private let divider = SPDivider(style: .short)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        titleLabel.textColor = .gray100
        titleLabel.font = ENFont.H0.font
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(divider)
        
        dateTitleLabel.attributedText = NSAttributedString(
            "기간",
            fontType: KRFont.B1_regular
        )
        .setForegroundColor(color: .gray300)
        contentView.addSubview(dateTitleLabel)
        
        dateLabel.textColor = .gray200
        dateLabel.font = KRFont.B1_regular.font
        contentView.addSubview(dateLabel)
        
        venueTitleLabel.attributedText = NSAttributedString(
            "장소",
            fontType: KRFont.B1_regular
        )
        .setForegroundColor(color: .gray300)
        contentView.addSubview(venueLabel)
        
        venueLabel.textColor = .gray200
        venueLabel.font = KRFont.B1_regular.font
        contentView.addSubview(venueTitleLabel)
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
        }
        
        dateTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(12)
            make.leading.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateTitleLabel)
            make.leading.equalTo(dateTitleLabel.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        venueTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        venueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(venueTitleLabel)
            make.leading.equalTo(venueTitleLabel.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    func configure(with show: ShowDetailEntity) {
        titleLabel.text = show.name
        let date = show.startDate.toDate(.default) ?? .now
        dateLabel.text = date.toString(.showDetail)
        venueLabel.text = show.location
    }
}
