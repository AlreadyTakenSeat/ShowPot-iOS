//
//  HomeViewController.swift
//  ShowPot
//
//  Created by 김도형 on 4/2/25.
//

import UIKit

import RxSwift
import RxCocoa
import RxCompose
import RxGesture
import SnapKit

final class HomeViewController: UIViewController, Composable {
    // MARK: - Properties
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout()
    )
    private let logoImageView = UIImageView(image: .logoTitle)
    private let alarmButton = UIButton()
    private var dataSource: DataSource?
    
    @Compose
    var composer = HomeViewModel()
    var disposeBag = DisposeBag()
    
    // MARK: - Initialization
    init() {
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
        
        bindState()
        
        bindAction()
        
        composer.action.accept(.viewDidLoad)
    }
    
    @objc private func buttonTapped() {
        print("전체공연보러가기 버튼이 눌렸습니다.")
        // 여기에 전체 공연 목록 화면으로 이동하는 로직을 추가하세요
    }
}

// MARK: - Configure View
private extension HomeViewController {
    private func configureUI() {
        view.backgroundColor = .gray700
        
        configureLogoImageView()
        
        configureAlarmButton()
        
        configureCollectionView()
        
        configureDataSource()
    }
    
    private func configureLayout() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(91)
            make.height.equalTo(36)
        }
        
        alarmButton.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.trailing.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(18)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(80) // 바닥 여백 수정: inset(80) -> safeAreaLayoutGuide
        }
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        view.addSubview(collectionView)
    }
    
    private func configureLogoImageView() {
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true
        view.addSubview(logoImageView)
    }
    
    private func configureAlarmButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .icAlarm.resized(
            to: CGSize(
                width: 36,
                height: 36
            )
        )
        .withTintColor(.gray000)
        configuration.contentInsets = .zero
        configuration.background.backgroundColor = .clear
        
        alarmButton.configuration = configuration
        view.addSubview(alarmButton)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            switch Section(rawValue: sectionIndex) {
            case .searchBar:
                return self?.createSearchBarSection()
            case .genreSubscription:
                return self?.createHorizontalSection(
                    itemWidth: 100,
                    itemHeight: 100,
                    headerHeight: 44,
                    spacing: 10
                )
            case .artistSubscription:
                return self?.createHorizontalSection(
                    itemWidth: 100,
                    itemHeight: 129,
                    headerHeight: 44,
                    spacing: 12
                )
            case .upcomingTicketing:
                return self?.createUpcomingTicketingSection()
            case .upcomingTicketingButton: // 새 섹션 추가
                return self?.createUpcomingTicketingButtonSection()
            case .recommendedShows:
                return self?.createHorizontalSection(
                    itemWidth: 192,
                    itemHeight: 309,
                    headerHeight: 44,
                    spacing: 18
                )
            default: return nil
            }
        }
    }
    
    private func createSearchBarSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50) // .estimated(50) -> .absolute(50)으로 수정
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 16,
            bottom: 18,
            trailing: 16
        )
        return section
    }
    
    private func createHorizontalSection(
        itemWidth: CGFloat,
        itemHeight: CGFloat,
        headerHeight: CGFloat,
        spacing: CGFloat
    ) -> NSCollectionLayoutSection {
        let contentItemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(itemHeight)
        )
        let contentItem = NSCollectionLayoutItem(layoutSize: contentItemSize)
        contentItem.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: spacing
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(itemHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [contentItem]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 16,
            bottom: 36,
            trailing: 16
        )
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(headerHeight)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createUpcomingTicketingSection() -> NSCollectionLayoutSection {
        // 콘텐츠 아이템 (ShowListOpenCell)
        let contentItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(100)
        )
        let contentItem = NSCollectionLayoutItem(layoutSize: contentItemSize)
        
        // 그룹 (각 ShowListOpenCell을 개별 그룹으로 처리)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(100)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [contentItem]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 10, // 버튼 섹션과의 간격
            trailing: 16
        )
        section.interGroupSpacing = 10 // 다중 셀 간 간격
        
        // 헤더 추가
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
    
    private func createUpcomingTicketingButtonSection() -> NSCollectionLayoutSection {
        // 버튼 아이템
        let buttonItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let buttonItem = NSCollectionLayoutItem(layoutSize: buttonItemSize)
        buttonItem.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        // 그룹
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [buttonItem]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 38,
            trailing: 16
        )
        
        return section
    }
}

