//
//  ClosedShowListViewController.swift
//  ShowPot
//
//  Created by 이건준 on 8/17/24.
//

import UIKit

import RxSwift
import RxGesture

final class ClosedShowListViewController: ViewController {
    let viewHolder: ClosedShowListViewHolder = .init()
    let viewModel: ClosedShowListViewModel
    
    init(viewModel: ClosedShowListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchClosedShowList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolderConfigure()
    }
    
    override func setupStyles() {
        super.setupStyles()
        setNavigationBarItem(
            title: Strings.closedShowNavigationTitle,
            leftIcon: .icArrowLeft.withTintColor(.gray000)
        )
        viewHolder.showListView.delegate = self
    }
    
    override func bind() {
        
        let input = ClosedShowListViewModel.Input(
            didTappedBackButton: contentNavigationBar.didTapLeftButton,
            didTappedShowCell: viewHolder.showListView.rx.itemSelected.asObservable(), 
            didTappedEmptyButton: viewHolder.emptyView.footerButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.showList
            .drive(viewHolder.showListView.rx.items(
                cellIdentifier: PerformanceInfoCollectionViewCell.reuseIdentifier,
                cellType: PerformanceInfoCollectionViewCell.self)
            ) { index, item, cell in
                cell.configureUI(
                    performanceImageURL: item.thumbnailURL,
                    performanceTitle: item.title,
                    performanceTime: item.time,
                    performanceLocation: item.location
                )
            }
            .disposed(by: disposeBag)
        
        output.isEmpty
            .map { !$0 }
            .drive(viewHolder.emptyView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

extension ClosedShowListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width - 32, height: 80)
    }
}
