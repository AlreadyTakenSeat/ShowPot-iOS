//
//  FeaturedSearchViewController.swift
//  ShowPot
//
//  Created by 이건준 on 7/22/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class FeaturedSearchViewController: ViewController {
    let viewHolder: FeaturedSearchViewHolder = .init()
    let viewModel: FeaturedSearchViewModel
        
    private let didTappedRemoveAllButtonSubject = PublishSubject<Void>()
    private let didTappedRecentSearchQueryXbuttonSubject = PublishSubject<String>()
    
    init(viewModel: FeaturedSearchViewModel) {
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
        view.backgroundColor = .gray700
        viewHolder.recentSearchCollectionView.delegate = self
        viewHolder.searchQueryResultCollectionView.delegate = self
        
        viewModel.recentSearchQueryDataSource = makeRecentSearchQueryDataSource()
        viewModel.searchQueryResultDataSource = makeSearchQueryResultDataSource()
    }
    
    override func bind() {
        
        let itemSelected = viewHolder.recentSearchCollectionView.rx.itemSelected.asObservable().share()
        itemSelected.subscribe(with: self) { owner, indexPath in
            guard let model = owner.viewModel.recentSearchQueryDataSource?.snapshot().itemIdentifiers[indexPath.row] else { return }
            owner.viewHolder.featuredSearchTextField.resignFirstResponder()
            owner.viewHolder.featuredSearchTextField.text = model
        }
        .disposed(by: disposeBag)
        
        let input = FeaturedSearchViewModel.Input(
            requestInitialSearchQueryData: .just(()),
            didTappedBackButton: viewHolder.backButton.rx.tap.asObservable(),
            didTappedRemoveAllButton: didTappedRemoveAllButtonSubject.asObservable(),
            didTappedRecentSearchQuery: itemSelected,
            didTappedRecentSearchQueryXButton: didTappedRecentSearchQueryXbuttonSubject.asObservable(),
            didTappedReturnKey: viewHolder.featuredSearchTextField.didTappedReturnButton,
            searchQueryTextField: viewHolder.featuredSearchTextField.rx.text.orEmpty,
            didTappedSearchTextFieldXButton: viewHolder.featuredSearchTextField.didTappedXButton,
            didTappedSearchResultCell: viewHolder.searchQueryResultCollectionView.rx.itemSelected.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.isRecentSearchQueryListEmpty
            .map { !$0 }
            .drive(viewHolder.emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isSearchResultEmpty
            .drive(viewHolder.searchQueryResultCollectionView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(viewHolder.indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewHolder.searchQueryResultCollectionView.rx.didScroll
            .subscribe(with: self) { owner, _ in
                let isFirstResponder = owner.viewHolder.featuredSearchTextField.isFirstResponder
                if isFirstResponder {
                    owner.viewHolder.featuredSearchTextField.resignFirstResponder()
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeaturedSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == viewHolder.recentSearchCollectionView {
            guard let string = viewModel.recentSearchQueryDataSource?.snapshot().itemIdentifiers[indexPath.row] else { return .zero }
            let label = UILabel().then {
                $0.font = KRFont.B1_regular
                $0.setAttributedText(font: KRFont.self, string: string)
                $0.sizeToFit()
            }
            let size = label.frame.size
            let maxWidth = UIScreen.main.bounds.width - 32
            let additionalWidth: CGFloat = 24 + 14 + 8
            let width = min(maxWidth, additionalWidth + size.width)
            return CGSize(width: width, height: 40)
        } else if collectionView == viewHolder.searchQueryResultCollectionView {
            guard let type = viewModel.searchQueryResultDataSource?.snapshot().sectionIdentifiers[indexPath.section] else { return .zero }
            switch type {
            case .artistList:
                return CGSize(width: 100, height: 129)
            case .performanceInfo:
                return CGSize(width: collectionView.frame.width - 32, height: 80)
            }
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == viewHolder.recentSearchCollectionView {
            return .init(width: collectionView.frame.width, height: 44)
        } else if collectionView == viewHolder.searchQueryResultCollectionView {
            return .init(width: collectionView.frame.width - 32, height: 44)
        }
        return .zero
    }
}

// MARK: - Helper For NSDiffableDataSource

extension FeaturedSearchViewController {
    func makeRecentSearchQueryDataSource() -> FeaturedSearchViewModel.RecentSearchQueryDataSource {
        let cellRegistration = UICollectionView.CellRegistration<FeaturedRecentSearchCell, String> { [weak self] (cell, indexPath, searchQuery) in
            guard let self else { return }
            cell.configureUI(with: .init(recentSearchQuery: searchQuery))
            cell.didTappedXButton
                .take(1)
                .subscribe(with: self) { owner, _ in
                    owner.didTappedRecentSearchQueryXbuttonSubject.onNext(searchQuery)
                }
                .disposed(by: disposeBag)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<FeaturedRecentSearchHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] supplementaryView, _, _ in
            guard let self = self else { return }
            supplementaryView.didTappedRemoveAllButton
                .bind(to: self.didTappedRemoveAllButtonSubject)
                .disposed(by: disposeBag)
        }
        
        let dataSource = UICollectionViewDiffableDataSource<FeaturedSearchViewModel.RecentSearchSection, String>(collectionView: viewHolder.recentSearchCollectionView) { (collectionView, indexPath, searchQuery) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: searchQuery)
        }
        
        dataSource.supplementaryViewProvider = .init { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        return dataSource
    }
    
    func makeSearchQueryResultDataSource() -> FeaturedSearchViewModel.SearchQueryResultDataSource {
        
        let artistCellRegistration = UICollectionView.CellRegistration<FeaturedSubscribeArtistCell, FeaturedSubscribeArtistCellModel> { (cell, indexPath, model) in
            cell.configureUI(with: model)
        }
        
        let performanceCellRegistration = UICollectionView.CellRegistration<PerformanceInfoCollectionViewCell, PerformanceInfoCollectionViewCellModel> { (cell, indexPath, model) in
            cell.configureUI(with: model)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<FeaturedOnlyTitleHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] supplementaryView, _, indexPath in
            guard let self = self,
                  let headerTitle = self.viewModel.searchQueryResultDataSource?.snapshot().sectionIdentifiers[indexPath.section].headerTitle else { return }
            supplementaryView.configureUI(with: headerTitle)
        }
        
        let dataSource = UICollectionViewDiffableDataSource<FeaturedSearchViewModel.SearchResultSection, AnyHashable>(collectionView: viewHolder.searchQueryResultCollectionView) { [weak self] (collectionView, indexPath, model) -> UICollectionViewCell? in
            guard let self = self,
                  let type = self.viewModel.searchQueryResultDataSource?.snapshot().sectionIdentifiers[indexPath.section] else { return nil }
            switch type {
            case .artistList:
                guard let model = model as? FeaturedSubscribeArtistCellModel else { return nil }
                return collectionView.dequeueConfiguredReusableCell(using: artistCellRegistration, for: indexPath, item: model)
            case .performanceInfo:
                guard let model = model as? PerformanceInfoCollectionViewCellModel else { return nil }
                return collectionView.dequeueConfiguredReusableCell(using: performanceCellRegistration, for: indexPath, item: model)
            }
        }
        
        dataSource.supplementaryViewProvider = .init { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        return dataSource
    }
}
