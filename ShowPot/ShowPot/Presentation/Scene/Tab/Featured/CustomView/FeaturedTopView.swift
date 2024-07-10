//
//  FeaturedTopView.swift
//  ShowPot
//
//  Created by 이건준 on 7/13/24.
//

import UIKit

import SnapKit
import Then

final class FeaturedTopView: UIView {
    
    /// 위로 스크롤했는지에 대한 상태값
    var isScrollUp: Bool = true {
        didSet {
//            setLayoutIfNeeded()
        }
    }

    private let containerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 18
        $0.alignment = .leading
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 13, left: 16, bottom: 14, right: 16)
    }
    
    private let featuredLogoImageView = UIImageView().then {
        $0.image = .showpotLogo // TODO: #44 애셋 네이밍 변경 이후 작업 필요
        $0.contentMode = .scaleAspectFit
    }
    
    private let featuredSearchButton = FeaturedSearchButton()
    
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
        addSubview(containerStackView)
        [featuredLogoImageView, featuredSearchButton].forEach { containerStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        
        containerStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        featuredLogoImageView.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        featuredSearchButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
    }
}

extension FeaturedTopView {
    private func setLayoutIfNeeded() {
        print("위로 스크롤됐니 \(isScrollUp)")
        if isScrollUp {
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                self?.featuredSearchButton.alpha = 0
//                self?.featuredSearchButton.transform = CGAffineTransform.identity
            }, completion: { [weak self] _ in
                self?.featuredSearchButton.snp.updateConstraints({
                    $0.height.equalTo(52)
                })
            })
        } else {
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                self?.featuredSearchButton.alpha = 1
//                self?.featuredSearchButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }, completion: { [weak self] _ in
                self?.featuredSearchButton.snp.updateConstraints({
                    $0.height.equalTo(0)
                })
            })
        }
    }
}
