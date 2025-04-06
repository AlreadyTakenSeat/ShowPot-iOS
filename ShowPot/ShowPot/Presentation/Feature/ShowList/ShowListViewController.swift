//
//  ShowListViewController.swift
//  ShowPot
//
//  Created by 김도형 on 4/6/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxCompose

final class ShowListViewController: UIViewController, Composable {
    
    // MARK: - Properties
    private let navigationBar = SPNavigationBar(title: "알림")
    private let emptyView = UIView()
    private let emptyIconImageView = UIImageView()
    private let emptyLabel = UILabel()
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createFlowLayout()
    )
    
    private var dataSource: DataSource?
    
    @Compose
    var composer = ShowListViewModel()
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
private extension ShowListViewController {
    private func configureUI() {
        view.backgroundColor = .gray700
        configureNavigationBar()
        configureEmptyView()
        configureCollectionView()
    }
    
    private func configureLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(72)
            make.centerX.equalToSuperview()
        }
        
        emptyIconImageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(250) // 아이콘 크기 (적당히 조정)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyIconImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureNavigationBar() {
        navigationBar.setTitleColor(.gray000)
        view.addSubview(navigationBar)
    }
    
    private func configureEmptyView() {
        emptyView.isHidden = true // 초기에는 숨김
        view.addSubview(emptyView)
        
        emptyIconImageView.image = .notificationEmpty
            .resized(to: CGSize(width: 250, height: 250))
        emptyIconImageView.contentMode = .scaleAspectFit
        emptyView.addSubview(emptyIconImageView)
        
        let attributedText = NSAttributedString(
            "아직 받은\n알림이 없어요",
            fontType: KRFont.H0,
            alignment: .center,
            multiline: true
        ).setForegroundColor(color: .gray400)
        emptyLabel.attributedText = attributedText
        emptyLabel.numberOfLines = 0
        emptyView.addSubview(emptyLabel)
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        view.addSubview(collectionView)
    }
    
    private func createFlowLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            let contentItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(80) // ShowListCell 높이
            )
            let contentItem = NSCollectionLayoutItem(layoutSize: contentItemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(80)
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
private extension ShowListViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ShowEntity>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ShowEntity>
    typealias Registration = UICollectionView.CellRegistration<ShowListCell, ShowEntity>
    
    enum Section: Int, CaseIterable {
        case main
    }
    
    func configureDataSource() {
        let notificationCellRegistration = Registration { cell, _, notification in
            cell.registration(showSearch: notification, isNotification: true)
            cell.layoutIfNeeded()
        }
        
        dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(
                using: notificationCellRegistration,
                for: indexPath,
                item: item
            )
        }
    }
    
    func applySnapshot(notifications: [ShowEntity]) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(notifications, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Bindings and Actions
private extension ShowListViewController {
    func bindAction() {
        
    }
    
    func bindState() {
        composer.$state.observable
            .map(\.notifications)
            .distinctUntilChanged()
            .drive(with: self) { this, notifications in
                this.applySnapshot(notifications: notifications)
                this.emptyView.isHidden = !notifications.isEmpty
                this.collectionView.isHidden = notifications.isEmpty
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Preview
@available(iOS 17.0, *)
#Preview {
    ShowListViewController()
}
