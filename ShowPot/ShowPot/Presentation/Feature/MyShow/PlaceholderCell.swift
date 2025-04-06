//
//  PlaceholderCell.swift
//  ShowPot
//
//  Created by 김도형 on 4/5/25.
//


import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PlaceholderCell: UICollectionViewCell {
    private let placeholderImageView = UIImageView()
    private let placeholderLabel = UILabel()
    private let exploreButton = SPCTAButton(title: "로그인 하러가기", style: .secondary)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        placeholderImageView.image = .myShowEmpty.resized(
            to: CGSize(width: 250, height: 250)
        )
        placeholderImageView.contentMode = .scaleAspectFill
        contentView.addSubview(placeholderImageView)
        
        placeholderLabel.attributedText = NSAttributedString(
            "알림 설정한\n공연이 없어요",
            fontType: KRFont.H0,
            multiline: true
        ).setForegroundColor(color: .gray400)
        placeholderLabel.textAlignment = .center
        placeholderLabel.numberOfLines = 0
        contentView.addSubview(placeholderLabel)
        
        contentView.addSubview(exploreButton)
    }
    
    private func configureLayout() {
        placeholderImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(250)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(placeholderImageView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        exploreButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
}
