//
//  ShowDetailViewController.swift
//  ShowPot
//
//  Created by 김도형 on 4/4/25.
//

import UIKit

import SnapKit
import RxCompose
import RxSwift
import RxCocoa

final class ShowDetailViewController: UIViewController, Composable {
    // MARK: - Properties
    private let navigationBar = SPNavigationBar(title: "공연정보")
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout()
    )
    private let ctaButton = SPCTAButton(title: "알림 설정하기", style: .primary)
    private let favoriteButton = UIButton()
    
    private var dataSource: DataSource?
    
    @Compose
    var composer = ShowDetailViewModel()
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
        
        configureDataSource()
        
        bindState()
        
        bindAction()
    }
}

// MARK: - Configure View
private extension ShowDetailViewController {
    private func configureUI() {
        view.backgroundColor = .gray700
        
        configureCollectionView()
        
        configureCTAButton()
        
        configureFavoriteButton()
        
        configureNavigationBar()
    }
    
    private func configureLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(ctaButton.snp.top).offset(-9)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(ctaButton)
            make.height.equalTo(ctaButton)
            make.width.equalTo(ctaButton.snp.height)
            make.leading.equalToSuperview().inset(16)
        }
        
        ctaButton.snp.makeConstraints { make in
            make.leading.equalTo(favoriteButton.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func configureNavigationBar() {
        navigationBar.setTitleColor(.gray000)
        view.addSubview(navigationBar)
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.rx.contentOffset
            .bind(with: self) { this, offset in
                UIView.fadeAnimate {
                    let isScrolling = offset.y > 0
                    this.navigationBar.backgroundColor = isScrolling
                    ? .gray700
                    : .clear
                }
            }
            .disposed(by: disposeBag)
        view.addSubview(collectionView)
    }
    
    private func configureCTAButton() {
        view.addSubview(ctaButton)
    }
    
    private func configureFavoriteButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.background.backgroundColor = .gray500
        configuration.background.cornerRadius = 0
        configuration.image = .icHeartLarge.resized(
            to: CGSize(
                width: 36,
                height: 36
            )
        )
        .withTintColor(.gray200)
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 10,
            bottom: 10,
            trailing: 10
        )
        favoriteButton.configuration = configuration
        favoriteButton.configurationUpdateHandler = { button in
            let size = CGSize(width: 36, height: 36)
            button.configuration?.image =  button.state == .selected
            ? .icHeartFilled.resized(to: size)
            : .icHeartLarge.resized(to: size)
        }
        
        view.addSubview(favoriteButton)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            switch Section(rawValue: sectionIndex) {
            case .poster:
                return self?.createPosterSection()
            case .showInfo:
                return self?.createShowInfoSection()
            case .ticketingInfo:
                return self?.createTicketingInfoSection()
            case .ticketingTimes:
                return self?.createTicketingTimesSection(environment: environment)
            case .artists:
                return self?.createArtistsSection()
            case .seatPrices:
                return self?.createSeatPricesSection(environment: environment)
            case .genres:
                return self?.createGenresSection()
            default:
                return nil
            }
        }
        
        layout.register(
            SeatPricesBackgroundView.self,
            forDecorationViewOfKind: "seatPricesBackground"
        )
        return layout
    }
    
    private func createPosterSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(524)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(524)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 13,
            trailing: 0
        )
        
        return section
    }
    
    private func createShowInfoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 12,
            trailing: 16
        )
        
        return section
    }
    
    private func createTicketingInfoSection() -> NSCollectionLayoutSection {
        let ticketSiteItemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .absolute(34)
        )
        let ticketSiteItem = NSCollectionLayoutItem(
            layoutSize: ticketSiteItemSize
        )
        ticketSiteItem.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 8
        )
        ticketSiteItem.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: NSCollectionLayoutSpacing.fixed(0),
            top: NSCollectionLayoutSpacing.fixed(0),
            trailing: NSCollectionLayoutSpacing.fixed(8),
            bottom: NSCollectionLayoutSpacing.fixed(0)
        )
        
        let ticketSiteGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(34)
        )
        let ticketSiteGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: ticketSiteGroupSize,
            subitems: [ticketSiteItem]
        )
        
        let section = NSCollectionLayoutSection(group: ticketSiteGroup)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 16,
            bottom: 12,
            trailing: 16
        )
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createTicketingTimesSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        configuration.backgroundColor = .clear
        
        let section = NSCollectionLayoutSection.list(
            using: configuration,
            layoutEnvironment: environment
        )
        section.interGroupSpacing = 4
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 12,
            trailing: 16
        )
        
        return section
    }
    
    private func createArtistsSection() -> NSCollectionLayoutSection {
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
            top: 12,
            leading: 16,
            bottom: 14,
            trailing: 16
        )
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createSeatPricesSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        configuration.backgroundColor = .clear
        
        let section = NSCollectionLayoutSection.list(
            using: configuration,
            layoutEnvironment: environment
        )
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 12,
            bottom: 24,
            trailing: 12
        )
        section.interGroupSpacing = 4
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 0,
            trailing: 16
        )
        section.boundarySupplementaryItems = [header]
        
        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(
            elementKind: "seatPricesBackground"
        )
        backgroundDecoration.contentInsets = NSDirectionalEdgeInsets(
            top: 48,
            leading: 16,
            bottom: 12,
            trailing: 16
        )
        section.decorationItems = [backgroundDecoration]
        
        return section
    }
    
    private func createGenresSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(80),
            heightDimension: .absolute(34)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 8
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(34)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 16,
            bottom: 20,
            trailing: 16
        )
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
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