// MARK: - Bind
private extension HomeViewController {
    func bindAction() {
        collectionView.rx.itemSelected
            .withUnretained(self)
            .compactMap { this, indexPath in
                let item = this.dataSource?.itemIdentifier(for: indexPath)
                switch item {
                case .searchBar:
                    return SearchViewController(viewModel: SearchViewModel(query: ""))
                case let .upcomingShow(showOpen):
                    let state = ShowDetailViewModel.State(showId: showOpen.id)
                    let viewModel = ShowDetailViewModel(state: state)
                    return ShowDetailViewController(viewModel: viewModel)
                case let .recommendedShow(showOpen):
                    let state = ShowDetailViewModel.State(showId: showOpen.id)
                    let viewModel = ShowDetailViewModel(state: state)
                    return ShowDetailViewController(viewModel: viewModel)
                default: return nil
                }
            }
            .bind(to: rx.pushViewController(animated: true))
            .disposed(by: disposeBag)
        
        alarmButton.rx.tap
            .map { ShowListViewController() }
            .bind(to: rx.pushViewController(animated: true))
            .disposed(by: disposeBag)
    }
    
    func bindState() {
        Driver.combineLatest(
            composer.$state.observable.map(\.genres.data)
                .distinctUntilChanged(),
            composer.$state.observable.map(\.artists.data)
                .distinctUntilChanged(),
            composer.$state.observable.map(\.recommendedShows.data)
                .distinctUntilChanged(),
            composer.$state.observable.map(\.upcomingShows.data)
                .distinctUntilChanged()
        )
        .drive(with: self) { this, value in
            let (genres, artists, recommendedShows, upcomingShows) = value
            this.applySnapshot(
                genres: genres,
                artists: artists,
                upcomingShows: upcomingShows,
                recommendedShows: recommendedShows
            )
        }
        .disposed(by: disposeBag)
    }
}

