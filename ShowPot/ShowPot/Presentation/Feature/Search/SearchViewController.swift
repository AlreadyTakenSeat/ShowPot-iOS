//
//  SearchViewController.swift
//  ShowPot
//
//  Created by 김도형 on 4/2/25.
//

import UIKit

import SnapKit
import RxCompose
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController, Composable {
    // MARK: - Properties
    private lazy var recentSearchesCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createRecentSearchesLayout()
    )
    private lazy var searchResultsCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createSearchResultsLayout()
    )
    private let searchTextField = SPTextField(placeholder: "관심 있는 공연과 가수를 검색해보세요")
    private let clearAllButton = UIButton()
    private let backButton = UIButton()
    
    private var recentSearchesDataSource: RecentSearchesDataSource?
    private var searchResultsDataSource: SearchResultsDataSource?
    
    @Compose
    var composer: SearchViewModel
    var disposeBag = DisposeBag()
    
    init(viewModel: SearchViewModel) {
        self.composer = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
        
        configureDataSources()
        
        bindState()
        
        bindAction()
    }
}

// MARK: - Configure View
private extension SearchViewController {
    func configureUI() {
        view.backgroundColor = .gray700
        
        configureBackButton()
        
        configureSearchTextField()
        
        configureCollectionViews()
        
        configureClearAllButton()
    }
    
    func configureLayout() {
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalTo(searchTextField)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            make.leading.equalTo(backButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(52)
        }
        
        clearAllButton.snp.makeConstraints { make in
            make.top.equalTo(recentSearchesCollectionView).inset(12)
            make.trailing.equalTo(recentSearchesCollectionView).inset(16)
        }
        
        recentSearchesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchResultsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureBackButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .icArrowLeft
            .resized(to: CGSize(width: 36, height: 36))
            .withTintColor(.gray300)
        configuration.contentInsets = .zero
        backButton.configuration = configuration
        view.addSubview(backButton)
    }
    
    func configureSearchTextField() {
        view.addSubview(searchTextField)
    }
    
    func configureClearAllButton() {
        var configuration = UIButton.Configuration.plain()
        let nsStr = NSAttributedString(
            "모두 삭제",
            fontType: KRFont.B1_regular
        ).setForegroundColor(color: .gray400)
        configuration.attributedTitle = AttributedString(nsStr)
        configuration.background.backgroundColor = .clear
        configuration.contentInsets = .zero
        clearAllButton.configuration = configuration
        clearAllButton.isHidden = true
        view.addSubview(clearAllButton)
    }
    
    func configureCollectionViews() {
        recentSearchesCollectionView.backgroundColor = .clear
        recentSearchesCollectionView.isScrollEnabled = false
        view.addSubview(recentSearchesCollectionView)
        
        searchResultsCollectionView.backgroundColor = .clear
        searchResultsCollectionView.isScrollEnabled = true
        searchResultsCollectionView.isHidden = true
        view.addSubview(searchResultsCollectionView)
    }
    
    func createRecentSearchesLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(100),
                heightDimension: .absolute(40)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(40)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            group.interItemSpacing = .fixed(8)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 8,
                leading: 16,
                bottom: 16,
                trailing: 16
            )
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(44)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]
            
            return section
        }
    }
    
    func createSearchResultsLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            switch SearchResultsSection(rawValue: sectionIndex) {
            case .artists:
                return self?.configureArtistSection()
            case .shows:
                return self?.configureShowsSection()
            default: return nil
            }
        }
    }
    
    func configureArtistSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(100),
            heightDimension: .absolute(129)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 12
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(129)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 16,
            trailing: 16
        )
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func configureShowsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(80)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .fixed(0),
            top: .fixed(0),
            trailing: .fixed(0),
            bottom: .fixed(16) // contentInsets 대신 edgeSpacing 사용
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(80)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 16,
            trailing: 16
        )
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func updateCollectionView(showSearchResult: Bool) {
        UIView.fadeAnimate(duration: 0.2) { [weak self] in
            self?.searchResultsCollectionView.alpha = !showSearchResult ? 0 : 1
            self?.recentSearchesCollectionView.alpha = showSearchResult ? 0 : 1
//            self?.clearAllButton.alpha = showSearchResult ? 0 : 1
        } completion: { [weak self] _ in
            self?.searchResultsCollectionView.isHidden = !showSearchResult
            self?.recentSearchesCollectionView.isHidden = showSearchResult
//            self?.clearAllButton.isHidden = showSearchResult
        }
    }
}

// MARK: - DataSource and Snapshot
private extension SearchViewController {
    // 최근 검색어용 DataSource와 Snapshot
    typealias RecentSearchesDataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias RecentSearchesSnapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    // 검색 결과용 DataSource와 Snapshot
    typealias SearchResultsDataSource = UICollectionViewDiffableDataSource<SearchResultsSection, SearchResultsItem>
    typealias SearchResultsSnapshot = NSDiffableDataSourceSnapshot<SearchResultsSection, SearchResultsItem>
    
    enum SearchResultsSection: Int, CaseIterable {
        case artists
        case shows
    }
    
    enum SearchResultsItem: Hashable {
        case artist(ArtistEntity)
        case show(ShowEntity)
    }
    
