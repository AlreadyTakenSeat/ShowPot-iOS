//
//  ShowListViewController.swift
//  ShowPot
//
//  Created by 김도형 on 4/6/25.
//

import UIKit

import SnapKit
import RxCompose
import RxSwift
import RxCocoa

final class ShowOpenListViewController: UIViewController, Composable {
    
    // MARK: - Properties
    private let navigationBar = SPNavigationBar(title: "전체공연")
    private let filterCheckBox = SPCheckBox()
    private let filterLabel = UILabel()
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createFlowLayout()
    )
    private let searchButton = UIButton()
    private let loadingIndicator = SPLoadingIndicator()
    
    private var dataSource: DataSource?
    private var shows: [ShowOpenEntity] = ShowOpenEntity.mockList // ShowOpenEntity는 외부에서 정의된다고 가정
    private var isFilterEnabled: Bool = true
    
    @Compose
    var composer = ShowOpenListViewModel()
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
        
        composer.action.accept(.viewDidLoad)
    }
}

// MARK: - Configure View
private extension ShowOpenListViewController {
    private func configureUI() {
        view.backgroundColor = .gray700
        
        configureNavigationBar()
        
        configureSearchButton()
        
        configureFilterCheckBox()
        
        configureFilterLabel()
        
        configureCollectionView()
        
        view.addSubview(loadingIndicator)
    }
    
    private func configureLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        filterCheckBox.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(24)
        }
        
        filterLabel.snp.makeConstraints { make in
            make.centerY.equalTo(filterCheckBox)
            make.leading.equalTo(filterCheckBox.snp.trailing).offset(8)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(filterCheckBox.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(40)
        }
    }
    
    private func configureNavigationBar() {
        navigationBar.setTitleColor(.gray000)
        view.addSubview(navigationBar)
    }
    
    private func configureSearchButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .icMagnifier.resized(
            to: CGSize(width: 36, height: 36)
        )
        .withTintColor(.gray100)
        configuration.contentInsets = .zero
        searchButton.configuration = configuration
        view.addSubview(searchButton)
    }
    
    
    private func configureFilterCheckBox() {
        filterCheckBox.isSelected = false // 초기 상태: 체크됨
        view.addSubview(filterCheckBox)
    }
    
    private func configureFilterLabel() {
        let attributedText = NSAttributedString(
            "오픈예정 티켓만 보기",
            fontType: KRFont.B2_regular,
            lineBreakMode: .byTruncatingTail,
            alignment: .left
        ).setForegroundColor(color: .gray000)
        filterLabel.attributedText = attributedText
        view.addSubview(filterLabel)
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        view.addSubview(collectionView)
    }
    
    private func createFlowLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            // 콘텐츠 아이템 (ShowListOpenCell)
            let contentItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(106)
            )
            let contentItem = NSCollectionLayoutItem(layoutSize: contentItemSize)
            
            // 그룹 (헤더 + 콘텐츠 + 버튼)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(106) // 콘텐츠 100
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [contentItem]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 16,
                bottom: 0,
                trailing: 16
            )
            section.interGroupSpacing = 10
            
            return section
        }
    }
}

// MARK: - DataSource and Snapshot
private extension ShowOpenListViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias Registration = UICollectionView.CellRegistration<ShowListOpenCell, ShowOpenEntity>
    
    enum Section: Int, CaseIterable {
        case main
    }
    
    enum Item: Hashable {
        case show(ShowOpenEntity)
    }
    
    func configureDataSource() {
        let showCellRegistration = Registration { cell, _, show in
            cell.registration(showOpen: show)
            cell.layoutIfNeeded()
        }
        
        dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            switch item {
            case .show(let show):
                return collectionView.dequeueConfiguredReusableCell(
                    using: showCellRegistration,
                    for: indexPath,
                    item: show
                )
            }
        }
    }
    
    func applySnapshot(showOpens: [ShowOpenEntity]) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(showOpens.map { .show($0) }, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Bindings and Actions
private extension ShowOpenListViewController {
    func bindAction() {
        filterCheckBox.rx.tap
            .map { Action.filterCheckBoxTapped }
            .bind(to: composer.action)
            .disposed(by: disposeBag)
        
        navigationBar.rx.backButtonTap
            .bind(to: rx.popViewController(animated: true))
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .map { SearchViewController(viewModel: SearchViewModel(query: "")) }
            .bind(to: rx.pushViewController(animated: true))
            .disposed(by: disposeBag)
        
        collectionView.rx.prefetchItems
            .map { Action.prefetchItems($0.map(\.item)) }
            .bind(to: composer.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.willDisplayCell
            .map { Action.willDisplayCell($0.at.item) }
            .bind(to: composer.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .withUnretained(self)
            .compactMap { this, indexPath in
                let item = this.dataSource?.itemIdentifier(for: indexPath)
                switch item {
                case let .show(showOpen):
                    let state = ShowDetailViewModel.State(showId: showOpen.id)
                    let viewModel = ShowDetailViewModel(state: state)
                    return ShowDetailViewController(viewModel: viewModel)
                default: return nil
                }
            }
            .bind(to: rx.pushViewController(animated: true))
            .disposed(by: disposeBag)
    }
    
    func bindState() {
        composer.$state.observable
            .map(\.showOpens.data)
            .distinctUntilChanged()
            .drive(with: self) { this, showOpens in
                this.applySnapshot(showOpens: showOpens)
            }
            .disposed(by: disposeBag)
        
        composer.$state.observable
            .map(\.onlyOpenSchedule)
            .distinctUntilChanged()
            .drive(filterCheckBox.rx.isSelected)
            .disposed(by: disposeBag)
        
        composer.$state.present(\.$isLoading)
            .distinctUntilChanged()
            .drive(loadingIndicator.rx.animating)
            .disposed(by: disposeBag)
    }
}

@available(iOS 17.0, *)
#Preview {
    ShowOpenListViewController()
}
