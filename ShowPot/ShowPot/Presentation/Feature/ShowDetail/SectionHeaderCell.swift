//
//  SectionHeaderCell.swift
//  ShowPot
//
//  Created by 김도형 on 4/4/25.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SectionHeaderCell: UICollectionReusableView {
    private let titleLabel = UILabel()
    private let dividerView = SPDivider(style: .short)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(titleLabel)
        
        addSubview(dividerView)
    }
    
    private func configureLayout() {
        dividerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(with title: String) {
        let nsStr = NSAttributedString(title, fontType: KRFont.H2)
            .setForegroundColor(color: .gray000)
        titleLabel.attributedText = nsStr
    }
}
