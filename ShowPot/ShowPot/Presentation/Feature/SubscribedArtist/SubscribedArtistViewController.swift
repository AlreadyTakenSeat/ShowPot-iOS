//
//  SubscribedArtistViewController.swift
//  ShowPot
//
//  Created by 김도형 on 4/19/25.
//

import UIKit

import RxCompose
import RxSwift
import RxCocoa
import SnapKit

final class SubscribedArtistViewController: UIViewController, Composable {
    // MARK: - Properties
    private let navigationBar = SPNavigationBar(title: "구독한 아티스트")
    private let emptyView = UIView()
    private let emptyImageView = UIImageView()
    private let emptyLabel = UILabel()
    private let subscribeButton = SPCTAButton(
        title: "아티스트 구독 하러가기",
        style: .secondary
    )
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout()
    )
    private let loadingIndicator = SPLoadingIndicator()
    
    private var dataSource: DataSource?
    
    @Compose
    var composer = SubscribedArtistViewModel()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        composer.action.accept(.viewDidAppear)
    }
}

// MARK: - Configure View
private extension SubscribedArtistViewController {
    func configureUI() {
        view.backgroundColor = .gray700
        
        configureNavigationBar()
        
        configureEmptyView()
        
        configureCollectionView()
        
        configureDataSource()
        
        view.addSubview(loadingIndicator)
    }
    
    func configureLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(72)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(250) // 이미지 크기 추정
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        subscribeButton.snp.makeConstraints { make in
            make.top.equalTo(emptyLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(40)
        }
    }
    
    func configureNavigationBar() {
        navigationBar.setTitleColor(.gray300)
        view.addSubview(navigationBar)
    }
    
    func configureEmptyView() {
        emptyView.backgroundColor = .clear
        emptyView.isHidden = true
        
        emptyImageView.contentMode = .scaleAspectFit
        emptyImageView.image = .interestShowEmpty // 프로젝트에 해당 이미지가 있다고 가정
        emptyView.addSubview(emptyImageView)
        
        emptyLabel.numberOfLines = 0
        emptyLabel.attributedText = NSAttributedString(
            "구독한\n아티스트가 없어요",
            fontType: KRFont.H0,
            multiline: true
        )
        .setParagraphStyle(alignment: .center)
        .setForegroundColor(color: .gray400)
        emptyView.addSubview(emptyLabel)
        
        emptyView.addSubview(subscribeButton)
        
        view.addSubview(emptyView)
    }
    
    func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.isHidden = true
        view.addSubview(collectionView)
    }
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            return self?.createArtistSection()
        }
    }
    
    func createArtistSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 3),
            heightDimension: .estimated(129) // ArtistCell의 높이 (이미지 100 + 이름 라벨 29)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(129)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(20)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 24
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 24,
            leading: 24,
            bottom: 24,
            trailing: 24
        )
        
        return section
    }
    
    // 뷰 전환 메서드
    func updateViewVisibility(hasArtists: Bool) {
        emptyView.isHidden = hasArtists
        collectionView.isHidden = !hasArtists
    }
}

// MARK: - DataSource and Snapshot
private extension SubscribedArtistViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int, CaseIterable {
        case artists
    }
    
    enum Item: Hashable {
        case artist(ArtistEntity)
    }
    
    func configureDataSource() {
        let artistCellRegistration = UICollectionView.CellRegistration<ArtistCell, ArtistEntity> { [weak self] cell, indexPath, artist in
            guard let `self` else { return }
            cell.registration(
                artist: artist,
                isDelete: true
            )
            
            cell.deleteButton.rx.tap
                .map { Action.artistDeleteButtonTapped(artist) }
                .bind(to: composer.action)
                .disposed(by: cell.disposeBag)
            
            cell.layoutIfNeeded()
        }
        
        dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            switch item {
            case let .artist(artist):
                let cell = collectionView.dequeueConfiguredReusableCell(
                    using: artistCellRegistration,
                    for: indexPath,
                    item: artist
                )
                return cell
            }
        }
    }
    
    func applySnapshot(artists: [ArtistEntity]) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(
            artists.map { .artist($0) },
            toSection: .artists
        )
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Binding
private extension SubscribedArtistViewController {
    func bindAction() {
        navigationBar.rx.backButtonTap
            .bind(to: rx.popViewController(animated: true))
            .disposed(by: disposeBag)
        
        subscribeButton.rx.tap
            .map { Action.subscribeButtonTapped }
            .bind(to: composer.action)
            .disposed(by: disposeBag)
    }
    
    func bindState() {
        composer.$state.observable.map(\.artists.data)
            .distinctUntilChanged()
            .drive(with: self) { this, artists in
                this.updateViewVisibility(hasArtists: !artists.isEmpty)
                guard !artists.isEmpty else { return }
                this.applySnapshot(artists: artists)
            }
            .disposed(by: disposeBag)
        
        composer.$state.present(\.$artistViewModel)
            .compactMap(\.self)
            .map { ArtistViewController(viewModel: $0) }
            .drive(rx.pushViewController(animated: true))
            .disposed(by: disposeBag)
        
        composer.$state.present(\.$loginMessage)
            .compactMap(\.self)
            .drive(with: self) { this, message in
                let bottomSheet = SPBottomSheet(
                    message: message,
                    buttonTitle: "3초만에 로그인하기"
                )
                bottomSheet.button.rx.tap
                    .map { LoginViewController() }
                    .bind(to: this.rx.pushViewController(animated: true))
                    .disposed(by: bottomSheet.disposeBag)
                this.present(bottomSheet, animated: true)
            }
            .disposed(by: disposeBag)
        
        composer.$state.present(\.$isLoading)
            .distinctUntilChanged()
            .drive(loadingIndicator.rx.animating)
            .disposed(by: disposeBag)
    }
}

@available(iOS 17.0, *)
#Preview {
    SubscribedArtistViewController()
}