    func configureDataSources() {
        // 최근 검색어 DataSource
        let recentSearchCellRegistration = UICollectionView.CellRegistration<SPChipCell, String> { [weak self] cell, indexPath, title in
            guard let `self` else { return }
            cell.configure(title: title)
            cell.chipButton.rx.tap
                .map { _ in Action.recentSearchesItemSelected(indexPath.item) }
                .bind(to: composer.action)
                .disposed(by: cell.disposeBag)
            
            cell.chipButton.cancelButton.rx.tap
                .map { _ in Action.recentSearchesCancelButtonTapped(indexPath.item) }
                .bind(to: composer.action)
                .disposed(by: cell.disposeBag)
        }
        
        let recentSearchesHeaderRegistration = UICollectionView.SupplementaryRegistration<SPMenuCell>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { headerView, _, _ in
            headerView.registration(title: "", style: .h2)
        }
        
        recentSearchesDataSource = RecentSearchesDataSource(
            collectionView: recentSearchesCollectionView
        ) { collectionView, indexPath, title in
            return collectionView.dequeueConfiguredReusableCell(
                using: recentSearchCellRegistration,
                for: indexPath,
                item: title
            )
        }
        
        recentSearchesDataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: recentSearchesHeaderRegistration,
                for: indexPath
            )
        }
        
        // 검색 결과 DataSource
        let artistCellRegistration = UICollectionView.CellRegistration<ArtistCell, ArtistEntity> { cell, _, artist in
            cell.registration(artist: artist, isDelete: false)
            cell.layoutIfNeeded()
        }
        
        let showCellRegistration = UICollectionView.CellRegistration<ShowListCell, ShowEntity> { cell, _, show in
            cell.registration(showSearch: show)
        }
        
        let searchResultsHeaderRegistration = UICollectionView.SupplementaryRegistration<SPMenuCell>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { headerView, _, indexPath in
            let section = SearchResultsSection(rawValue: indexPath.section)
            switch section {
            case .artists:
                headerView.registration(title: "아티스트", style: .h1)
            case .shows:
                headerView.registration(title: "공연 정보", style: .h1)
            default:
                break
            }
        }
        
        searchResultsDataSource = SearchResultsDataSource(
            collectionView: searchResultsCollectionView
        ) { collectionView, indexPath, item in
            switch item {
            case .artist(let artist):
                return collectionView.dequeueConfiguredReusableCell(
                    using: artistCellRegistration,
                    for: indexPath,
                    item: artist
                )
            case .show(let show):
                return collectionView.dequeueConfiguredReusableCell(
                    using: showCellRegistration,
                    for: indexPath,
                    item: show
                )
            }
        }
        
        searchResultsDataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: searchResultsHeaderRegistration,
                for: indexPath
            )
        }
    }
    
    func applySnapshots(artists: [ArtistEntity], shows: [ShowEntity]) {
        // 검색 결과 스냅샷
        var searchResultsSnapshot = SearchResultsSnapshot()
        searchResultsSnapshot.appendSections(SearchResultsSection.allCases)
        searchResultsSnapshot.appendItems(
            artists.map { .artist($0) },
            toSection: .artists
        )
        searchResultsSnapshot.appendItems(
            shows.map { .show($0) },
            toSection: .shows
        )
        searchResultsDataSource?.apply(
            searchResultsSnapshot,
            animatingDifferences: true
        )
    }
    
    func applyRecentSearchesSnapshot(recentQueries: [String]) {
        // 최근 검색어 스냅샷
        var recentSearchesSnapshot = RecentSearchesSnapshot()
        recentSearchesSnapshot.appendSections([0])
        recentSearchesSnapshot.appendItems(recentQueries)
        recentSearchesDataSource?.apply(
            recentSearchesSnapshot,
            animatingDifferences: true
        )
    }
}

// MARK: - Bindings
private extension SearchViewController {
    func bindAction() {
        searchTextField.textField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(searchTextField.textField.rx.text.orEmpty)
            .bind(with: self) { this, text in
                this.searchTextField.textField.resignFirstResponder()
                this.composer.action.accept(.searchTextFieldOnSubmit(text))
            }
            .disposed(by: disposeBag)
        
        searchTextField.button.rx.tap
            .map { _ in Action.searchTextFieldButtonTapped }
            .bind(to: composer.action)
            .disposed(by: disposeBag)
        
        clearAllButton.rx.tap
            .map { _ in Action.clearButtonTapped }
            .bind(to: composer.action)
            .disposed(by: disposeBag)
    }
    
    func bindState() {
        composer.$state.observable
            .compactMap(\.recentQueries)
            .distinctUntilChanged()
            .drive(with: self) { this, recentQueries in
                this.applyRecentSearchesSnapshot(recentQueries: [])
//                this.recentSearchesCollectionView.collectionViewLayout = this.createRecentSearchesLayout()
            }
            .disposed(by: disposeBag)
        
        Driver.combineLatest(
            composer.$state.observable.map(\.artists),
            composer.$state.observable.map(\.shows)
        )
        .drive(with: self) { this, value in
            let (artists, shows) = value
            this.applySnapshots(artists: artists, shows: shows)
        }
        .disposed(by: disposeBag)
        
        composer.$state.present(\.$showSearchResult)
            .drive(with: self) { this, showSearchResult in
                this.updateCollectionView(showSearchResult: showSearchResult)
            }
            .disposed(by: disposeBag)
        
        composer.$state.observable
            .map(\.query)
            .drive(with: self) { this, query in
                this.searchTextField.updateButtonImage(
                    !query.isEmpty ? .icCancel : .icMagnifier
                )
                this.searchTextField.textField.text = query
            }
            .disposed(by: disposeBag)
    }
}


@available(iOS 17.0, *)
#Preview {
    SearchViewController(viewModel: SearchViewModel(query: ""))
}