// MARK: - DataSource and Snapshot
private extension ShowDetailViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int, CaseIterable {
        case poster
        case showInfo
        case ticketingInfo
        case ticketingTimes
        case artists
        case seatPrices
        case genres
    }
    
    enum Item: Hashable {
        case poster(String)
        case showInfo(ShowDetailEntity)
        case ticketSite(ShowDetailEntity.TicketingSite)
        case ticketingTime(ShowDetailEntity.TicketingTime)
        case artist(ShowDetailEntity.Artist)
        case seatPrice(ShowDetailEntity.Seat)
        case genre(ShowDetailEntity.Genre)
    }
    
    func configureDataSource() {
        // Poster Cell
        let posterCellRegistration = UICollectionView.CellRegistration<PosterCell, String> { cell, _, imageURL in
            cell.configure(with: imageURL)
            cell.layoutIfNeeded()
        }
        
        // Show Info Cell
        let showInfoCellRegistration = UICollectionView.CellRegistration<ShowInfoCell, ShowDetailEntity> { cell, _, show in
            cell.configure(with: show)
        }
        
        // Ticket Site Cell
        let ticketSiteCellRegistration = UICollectionView.CellRegistration<TicketSiteCell, ShowDetailEntity.TicketingSite> { cell, _, ticketSite in
            cell.configure(with: ticketSite)
        }
        
        // Ticketing Time Cell
        let ticketingTimeCellRegistration = UICollectionView.CellRegistration<TicketingTimeCell, ShowDetailEntity.TicketingTime> { cell, _, ticketingTime in
            cell.configure(with: ticketingTime)
        }
        
        // Artist Cell
        let artistCellRegistration = UICollectionView.CellRegistration<ArtistCell, ShowDetailEntity.Artist> { cell, _, artist in
            cell.registration(
                artist: ArtistEntity(
                    id: artist.id,
                    imageURL: artist.imageURL,
                    name: artist.name
                ),
                isDelete: false
            )
            cell.layoutIfNeeded()
        }
        
        // Seat Price Cell
        let seatPriceCellRegistration = UICollectionView.CellRegistration<SeatPriceCell, ShowDetailEntity.Seat> { cell, _, seatPrice in
            cell.configure(with: seatPrice)
        }
        
        // Genre Cell
        let genreCellRegistration = UICollectionView.CellRegistration<GenreChipCell, ShowDetailEntity.Genre> { cell, _, genre in
            cell.configure(with: genre.name)
        }
        
        // Header Registration
        let headerRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderCell>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { headerView, _, indexPath in
            let section = Section(rawValue: indexPath.section)
            switch section {
            case .ticketingInfo:
                headerView.configure(with: "티켓팅 정보")
            case .artists:
                headerView.configure(with: "아티스트 정보")
            case .seatPrices:
                headerView.configure(with: "좌석 가격 정보")
            case .genres:
                headerView.configure(with: "공연 장르")
            default:
                break
            }
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .poster(let imageURL):
                return collectionView.dequeueConfiguredReusableCell(
                    using: posterCellRegistration,
                    for: indexPath,
                    item: imageURL
                )
            case .showInfo(let show):
                return collectionView.dequeueConfiguredReusableCell(
                    using: showInfoCellRegistration,
                    for: indexPath,
                    item: show
                )
            case .ticketSite(let ticketSite):
                return collectionView.dequeueConfiguredReusableCell(
                    using: ticketSiteCellRegistration,
                    for: indexPath,
                    item: ticketSite
                )
            case .ticketingTime(let ticketingTime):
                return collectionView.dequeueConfiguredReusableCell(
                    using: ticketingTimeCellRegistration,
                    for: indexPath,
                    item: ticketingTime
                )
            case .artist(let artist):
                return collectionView.dequeueConfiguredReusableCell(
                    using: artistCellRegistration,
                    for: indexPath,
                    item: artist
                )
            case .seatPrice(let seatPrice):
                return collectionView.dequeueConfiguredReusableCell(
                    using: seatPriceCellRegistration,
                    for: indexPath,
                    item: seatPrice
                )
            case .genre(let genre):
                return collectionView.dequeueConfiguredReusableCell(
                    using: genreCellRegistration,
                    for: indexPath,
                    item: genre
                )
            }
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            let section = Section(rawValue: indexPath.section)
            switch section {
            case .ticketingInfo, .artists, .seatPrices, .genres:
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: headerRegistration,
                    for: indexPath
                )
            case .ticketingTimes, .poster, .showInfo, .none:
                return nil
            }
        }
    }
    
    func applySnapshot(show: ShowDetailEntity) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        
        snapshot.appendItems(
            [.poster(show.posterImageURL)],
            toSection: .poster
        )
        snapshot.appendItems(
            [.showInfo(show)],
            toSection: .showInfo
        )
        snapshot.appendItems(
            show.ticketingSites.map { .ticketSite($0) },
            toSection: .ticketingInfo
        )
        snapshot.appendItems(
            show.ticketingTimes.map { .ticketingTime($0) },
            toSection: .ticketingTimes
        )
        snapshot.appendItems(
            show.artists.map { .artist($0) },
            toSection: .artists)
        snapshot.appendItems(
            show.seats.map { .seatPrice($0) },
            toSection: .seatPrices)
        snapshot.appendItems(
            show.genres.map { .genre($0) },
            toSection: .genres)
        
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Bindings
private extension ShowDetailViewController {
    func bindAction() {
        navigationBar.rx.backButtonTap
            .bind(to: rx.popViewController(animated: true))
            .disposed(by: disposeBag)
        
        favoriteButton.rx.tap
            .map { Action.favoriteButtonTapped }
            .bind(to: composer.action)
            .disposed(by: disposeBag)
        
        ctaButton.rx.tap
            .map { Action.alarmButtonTapped }
            .bind(to: composer.action)
            .disposed(by: disposeBag)
    }
    
    func bindState() {
        composer.$state.observable
            .map(\.show)
            .distinctUntilChanged()
            .drive(with: self) { this, show in
                this.applySnapshot(show: show)
            }
            .disposed(by: disposeBag)
        
        composer.$state.present(\.$isFavorite)
            .drive(favoriteButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        composer.$state.present(\.$alarmSelectionViewModel)
            .map { composer -> AlarmSelectionViewController? in
                guard let composer else { return nil }
                return AlarmSelectionViewController(composer: composer)
            }
            .drive(with: self) { this, viewController in
                if let viewController {
                    this.present(viewController, animated: true)
                } else {
                    this.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}

@available(iOS 17.0, *)
#Preview {
    ShowDetailViewController()
}
