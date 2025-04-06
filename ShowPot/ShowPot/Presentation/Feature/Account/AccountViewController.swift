//
//  AccountViewController.swift
//  ShowPot
//
//  Created by 김도형 on 4/6/25.
//

import UIKit

import RxSwift
import RxCocoa
import RxCompose
import SnapKit

final class AccountViewController: UIViewController, Composable {
    // MARK: - Properties
    private let navigationBar = SPNavigationBar(title: "계정")
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout()
    )
    private var dataSource: DataSource?
    
    @Compose
    var composer = AccountViewModel()
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
    }
}

// MARK: - Configure View
private extension AccountViewController {
    private func configureUI() {
        view.backgroundColor = .gray700
        
        configureNavigationBar()
        
        configureCollectionView()
        
        configureDataSource()
    }
    
    private func configureLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureNavigationBar() {
        view.addSubview(navigationBar)
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        view.addSubview(collectionView)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            return self?.createMenuSection(environment: environment)
        }
    }
    
    private func createMenuSection(
        environment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        configuration.backgroundColor = .clear
        
        let sectionLayout = NSCollectionLayoutSection.list(
            using: configuration,
            layoutEnvironment: environment
        )
        sectionLayout.interGroupSpacing = 10
        return sectionLayout
    }
}

// MARK: - Bind
private extension AccountViewController {
    func bindAction() {
        collectionView.rx.itemSelected
            .withUnretained(self)
            .compactMap { this, indexPath -> Action? in
                let item = this.dataSource?.itemIdentifier(for: indexPath)
                switch item {
                case .logout: return .logoutCellTapped
                case .withdraw:  return .withdrawCellTapped
                default: return nil
                }
            }
            .bind(to: composer.action)
            .disposed(by: disposeBag)
    }
    
    func bindState() {
        composer.$state.observable
            .map(\.profile)
            .distinctUntilChanged()
            .drive(with: self) { this, profile in
                this.applySnapshot(profile: profile)
            }
            .disposed(by: disposeBag)
        
        composer.$state.present(\.$showLogoutAlert)
            .drive(with: self) { this, showLogoutAlert in
                if showLogoutAlert {
                    let alert = SPBottomAlert(
                        message: "로그아웃 하시면, 가장 빠른 내한 소식과 티켓팅 알림을 받을 수 없어요. 로그아웃 하시겠습니까?",
                        buttonTitle: "로그아웃",
                        primaryAction: { [`self` = this] in
                            self.composer.action.accept(.logoutAlertButtonTapped)
                        }
                    )
                    this.present(alert, animated: true)
                } else {
                    this.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        composer.$state.present(\.$showWithdrawAlert)
            .drive(with: self) { this, showWithdrawAlert in
                if showWithdrawAlert {
                    let alert = SPBottomAlert(
                        message: "탈퇴 하시면, 계정과 관련된 모든 정보가 삭제되며 복구할 수 없어요. 탈퇴하시겠습니까?",
                        buttonTitle: "탈퇴하기",
                        primaryAction: { [`self` = this] in
                            self.composer.action.accept(.withdrawAlertButtonTapped)
                        }
                    )
                    this.present(alert, animated: true)
                } else {
                    this.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - DataSource and Snapshot
private extension AccountViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int, CaseIterable {
        case account
    }
    
    enum Item: Hashable {
        case header(ProfileEntity) // "춤추는 고래"와 카카오 로그인 아이콘을 위한 항목
        case logout
        case withdraw
    }
    
    func configureDataSource() {
        // "춤추는 고래" 셀 (SPAccountHeaderCell 사용)
        let headerCellRegistration = UICollectionView.CellRegistration<SPAccountHeaderCell, ProfileEntity> { cell, _, profile in
            cell.configure(profile: profile)
        }
        
        // 메뉴 셀 (SPMenuArrowIconCell 사용)
        let menuCellRegistration = UICollectionView.CellRegistration<SPMenuArrowIconCell, Item> { cell, _, item in
            switch item {
            case .logout:
                cell.registration(
                    title: "로그아웃",
                    icon: .icLogout,
                    style: .h2
                )
            case .withdraw:
                cell.registration(
                    title: "회원 탈퇴",
                    icon: .icProfileDelete,
                    style: .h2
                )
            default: break
            }
        }
        
        dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            switch item {
            case .header(let profile):
                return collectionView.dequeueConfiguredReusableCell(
                    using: headerCellRegistration,
                    for: indexPath,
                    item: profile
                )
            case .logout, .withdraw:
                return collectionView.dequeueConfiguredReusableCell(
                    using: menuCellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        }
    }
    
    func applySnapshot(profile: ProfileEntity) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        
        snapshot.appendItems([
            .header(profile),
            .logout,
            .withdraw
        ], toSection: .account)
        
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

@available(iOS 17.0, *)
#Preview {
    AccountViewController()
}
