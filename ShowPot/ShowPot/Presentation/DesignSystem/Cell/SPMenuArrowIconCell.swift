//
//  SPMenuArrowIconCell.swift
//  ShowPot
//
//  Created by 김도형 on 4/1/25.
//

import UIKit

import SnapKit

final class SPMenuArrowIconCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    private let iconImageView = UIImageView()
    private let arrowImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registration(
        title: String,
        count: Int? = nil,
        icon: UIImage?,
        style: Style = .h1
    ) {
        titleLabel.text = title
        
        switch style {
        case .h1:
            titleLabel.font = KRFont.H1.font
            iconImageView.image = icon?
                .withTintColor(.gray300)
            arrowImageView.image = .icArrowRight
                .withTintColor(.gray300)
        case .h2:
            titleLabel.font = KRFont.H2.font
            iconImageView.image = icon?
                .withTintColor(.gray400)
            arrowImageView.image = .icArrowRight
                .withTintColor(.gray100)
        }
        
        guard let count else { return }
        countLabel.text = "\(count)"
    }
}

// MARK: - Configure Views
private extension SPMenuArrowIconCell {
    func configureUI() {
        contentView.backgroundColor = .gray700
        
        configureTitleLabel()
        
        configureIconImageView()
        
        configureCountLabel()
        
        configureArrowImageView()
    }
    
    func configureLayout() {
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualTo(countLabel.snp.leading)
            make.verticalEdges.equalToSuperview().inset(7)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(arrowImageView.snp.leading)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
    }
    
    func configureTitleLabel() {
        titleLabel.textColor = .gray100
        titleLabel.font = KRFont.H1.font
        contentView.addSubview(titleLabel)
    }
    
    func configureIconImageView() {
        iconImageView.contentMode = .scaleAspectFit
        contentView.addSubview(iconImageView)
    }
    
    func configureCountLabel() {
        countLabel.font = KRFont.B1_semibold.font
        countLabel.textColor = .gray100
        contentView.addSubview(countLabel)
    }
    
    func configureArrowImageView() {
        arrowImageView.image = .icArrowRight
            .withTintColor(.gray300)
        arrowImageView.contentMode = .scaleAspectFit
        contentView.addSubview(arrowImageView)
    }
}

extension SPMenuArrowIconCell {
    enum Style {
        case h1
        case h2
    }
}


@available(iOS 17.0, *)
#Preview {
    let cell = SPMenuArrowIconCell()
    cell.registration(title: "장르 구독하기", count: 3, icon: .icAlarm)
    cell.snp.makeConstraints { make in
        make.height.equalTo(44)
    }
    
    return cell
}
