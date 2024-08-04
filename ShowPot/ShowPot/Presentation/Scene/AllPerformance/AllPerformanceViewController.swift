//
//  AllPerformanceViewController.swift
//  ShowPot
//
//  Created by 이건준 on 8/2/24.
//

import UIKit

import RxSwift

final class AllPerformanceViewController: ViewController {
    
    private let didTappedCheckBoxButtonSubject = PublishSubject<Bool>()
    
    let viewHolder: AllPerformanceViewHolder = .init()
    let viewModel: AllPerformanceViewModel
    
    init(viewModel: AllPerformanceViewModel) {
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
        navigationController?.setNavigationBarHidden(true, animated: false)
        viewHolder.performanceListView.delegate = self
    }
    
    override func bind() {
        
        viewModel.dataSource = makeDataSource()
        
        let input = AllPerformanceViewModel.Input(
            initializePerformance: .just(()),
            didTappedCheckBoxButton: didTappedCheckBoxButtonSubject.asObservable(),
            didTappedPerformance: viewHolder.performanceListView.rx.itemSelected.asObservable(),
            didTappedBackButton: viewHolder.navigationView.didTappedBackButton,
            didTappedSearchButton: viewHolder.navigationView.didTappedSearchButton
        )
        
        viewModel.transform(input: input)
    }
}

extension AllPerformanceViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width - 32, height: 106)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: collectionView.frame.width - 32, height: 40)
    }
}

extension AllPerformanceViewController {
    func makeDataSource() -> AllPerformanceViewModel.DataSource {
        let cellRegistration = UICollectionView.CellRegistration<FeaturedPerformanceWithTicketOnSaleSoonCell, FeaturedPerformanceWithTicketOnSaleSoonCellModel> { (cell, indexPath, model) in
            cell.configureUI(with: model)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<PerformanceFilterHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] supplementaryView, _, _ in
            guard let self = self else { return }
            supplementaryView.didTappedCheckBox
                .bind(to: self.didTappedCheckBoxButtonSubject)
                .disposed(by: disposeBag)
        }
        
        let dataSource = UICollectionViewDiffableDataSource<AllPerformanceViewModel.PerformanceSection, FeaturedPerformanceWithTicketOnSaleSoonCellModel>(collectionView: viewHolder.performanceListView) { (collectionView, indexPath, model) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: model)
        }
        
        dataSource.supplementaryViewProvider = .init { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        return dataSource
    }
}
