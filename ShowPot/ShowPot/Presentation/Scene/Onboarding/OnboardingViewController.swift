//
//  OnboardingViewController.swift
//  ShowPot
//
//  Created by Daegeon Choi on 7/4/24.
//

import UIKit
import RxSwift

final class OnboardingViewController: ViewController {
    
    /// 온보딩 페이지별 표출될 컨텐츠 관리에 사용할 구조체
    private struct OnboardingData {
        let image: UIImage
        let title: String
        let description: String
        let backgroundColor: UIColor
    }
    
    let viewHolder: OnboardingViewHolder = .init()
    let viewModel: OnboardingViewModel
    
    // MARK: Property
    
    /// 현재 Carousel 페이지
    private var currentPage: Int = 0 {
        didSet {
            currentPageDidChange()
        }
    }
    
    /// Carousel Cell에 들어갈 데이터
    private let carouselData: [OnboardingData] = [
        OnboardingData(
            image: .onboarding1,
            title: Strings.onboardingTitle1, description: Strings.onboardingDescription1,
            backgroundColor: .mainOrange
        ),
        OnboardingData(
            image: .onboarding2, 
            title: Strings.onboardingTitle2, description: Strings.onboardingDescription2,
            backgroundColor: .mainGreen
        )
    ]
    
    // MARK: - Initializer
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolderConfigure()
        
        viewHolder.pageControl.numberOfPages = carouselData.count
        viewHolder.carouselCollectionView.delegate = self
        viewHolder.carouselCollectionView.dataSource = self
    }
    
    override func setupStyles() {
        super.setupStyles()
        self.view.backgroundColor = carouselData[0].backgroundColor
    }
    
    override func bind() {
        let input = OnboardingViewModel.Input(
            didTapBottomButton: viewHolder.bottomButton.rx.tap.asObservable()
        )
        viewModel.transform(input: input)
    }
}

extension OnboardingViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(OnboardingCarouselCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        
        let data = carouselData[indexPath.row]
        cell.configure(image: data.image, title: data.title, description: data.description)
        
        return cell
    }
}

extension OnboardingViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        currentPage = getCurrentPage()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
    }
}

// MARK: - Helper
private extension OnboardingViewController {
    private func getCurrentPage() -> Int {
        
        let visibleRect = CGRect(origin: viewHolder.carouselCollectionView.contentOffset, size: viewHolder.carouselCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = viewHolder.carouselCollectionView.indexPathForItem(at: visiblePoint) {
            return visibleIndexPath.row
        }
        
        return currentPage
    }
    
    private func currentPageDidChange() {
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = self.carouselData[self.currentPage].backgroundColor
        }
        viewHolder.pageControl.currentPage = currentPage
    }
}