// MARK: - DataSource and Snapshot
private extension HomeViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int, CaseIterable {
        case searchBar
        case genreSubscription
        case artistSubscription
        case upcomingTicketing
        case upcomingTicketingButton // 새 섹션 추가
        case recommendedShows
    }
    
    enum Item: Hashable {
        case searchBar
        case genre(GenreEntity)
        case artist(ArtistEntity)
        case upcomingShow(ShowOpenEntity)
        case button
        case recommendedShow(ShowOpenEntity)
    }
    
    func configureDataSource() {
        let searchBarCellRegistration = UICollectionView.CellRegistration<SearchBarSection, Void> { cell, _, _ in
        }
        
        let genreCellRegistration = UICollectionView.CellRegistration<GenreCell, GenreEntity> { cell, _, genre in
            cell.registration(genre: genre, isSelected: false)
        }
        
        let artistCellRegistration = UICollectionView.CellRegistration<ArtistCell, ArtistEntity> { cell, _, artist in
            cell.registration(artist: artist, isDelete: false)
            cell.layoutIfNeeded()
        }
        
        let showListOpenCellRegistration = UICollectionView.CellRegistration<ShowListOpenCell, ShowOpenEntity> { cell, _, show in
            cell.registration(showOpen: show)
            cell.layoutIfNeeded()
        }
        
        let buttonCellRegistration = UICollectionView.CellRegistration<UpcomingTicketingButtonCell, Void> { [weak self] cell, _, _ in
            guard let `self` else { return }
            cell.button.rx.tap
                .map { ShowOpenListViewController() }
                .bind(to: rx.pushViewController(animated: true))
                .disposed(by: cell.disposeBag)
        }
        
        let showCardCellRegistration = UICollectionView.CellRegistration<ShowCardCell, ShowOpenEntity> { cell, _, show in
            cell.registration(show: show)
        }
        
        // 헤더 등록
        let titleArrowHeaderRegistration = UICollectionView.SupplementaryRegistration<SPMenuArrowCell>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak self] headerView, _, indexPath in
            guard let `self` else { return }
            let section = Section(rawValue: indexPath.section)
            switch section {
            case .genreSubscription:
                headerView.registration(title: "장르 구독하기", style: .h1)
                headerView.rx.tapGesture()
                    .when(.recognized)
                    .map { _ in GenreViewController() }
                    .bind(to: rx.pushViewController(animated: true))
                    .disposed(by: headerView.disposeBag)
                
            case .artistSubscription:
                headerView.registration(title: "아티스트 구독하기", style: .h1)
                headerView.rx.tapGesture()
                    .when(.recognized)
                    .map { _ in ArtistViewController() }
                    .bind(to: rx.pushViewController(animated: true))
                    .disposed(by: headerView.disposeBag)
            default:
                break
            }
        }
        
        let titleHeaderRegistration = UICollectionView.SupplementaryRegistration<SPMenuCell>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { headerView, _, indexPath in
            let section = Section(rawValue: indexPath.section)
            switch section {
            case .upcomingTicketing:
                headerView.registration(title: "티켓팅이 얼마 남지 않은 공연", style: .h1)
            case .recommendedShows:
                headerView.registration(title: "추천 공연", style: .h1)
            default: break
            }
        }
        
        dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            switch item {
            case .searchBar:
                return collectionView.dequeueConfiguredReusableCell(
                    using: searchBarCellRegistration,
                    for: indexPath,
                    item: ()
                )
            case .genre(let genre):
                return collectionView.dequeueConfiguredReusableCell(
                    using: genreCellRegistration,
                    for: indexPath,
                    item: genre
                )
            case .artist(let artist):
                return collectionView.dequeueConfiguredReusableCell(
                    using: artistCellRegistration,
                    for: indexPath,
                    item: artist
                )
            case .upcomingShow(let show):
                return collectionView.dequeueConfiguredReusableCell(
                    using: showListOpenCellRegistration,
                    for: indexPath,
                    item: show
                )
            case .button:
                return collectionView.dequeueConfiguredReusableCell(
                    using: buttonCellRegistration,
                    for: indexPath,
                    item: ()
                )
            case .recommendedShow(let show):
                return collectionView.dequeueConfiguredReusableCell(
                    using: showCardCellRegistration,
                    for: indexPath,
                    item: show
                )
            }
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            let section = Section(rawValue: indexPath.section)
            switch section {
            case .genreSubscription, .artistSubscription:
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: titleArrowHeaderRegistration,
                    for: indexPath
                )
            case .upcomingTicketing, .recommendedShows:
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: titleHeaderRegistration,
                    for: indexPath
                )
            default: return nil // .upcomingTicketingButton 섹션은 헤더 없음
            }
        }
    }
    
    func applySnapshot(
        genres: [GenreEntity],
        artists: [ArtistEntity],
        upcomingShows: [ShowOpenEntity],
        recommendedShows: [ShowOpenEntity]
    ) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([.searchBar], toSection: .searchBar)
        snapshot.appendItems(genres.map { .genre($0) }, toSection: .genreSubscription)
        snapshot.appendItems(artists.map { .artist($0) }, toSection: .artistSubscription)
        snapshot.appendItems(upcomingShows.map { .upcomingShow($0) }, toSection: .upcomingTicketing)
        snapshot.appendItems([.button], toSection: .upcomingTicketingButton) // 버튼을 새 섹션으로 이동
        snapshot.appendItems(recommendedShows.map { .recommendedShow($0) }, toSection: .recommendedShows)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

@available(iOS 17.0, *)
#Preview {
    HomeViewController()
}
