//
//  OnboardingViewHolder.swift
//  ShowPot
//
//  Created by Daegeon Choi on 7/4/24.
//

import UIKit

final class OnboardingViewHolder {
    
    let carouselLayout = UICollectionViewFlowLayout().then { carouselLayout in
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        carouselLayout.minimumLineSpacing = 0
        carouselLayout.itemSize = .init(width: UIScreen.main.bounds.width, height: 500)
    }
    
    lazy var carouselCollectionView = UICollectionView(frame: .zero, collectionViewLayout: carouselLayout).then { view in
        view.register(OnboardingCarouselCell.self)
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.bounces = false
        view.backgroundColor = .clear
    }
    
    lazy var pageControl = UIPageControl().then { pageControl in
        pageControl.pageIndicatorTintColor = .gray300
        pageControl.currentPageIndicatorTintColor = .gray000
        pageControl.currentPage = 0
    }
    
    lazy var bottomButton = SPButton().then { button in
        button.setText(Strings.onboardingButton, fontType: KRFont.H2)
        button.configuration?.baseForegroundColor = .gray000
        button.configuration?.baseBackgroundColor = .gray700
    }
    
}

extension OnboardingViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        [carouselCollectionView, pageControl, bottomButton].forEach { view.addSubview($0) }
    }
    
    func configureConstraints(for view: UIView) {
        
        carouselCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(55)
            make.leading.trailing.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(carouselCollectionView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(bottomButton.snp.top).offset(-56)
        }
        
        bottomButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
            make.height.equalTo(55)
        }
    }
    
}
