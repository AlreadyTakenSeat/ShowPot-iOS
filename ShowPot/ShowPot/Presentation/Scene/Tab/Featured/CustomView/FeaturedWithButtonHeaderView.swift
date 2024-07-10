//
//  FeaturedWithButtonHeaderView.swift
//  ShowPot
//
//  Created by 이건준 on 7/11/24.
//

import UIKit

import SnapKit
import Then

struct FeaturedWithButtonHeaderViewModel {
    let featureHeaderTitle: String
}

final class FeaturedWithButtonHeaderView: UICollectionReusableView {
    
    static let identifier = String(describing: FeaturedWithButtonHeaderView.self) // TODO: #46 identifier 지정코드로 변환
    
    private let featuredHeaderTitleLabel = UILabel().then {
        $0.font = KRFont.H1 // TODO: #37 lineHeight + letterSpacing 적용
        $0.textColor = .gray100
        $0.textAlignment = .left
        $0.text = "장르 구독하기"
    }
    
    private let featuredHeaderButton = UIButton().then {
        $0.setImage(.icArrow36Right.withTintColor(.gray200), for: .normal) // TODO: #44 애셋 네이밍 변경 이후 작업 필요
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        [featuredHeaderTitleLabel, featuredHeaderButton].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        
        featuredHeaderButton.snp.makeConstraints {
            $0.size.equalTo(36)
            $0.trailing.directionalVerticalEdges.equalToSuperview()
        }
        
        featuredHeaderTitleLabel.snp.makeConstraints {
            $0.trailing.equalTo(featuredHeaderButton)
            $0.leading.directionalVerticalEdges.equalToSuperview()
        }
    }
    
}

// MARK: Data Configuration

extension FeaturedWithButtonHeaderView {
    func configureUI(with model: FeaturedWithButtonHeaderViewModel) {
        featuredHeaderTitleLabel.text = model.featureHeaderTitle
    }
}
