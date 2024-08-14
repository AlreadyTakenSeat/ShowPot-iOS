//
//  SavedViewController.swift
//  ShowPot
//
//  Created by Daegeon Choi on 5/25/24.
//

import UIKit

import RxSwift

final class SavedViewController: ViewController {
    let viewHolder: SavedViewHolder = .init()
    let viewModel: SavedViewModel
    
    private let visiblePerformanceSubject = PublishSubject<IndexPath>()
    
    init(viewModel: SavedViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        viewHolder.upcomingCarouselView.deviceRotated()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolderConfigure()
    }
    
    override func setupStyles() {
        super.setupStyles()
        viewHolder.menuCollectionView.delegate = self
        viewHolder.upcomingCarouselView.delegate = self
    }
    
    override func bind() {
        
        let input = SavedViewModel.Input(
            viewDidLoad: .just(()),
            didTappedMenu: viewHolder.menuCollectionView.rx.itemSelected.asObservable(), 
            didEndScrolling: visiblePerformanceSubject.asObservable(),
            didTappedLoginButton: viewHolder.emptyView.footerButton.rx.tap.asObservable(),
            didTappedUpcomingCell: viewHolder.upcomingCarouselView.rx.itemSelected.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.upcomingTicketingModel
            .drive(viewHolder.upcomingCarouselView.rx.items(cellIdentifier: MyUpcomingTicketingCell.reuseIdentifier, cellType: MyUpcomingTicketingCell.self)) { index, model, cell in
                cell.configureUI(
                    backgroundImage: model.backgroundImage,
                    showThubnailURL: model.showThubnailURL,
                    showName: model.showName,
                    showLocation: model.showLocation,
                    showStartTime: model.showStartTime,
                    showEndTime: model.showEndTime,
                    ticketingOpenTime: model.ticketingOpenTime
                )
            }
            .disposed(by: disposeBag)
        
        output.alarmMenuModel
            .drive(viewHolder.menuCollectionView.rx.items(cellIdentifier: MyAlarmMenuCell.reuseIdentifier, cellType: MyAlarmMenuCell.self)) { index, model, cell in
                cell.configureUI(with: .init(
                    type: model.type,
                    menuImage: model.type.menuImage,
                    menuTitle: model.type.menuTitle,
                    badgeCount: "\(model.badgeCount)"
                ))
            }
            .disposed(by: disposeBag)
        
        output.currentHeaderModel
            .drive(with: self) { owner, headerModel in
                guard let remainDay = headerModel.remainDay else { return }
                owner.viewHolder.ticketingHeaderView.configureUI(
                    artistName: headerModel.artistName,
                    upcomingTime: "공연 티켓팅까지, D-\(remainDay)"
                )
            }
            .disposed(by: disposeBag)
        
        output.upcomingIsEmpty
            .drive(with: self) { owner, result in
                let (isEmpty, isLoggedIn) = result
                owner.viewHolder.emptyView.isHidden = !isEmpty
                owner.viewHolder.emptyView.configureUI(isLoggedIn: isLoggedIn)
            }
            .disposed(by: disposeBag)
    }
}

extension SavedViewController: UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == viewHolder.menuCollectionView {
            return .init(width: collectionView.frame.width, height: 44)
        } else if collectionView == viewHolder.upcomingCarouselView {
            return .init(width: collectionView.frame.width - 66 * 2, height: 357)
        }
        return .zero
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: viewHolder.upcomingCarouselView.contentOffset, size: viewHolder.upcomingCarouselView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        if let indexPath = viewHolder.upcomingCarouselView.indexPathForItem(at: visiblePoint) {
            visiblePerformanceSubject.onNext(indexPath)
        }
    }
}
