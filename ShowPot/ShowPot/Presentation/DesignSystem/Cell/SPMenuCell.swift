//
//  SPMenuCell.swift
//  ShowPot
//
//  Created by 김도형 on 4/1/25.
//

import UIKit

import SnapKit

final class SPMenuCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registration(title: String, style: Style) {
        titleLabel.text = title
        
        switch style {
        case .h1:
            titleLabel.font = KRFont.H1.font
            titleLabel.snp.updateConstraints { make in
                make.verticalEdges.equalToSuperview().inset(7)
            }
        case .h2:
            titleLabel.font = KRFont.H2.font
            titleLabel.snp.updateConstraints { make in
                make.verticalEdges.equalToSuperview().inset(9)
            }
        }
    }
}

// MARK: - Configure Views
private extension SPMenuCell {
    func configureUI() {
        contentView.backgroundColor = .gray700
        
        configureTitleLabel()
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(0)
        }
    }
    
    func configureTitleLabel() {
        titleLabel.textColor = .gray100
        contentView.addSubview(titleLabel)
    }
}

extension SPMenuCell {
    enum Style {
        case h1
        case h2
    }
}
