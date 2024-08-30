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
    private let didTappedRemoveKeywordButtonSubject = PublishSubject<String>()
    private let tapGesture = UITapGestureRecognizer(target: FeaturedSearchViewController.self, action: nil).then {
        $0.numberOfTapsRequired = 1
        $0.cancelsTouchesInView = false
    }
    
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
        view.addGestureRecognizer(tapGesture)
        viewHolder.recentSearchCollectionView.delegate = self
        viewHolder.searchKeywordResultCollectionView.delegate = self
        
        viewModel.recentSearchKeywordDataSource = makeRecentSearchKeywordDataSource()
        viewModel.searchKeywordResultDataSource = makeSearchKeywordResultDataSource()
    }
    
    override func bind() {
        
        let itemSelected = viewHolder.recentSearchCollectionView.rx.itemSelected.asObservable().share()
        itemSelected.subscribe(with: self) { owner, indexPath in
            guard let model = owner.viewModel.recentSearchKeywordDataSource?.snapshot().itemIdentifiers[indexPath.row] else { return }
            owner.viewHolder.featuredSearchTextField.resignFirstResponder()
            owner.viewHolder.featuredSearchTextField.text = model
        }
        .disposed(by: disposeBag)
        
        let input = FeaturedSearchViewModel.Input(
            viewDidLoad: .just(()),
            didTappedBackButton: viewHolder.backButton.rx.tap.asObservable(),
            didTappedRemoveAllButton: didTappedRemoveAllButtonSubject.asObservable(),
            didTappedRecentSearchKeyword: itemSelected,
            didTappedRemoveKeywordButton: didTappedRemoveKeywordButtonSubject.asObservable(),
            didTappedReturnKey: viewHolder.featuredSearchTextField.didTappedReturnKey,
            searchKeyword: viewHolder.featuredSearchTextField.rx.text.orEmpty.asObservable(),
            didTappedSearchFieldRemoveAllButton: viewHolder.featuredSearchTextField.didTappedRemoveAllButton,
            didTappedSearchResultCell: viewHolder.searchKeywordResultCollectionView.rx.itemSelected.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.isRecentSearchKeywordEmpty
            .map { !$0 }
            .drive(viewHolder.emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.showSearchResult
            .map { !$0 }
            .drive(viewHolder.searchKeywordResultCollectionView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(viewHolder.indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.addSubscriptionResult
            .subscribe(with: self) { owner, isSuccess in
                owner.showAddSubscribtionSnackbar(isSuccess: isSuccess)
            }.disposed(by: disposeBag)
        
        output.deleteSubscriptionResult
            .subscribe(with: self) { owner, isSuccess in
                owner.showDeleteSubscribtionSnackbar(isSuccess: isSuccess)
            }.disposed(by: disposeBag)
        
        Observable.merge(
            viewHolder.searchKeywordResultCollectionView.rx.didScroll.map { _ in () },
            viewHolder.recentSearchCollectionView.rx.didScroll.map { _ in () },
            tapGesture.rx.event.map { _ in () }
        )
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
            guard let string = viewModel.recentSearchKeywordDataSource?.snapshot().itemIdentifiers[indexPath.row] else { return .zero }
            let label = SPLabel(KRFont.B1_regular).then {
                $0.setText(string)
                $0.sizeToFit()
            }
            let size = label.frame.size
            let maxWidth = UIScreen.main.bounds.width - 32
            let additionalWidth: CGFloat = 24 + 14 + 8
            let width = min(maxWidth, additionalWidth + size.width)
            return CGSize(width: width, height: 40)
        } else if collectionView == viewHolder.searchKeywordResultCollectionView {
            guard let type = viewModel.searchKeywordResultDataSource?.snapshot().sectionIdentifiers[indexPath.section] else { return .zero }
            switch type {
            case .artist:
                return CGSize(width: 100, height: 129)
            case .performance:
                return CGSize(width: collectionView.frame.width - 32, height: 80)
            }
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == viewHolder.recentSearchCollectionView {
            return .init(width: collectionView.frame.width, height: 44)
        } else if collectionView == viewHolder.searchKeywordResultCollectionView {
            return .init(width: collectionView.frame.width - 32, height: 44)
        }
        return .zero
    }
}

extension FeaturedSearchViewController {
    private func showAddSubscribtionSnackbar(isSuccess: Bool) {
        SPSnackBar(contextView: self.view, type: .subscribe)
            .show()
    }
    
    private func showDeleteSubscribtionSnackbar(isSuccess: Bool) {
        let style = SnackBarStyle(
            icon: .icCheck.withTintColor(.gray200),
            message: Strings.snackbarDescriptionSubscribeDelete,
            actionTitle: ""
        )
        SnackBar(contextView: self.view, style: style, duration: .short)
            .show()
    }
}

// MARK: - Helper For NSDiffableDataSource

extension FeaturedSearchViewController {
    func makeRecentSearchKeywordDataSource() -> FeaturedSearchViewModel.RecentSearchKeywordDataSource {
        let cellRegistration = UICollectionView.CellRegistration<FeaturedRecentSearchCell, String> { [weak self] (cell, indexPath, searchKeyword) in
            guard let self else { return }
            cell.configureUI(with: searchKeyword)
            cell.didTappedRemoveKeywordButton
                .take(1)
                .subscribe(with: self) { owner, _ in
                    owner.didTappedRemoveKeywordButtonSubject.onNext(searchKeyword)
                }
                .disposed(by: disposeBag)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<FeaturedRecentSearchHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] supplementaryView, _, _ in
            guard let self = self else { return }
            supplementaryView.didTappedRemoveAllButton
                .bind(to: self.didTappedRemoveAllButtonSubject)
                .disposed(by: disposeBag)
        }
        
        let dataSource = UICollectionViewDiffableDataSource<FeaturedSearchViewModel.RecentSearchSection, String>(collectionView: viewHolder.recentSearchCollectionView) { (collectionView, indexPath, searchKeyword) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: searchKeyword)
        }
        
        dataSource.supplementaryViewProvider = .init { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        return dataSource
    }
    
    func makeSearchKeywordResultDataSource() -> FeaturedSearchViewModel.SearchKeywordResultDataSource {
        
        let artistCellRegistration = UICollectionView.CellRegistration<FeaturedSubscribeArtistCell, FeaturedSubscribeArtistCellModel> { (cell, indexPath, model) in
            cell.configureUI(with: model)
        }
        
        let performanceCellRegistration = UICollectionView.CellRegistration<PerformanceInfoCollectionViewCell, PerformanceInfoCollectionViewCellModel> { (cell, indexPath, model) in
            cell.configureUI(with: model)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<FeaturedOnlyTitleHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] supplementaryView, _, indexPath in
            guard let self = self,
                  let headerTitle = self.viewModel.searchKeywordResultDataSource?.snapshot().sectionIdentifiers[indexPath.section].headerTitle else { return }
            supplementaryView.configureUI(with: headerTitle)
        }
        
        let dataSource = UICollectionViewDiffableDataSource<FeaturedSearchViewModel.SearchResultSection, AnyHashable>(collectionView: viewHolder.searchKeywordResultCollectionView) { [weak self] (collectionView, indexPath, model) -> UICollectionViewCell? in
            guard let self = self,
                  let type = self.viewModel.searchKeywordResultDataSource?.snapshot().sectionIdentifiers[indexPath.section] else { return nil }
            switch type {
            case .artist:
                guard let model = model as? FeaturedSubscribeArtistCellModel else { return nil }
                return collectionView.dequeueConfiguredReusableCell(using: artistCellRegistration, for: indexPath, item: model)
            case .performance:
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
