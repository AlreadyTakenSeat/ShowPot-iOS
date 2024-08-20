//
//  InterestShowListViewController.swift
//  ShowPot
//
//  Created by 이건준 on 8/16/24.
//

import UIKit

import RxSwift
import RxCocoa

final class InterestShowListViewController: ViewController {
    let viewHolder: InterestShowListViewHolder = .init()
    let viewModel: InterestShowListViewModel
    
    private let didTappedDeleteButtonSubject = PublishSubject<IndexPath>()
    
    init(viewModel: InterestShowListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolderConfigure()
    }
    
    override func setupStyles() {
        super.setupStyles()
        setNavigationBarItem(
            title: Strings.interestShowNavigationTitle,
            leftIcon: .icArrowLeft.withTintColor(.gray000)
        )
        viewHolder.showListView.delegate = self
    }
    
    override func bind() {
        super.bind()
        viewModel.dataSource = makeDataSource()
        
        let input = InterestShowListViewModel.Input(
            viewDidLoad: .just(()),
            didTappedDeleteButton: didTappedDeleteButtonSubject.asObservable(),
            didTappedShowCell: viewHolder.showListView.rx.itemSelected.asObservable(), 
            didTappedBackButton: contentNavigationBar.didTapLeftButton.asObservable(), 
            didTappedEmptyButton: viewHolder.emptyView.footerButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.isEmpty
            .map { !$0 }
            .drive(viewHolder.emptyView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

extension InterestShowListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width - 32, height: 80)
    }
}

extension InterestShowListViewController {
    func makeDataSource() -> InterestShowListViewModel.DataSource {
        let cellRegistration = UICollectionView.CellRegistration<ShowDeleteCell, ShowSummary> { (cell, indexPath, model) in
            cell.configureUI(
                performanceImageURL: model.thumbnailURL,
                performanceTitle: model.title,
                performanceTime: model.time,
                performanceLocation: model.location
            )
            cell.delegate = self
        }
        
        let dataSource = UICollectionViewDiffableDataSource<InterestShowListViewModel.InterestShowSection, ShowSummary>(collectionView: viewHolder.showListView) { (collectionView, indexPath, model) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: model)
        }
        
        return dataSource
    }
}

extension InterestShowListViewController: ShowDeleteCellDelegate {
    func didTappedDeleteButton(_ cell: UICollectionViewCell) {
        guard let indexPath = viewHolder.showListView.indexPath(for: cell) else { return }
        didTappedDeleteButtonSubject.onNext(indexPath)
    }
}
