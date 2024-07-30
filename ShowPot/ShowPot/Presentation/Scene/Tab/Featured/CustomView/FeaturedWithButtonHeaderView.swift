//
//  FeaturedWithButtonHeaderView.swift
//  ShowPot
//
//  Created by 이건준 on 7/11/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class FeaturedWithButtonHeaderView: UICollectionReusableView, ReusableCell {
    
    private let disposeBag = DisposeBag()
    static let identifier = String(describing: FeaturedWithButtonHeaderView.self) 
    
    var buttonTapped: ControlEvent<UITapGestureRecognizer> {
        tapGesture.rx.event
    }
    
    private let featuredHeaderTitleLabel = SPLabel(KRFont.H1).then {
        $0.textColor = .gray100
    }
    
    private let featuredHeaderImageView = UIImageView().then {
        $0.image = .icArrowRight.withTintColor(.gray200)
        $0.contentMode = .scaleAspectFit
    }
    
    private let tapGesture = UITapGestureRecognizer(target: FeaturedWithButtonHeaderView.self, action: nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyles()
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        backgroundColor = .gray700
    }
    
    private func setupLayouts() {
        addGestureRecognizer(tapGesture)
        [featuredHeaderTitleLabel, featuredHeaderImageView].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        
        featuredHeaderImageView.snp.makeConstraints {
            $0.size.equalTo(36)
            $0.directionalVerticalEdges.trailing.equalToSuperview()
        }
        
        featuredHeaderTitleLabel.snp.makeConstraints {
            $0.trailing.equalTo(featuredHeaderImageView)
            $0.leading.directionalVerticalEdges.equalToSuperview()
        }
    }
}

// MARK: Data Configuration

struct FeaturedWithButtonHeaderViewModel {
    let headerTitle: String
}

extension FeaturedWithButtonHeaderView {
    func configureUI(with model: FeaturedWithButtonHeaderViewModel) {
        featuredHeaderTitleLabel.setText(model.headerTitle)
    }
    
    func configureUI(headerTitle: String) {
        featuredHeaderTitleLabel.setText(headerTitle)
    }
}
