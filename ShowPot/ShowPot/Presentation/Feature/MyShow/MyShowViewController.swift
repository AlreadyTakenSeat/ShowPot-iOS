//
//  MyShowViewController.swift
//  ShowPot
//
//  Created by 김도형 on 4/5/25.
//

import UIKit

import SnapKit
import RxCompose
import RxSwift
import RxCocoa

// 더미 헤더를 위한 UICollectionReusableView 서브클래스
final class PlaceholderHeaderView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class MyShowViewController: UIViewController, Composable {
    // MARK: - Properties
    private let titleLabel = UILabel()
    private let showTitleLabel = UILabel()
    private let dDayTitleLabel = UILabel()
    private let dDayLabel = UILabel()
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout()
    )
    
    private var dataSource: DataSource?
    
    @Compose
    var composer = MyShowViewModel()
    var disposeBag = DisposeBag()
    
    var showsIsEmpty = true
    
    // MARK: - Constants
    private let showsSectionHeight: CGFloat = 368 + 24 + 22 // ShowTicketCell 높이(368) + top inset(24) + bottom inset(22)
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        composer.action.accept(.viewDidAppear)
    }
}

// MARK: - Configure View
private extension MyShowViewController {
    private func configureUI() {
        view.backgroundColor = .gray700
        
        configureHeaderView()
        
        configureCollectionView()
    }
    
    private func configureLayout() {
        view.addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
        
        showTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        dDayTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(showTitleLabel.snp.bottom)
            make.leading.equalTo(showTitleLabel)
        }
        
        dDayLabel.snp.makeConstraints { make in
            make.leading.equalTo(dDayTitleLabel.snp.trailing).offset(8)
            make.top.equalTo(showTitleLabel.snp.bottom)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(dDayTitleLabel.snp.bottom).offset(24)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func configureHeaderView() {
        titleLabel.attributedText = NSAttributedString(
            "티켓팅이 임박한 공연",
            style: .init(fontType: KRFont.H1)
        ).setForegroundColor(color: .gray300)
        view.addSubview(titleLabel)
        
        showTitleLabel.isHidden = true
        view.addSubview(showTitleLabel)
        
        dDayTitleLabel.isHidden = true
        view.addSubview(dDayTitleLabel)
        
        dDayLabel.isHidden = true
        view.addSubview(dDayLabel)
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            switch Section(rawValue: sectionIndex) {
            case .shows:
                return self?.createShowsSection()
            case .menu:
                return self?.createMenuSection()
            default:
                return nil
            }
        }
        return layout
    }
    
    private func createShowsSection() -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize
        let groupSize: NSCollectionLayoutSize
        
        if showsIsEmpty {
            // 플레이스홀더 셀일 경우
            itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(showsSectionHeight)
            )
            groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(showsSectionHeight)
            )
        } else {
            // 티켓 셀일 경우
            itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(258),
                heightDimension: .absolute(368)
            )
            groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(258),
                heightDimension: .absolute(368)
            )
        }
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 22,
            trailing: 16
        )
        
        // visibleItemsInvalidationHandler 설정
        guard !showsIsEmpty else { return section }
        
        section.visibleItemsInvalidationHandler = { [weak self] items, offset, environment in
            guard let `self` else { return }
            
            let itemWidth: CGFloat = 258
            let interGroupSpacing: CGFloat = 16
            let containerWidth = collectionView.bounds.width
            let contentOffsetX = offset.x + (containerWidth / 2)
            
            // 가운데 셀의 인덱스 계산
            let index = Int(round((contentOffsetX - (itemWidth / 2)) / (itemWidth + interGroupSpacing)))
            let safeIndex = max(0, min(index, items.count - 1))
            
            // 해당 인덱스의 ShowAlarmEntity로 헤더 업데이트
            let show = composer.state.shows.data[safeIndex]
            updateHeader(with: show)
            
            // 스크롤에 따른 스케일 및 알파 효과 적용
            let maxDistance = containerWidth / 2
            for item in items {
                let itemCenterX = item.center.x - offset.x
                let distanceFromCenter = abs(containerWidth / 2 - itemCenterX)
                let normalizedDistance = min(distanceFromCenter / maxDistance, 1.0)
                
                let minScale: CGFloat = 0.84
                let scale = 1.0 - (normalizedDistance * (1.0 - minScale))
                
                let minAlpha: CGFloat = 0.4
                let alpha = 1.0 - (normalizedDistance * (1.0 - minAlpha))
                
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
                item.alpha = alpha
            }
        }
        
        return section
    }
    
    private func createMenuSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 16,
            trailing: 0
        )
        section.interGroupSpacing = 12
        return section
    }
}

