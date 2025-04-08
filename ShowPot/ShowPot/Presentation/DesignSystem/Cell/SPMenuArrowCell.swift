//
//  SPMenuArrowCell.swift
//  ShowPot
//
//  Created by 김도형 on 4/1/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class SPMenuArrowCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let arrowImageView = UIImageView()
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func registration(title: String, style: Style) {
        titleLabel.text = title
        
        switch style {
        case .h1:
            titleLabel.font = KRFont.H1.font
            arrowImageView.snp.updateConstraints { make in
                make.verticalEdges.equalToSuperview().inset(4)
                make.size.equalTo(36)
            }
        case .h2:
            titleLabel.font = KRFont.H2.font
            arrowImageView.snp.updateConstraints { make in
                make.verticalEdges.equalToSuperview().inset(9)
                make.size.equalTo(24)
            }
        }
    }
}

// MARK: - Configure Views
private extension SPMenuArrowCell {
    func configureUI() {
        contentView.backgroundColor = .gray700
        
        configureTitleLabel()
        
        configureArrowImageView()
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(arrowImageView.snp.leading)
            make.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(0)
            make.trailing.equalToSuperview()
            make.size.equalTo(0)
        }
    }
    
    func configureTitleLabel() {
        titleLabel.textColor = .gray100
        contentView.addSubview(titleLabel)
    }
    
    func configureArrowImageView() {
        arrowImageView.image = .icArrowRight
            .withTintColor(.gray100)
        arrowImageView.contentMode = .scaleAspectFit
        contentView.addSubview(arrowImageView)
    }
}

extension SPMenuArrowCell {
    enum Style {
        case h1
        case h2
    }
}

@available(iOS 17.0, *)
#Preview {
    let cell = SPMenuArrowCell()
    cell.registration(title: "장르 구독하기", style: .h1)
    cell.snp.makeConstraints { make in
        make.height.equalTo(44)
    }
    
    return cell
}
