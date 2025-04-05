//
//  SeatPriceCell.swift
//  ShowPot
//
//  Created by 김도형 on 4/4/25.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SeatPriceCell: UICollectionViewCell {
    private let seatTypeLabel = UILabel()
    private let priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(seatTypeLabel)
        
        contentView.addSubview(priceLabel)
    }
    
    private func configureLayout() {
        seatTypeLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(seatTypeLabel)
            make.leading.equalTo(seatTypeLabel.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualToSuperview().inset(12)
        }
    }
    
    func configure(with seatPrice: ShowDetailEntity.Seat) {
        let seatTypeNSStr = NSAttributedString(
            seatPrice.seatType,
            fontType: KRFont.B1_regular
        )
        .setForegroundColor(color: .gray300)
        .setParagraphStyle(lineHeightMultiple: 1.5)
        seatTypeLabel.attributedText = seatTypeNSStr
        
        let priceNSStr = NSAttributedString(
            "\(seatPrice.price.formatted())원",
            fontType: KRFont.B1_regular
        )
        .setForegroundColor(color: .gray200)
        .setParagraphStyle(lineHeightMultiple: 1.5)
        priceLabel.attributedText = priceNSStr
    }
}