// MARK: - DataSource and Snapshot
private extension MyShowViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int, CaseIterable {
        case shows
        case menu
    }
    
    enum Item: Hashable {
        case show(ShowAlarmEntity)
        case placeholder
        case menu(MenuItem)
    }
    
    enum MenuItem: Hashable {
//        case showAlarm(Int)
//        case showFavorite(Int)
//        case showEnded(Int)
        
        var title: String {
            switch self {
//            case .showAlarm: return "알림 설정한 공연"
//            case .showFavorite: return "관심 공연"
//            case .showEnded: return "티켓팅 종료 공연"
            }
        }
        
        var icon: UIImage? {
            switch self {
//            case .showAlarm: return .icAlarm
//            case .showFavorite: return .icHeartSmall
//            case .showEnded: return .icTicketFinish
            }
        }
        
        var count: Int {
            switch self {
//            case .showAlarm(let count),
//            case .showFavorite(let count):
//                 .showEnded(let count):
//                return count
            }
        }
    }
    
    func configureDataSource() {
        // Menu Cell
        let menuCellRegistration = UICollectionView.CellRegistration<SPMenuArrowIconCell, MenuItem> { cell, _, menu in
            cell.registration(title: menu.title, count: menu.count, icon: menu.icon)
        }
        
        // Show Cell
        let showCellRegistration = UICollectionView.CellRegistration<ShowTicketCell, ShowAlarmEntity> { cell, _, show in
            cell.registration(showAlarm: show)
        }
        
        // Placeholder Cell
        let placeholderCellRegistration = UICollectionView.CellRegistration<PlaceholderCell, Void> { _, _, _ in
            // 플레이스홀더 셀은 추가 설정이 필요 없음
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .menu(let menu):
                return collectionView.dequeueConfiguredReusableCell(
                    using: menuCellRegistration,
                    for: indexPath,
                    item: menu
                )
            case .show(let show):
                return collectionView.dequeueConfiguredReusableCell(
                    using: showCellRegistration,
                    for: indexPath,
                    item: show
                )
            case .placeholder:
                return collectionView.dequeueConfiguredReusableCell(
                    using: placeholderCellRegistration,
                    for: indexPath,
                    item: Void()
                )
            }
        }
    }
    
    func applySnapshot(menus: [MenuItem], shows: [ShowAlarmEntity]) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        
        // shows 섹션에 데이터 추가
        if let show = shows.first {
            updateHeader(with: show)
            snapshot.appendItems(shows.map { Item.show($0) }, toSection: .shows)
        } else {
            snapshot.appendItems([.placeholder], toSection: .shows)
        }
        
        snapshot.appendItems(menus.map { Item.menu($0) }, toSection: .menu)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func updateHeader(with show: ShowAlarmEntity) {
        showTitleLabel.attributedText = NSAttributedString(
            show.title,
            fontType: ENFont.H0,
            multiline: true
        ).setForegroundColor(color: .gray100)
        
        showTitleLabel.isHidden = false
        
        dDayTitleLabel.attributedText = NSAttributedString(
            "공연 티켓팅까지, ",
            fontType: KRFont.H0
        ).setForegroundColor(color: .gray100)
        dDayTitleLabel.isHidden = false
        
        // 디데이 계산 (ticketingAt을 기준으로 D-Day 계산)
        let ticketingAt = show.ticketingAt.toDate(.default)
        guard let ticketingAt  else {
            print(show.ticketingAt)
            return
        }
        dDayLabel.isHidden = false
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [.day],
            from: currentDate,
            to: ticketingAt
        )
        let dDay = components.day ?? 0
        let dDayText = dDay >= 0 ? "D-\(dDay)" : "D+\(-dDay)"
        
        dDayLabel.attributedText = NSAttributedString(
            dDayText,
            style: .init(fontType: KRFont.H0)
        ).setForegroundColor(color: .mainOrange)
    }
}

// MARK: - Bindings
private extension MyShowViewController {
    func bindAction() {
        collectionView.rx.itemSelected
            .withUnretained(self)
            .compactMap { this, indexPath -> UIViewController? in
                let item = this.dataSource?.itemIdentifier(for: indexPath)
                switch item {
                case let .show(showAlarm):
                    let state = ShowDetailViewModel.State(showId: showAlarm.id)
                    let viewModel = ShowDetailViewModel(state: state)
                    return ShowDetailViewController(viewModel: viewModel)
                default: return nil
                }
            }
            .bind(to: rx.pushViewController(animated: true))
            .disposed(by: disposeBag)
    }
    
    func bindState() {
        Driver.combineLatest(
            composer.$state.observable.map(\.shows.data),
            composer.$state.observable.map(\.alertsCount),
            composer.$state.observable.map(\.interestCount),
            composer.$state.observable.map(\.ticketingCount)
        )
        .drive(with: self) { this, value in
            let (shows, alertsCount, interestsCount, ticketingCount) = value
            this.applySnapshot(
                menus: [
//                    .showAlarm(alertsCount),
//                    .showFavorite(interestsCount)
//                    .showEnded(ticketingCount)
                ],
                shows: shows
            )
            this.showsIsEmpty = shows.isEmpty
            this.collectionView.collectionViewLayout = this.createCompositionalLayout()
        }
        .disposed(by: disposeBag)
    }
}

@available(iOS 17.0, *)
#Preview {
    MyShowViewController()
}


