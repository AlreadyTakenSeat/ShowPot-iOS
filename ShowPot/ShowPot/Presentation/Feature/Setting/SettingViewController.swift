//
//  SettingViewController.swift
//  ShowPot
//
//  Created by 김도형 on 4/6/25.
//

import UIKit

import Dependencies
import RxSwift
import RxCocoa
import SnapKit

final class SettingViewController: UIViewController {
    // MARK: - Properties
    private let navigationBar = SPNavigationBar(title: "설정")
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout()
    )
    private var dataSource: DataSource?
    @Dependency(\.openURL)
    private var openURL
    
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
    }
}

// MARK: - Configure View
private extension SettingViewController {
    private func configureUI() {
        view.backgroundColor = .gray700
        
        configureNavigationBar()
        
        configureCollectionView()
        
        configureDataSource()
        
        applySnapshot()
    }
    
    private func configureLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureNavigationBar() {
        navigationBar.setTitleColor(.gray300)
        navigationBar.rx.backButtonTap
            .bind(to: rx.popViewController(animated: true))
            .disposed(by: disposeBag)
        
        view.addSubview(navigationBar)
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.rx.itemSelected
            .withUnretained(self)
            .compactMap { this, indexPath -> UIViewController? in
                let item = this.dataSource?.itemIdentifier(for: indexPath)
                switch item {
                case .account: return AccountViewController()
                case .notificationSettings: return nil
                case .privacyPolicy: return nil
                case .termsOfService: return nil
                case .contactKakao: return nil
                default: return nil
                }
            }
            .bind(to: rx.pushViewController(animated: true))
            .disposed(by: disposeBag)
        collectionView.rx.itemSelected
            .bind(with: self) { this, indexPath in
                let item = this.dataSource?.itemIdentifier(for: indexPath)
                switch item {
                case .termsOfService:
                    guard
                        let url = URL(string: "https://yapp-workspace.notion.site/582c7c2a041945f383962ab3495ad14a")
                    else { return }
                    Task { await this.openURL(url) }
                case .privacyPolicy:
                    guard
                        let url = URL(string: "https://yapp-workspace.notion.site/582c7c2a041945f383962ab3495ad14a")
                    else { return }
                    Task { await this.openURL(url) }
                case .contactKakao:
                    guard
                        let url = URL(string: "https://www.instagram.com/showpot_official/")
                    else { return }
                    Task { await this.openURL(url) }
                case .notificationSettings:
                    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    UIApplication.shared.open(settingsURL) { _ in }
                default: return
                }
            }
            .disposed(by: disposeBag)
        
        view.addSubview(collectionView)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            return self?.createMenuSection(environment: environment)
        }
    }
    
    private func createMenuSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        configuration.backgroundColor = .clear
        
        let section = NSCollectionLayoutSection.list(
            using: configuration,
            layoutEnvironment: environment
        )
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        return section
    }
}

// MARK: - DataSource and Snapshot
private extension SettingViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int, CaseIterable {
        case settings
    }
    
    enum Item: Hashable {
        case account
        case notificationSettings
        case privacyPolicy
        case termsOfService
        case contactKakao
    }
    
    func configureDataSource() {
        let menuCellRegistration = UICollectionView.CellRegistration<SPMenuArrowIconCell, Item> { cell, _, item in
            switch item {
            case .account:
                cell.registration(
                    title: "계정",
                    icon: .icProfile,
                    style: .h2
                )
            case .notificationSettings:
                cell.registration(
                    title: "알림 설정",
                    icon: .icAlarm,
                    style: .h2
                )
            case .privacyPolicy:
                cell.registration(
                    title: "개인정보 처리 방침",
                    icon: .icPrivacy,
                    style: .h2
                )
            case .termsOfService:
                cell.registration(
                    title: "이용 약관",
                    icon: .icReport,
                    style: .h2
                )
            case .contactKakao:
                cell.registration(
                    title: "인스타그램 문의하기",
                    icon: .icHeadphone,
                    style: .h2
                )
            }
        }
        
        dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(
                using: menuCellRegistration,
                for: indexPath,
                item: item
            )
        }
    }
    
    func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        
        snapshot.appendItems([
            .account,
            .notificationSettings,
            .privacyPolicy,
            .termsOfService,
            .contactKakao
        ], toSection: .settings)
        
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

@available(iOS 17.0, *)
#Preview {
    SettingViewController()
}
