//
//  OnboardingCarouselCell.swift
//  ShowPot
//
//  Created by Daegeon Choi on 7/6/24.
//

import UIKit
import SnapKit

final class OnboardingCarouselCell: UICollectionViewCell, ReusableCell {
    
    // MARK: - UI Component
    private lazy var imageView = UIImageView().then { imageView in
        imageView.contentMode = .scaleAspectFit
    }
    
    private lazy var titleLabel = SPLabel(KRFont.H0, alignment: .center).then { label in
        label.textColor = .gray800
    }
    
    private lazy var descriptionLabel = SPLabel(KRFont.H2, alignment: .center).then { label in
        label.textColor = .gray800
        label.numberOfLines = 0
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpLayout()
    }
}

// MARK: UI Configuration
extension OnboardingCarouselCell {
    
    private func setUpLayout() {
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.lessThanOrEqualTo(333)
        }
        
        let labelStack = UIStackView().then { stackView in
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = 8
        }
        
        self.addSubview(labelStack)
        labelStack.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(46)
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        [titleLabel, descriptionLabel].forEach { label in
            labelStack.addArrangedSubview(label)
        }
    }
}

// MARK: Data Configuration
extension OnboardingCarouselCell {
    
    public func configure(image: UIImage? = nil, title: String, description: String) {
        self.imageView.image = image
        self.titleLabel.setText(title)
        self.descriptionLabel.setText(description)
    }
}
