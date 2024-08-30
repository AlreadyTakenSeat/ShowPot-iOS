//
//  OnboardingViewController.swift
//  ShowPot
//
//  Created by Daegeon Choi on 7/4/24.
//

import UIKit
import RxSwift

final class OnboardingViewController: ViewController {
    
    let viewHolder: OnboardingViewHolder = .init()
    let viewModel: OnboardingViewModel
    
    // MARK: Property
    
    /// Carousel Cell에 들어갈 데이터
    private let carouselData: [OnboardingData]
    /// 현재 Carousel 페이지
    private var currentPage: Int = 0 {
        didSet {
            currentPageDidChange()
        }
    }
    
    // MARK: - Initializer
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.carouselData = viewModel.usecase.carouselData
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
