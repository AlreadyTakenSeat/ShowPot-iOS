//
//  ArtistViewController.swift
//  ShowPot
//
//  Created by 김도형 on 4/2/25.
//

import UIKit

import RxCompose
import RxSwift
import RxCocoa
import SnapKit

final class ArtistViewController: UIViewController, Composable {
    // MARK: - Properties
    private let navigationBar = SPNavigationBar(title: "아티스트 구독하기")
    private let descriptionLabel = UILabel()
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout()
    )
    private let bottomButton = SPCTABottomButton(title: "구독하기", style: .plain)
    private let bottomGradientView = SPGradientView(
        colors: [
            UIColor(red: 0.09, green: 0.09, blue: 0.106, alpha: 0),
            UIColor(red: 0.09, green: 0.09, blue: 0.106, alpha: 1)
        ],
        startPoint: CGPoint(x: 0, y: 0),
        endPoint: CGPoint(x: 0, y: 1),
        locations: [0, 1]
    )
    
    private var dataSource: DataSource?
    
    @Compose
    var composer = ArtistViewModel()
    var disposeBag = DisposeBag()
    
    // 버튼의 제약 조건을 동적으로 변경하기 위해 저장
    private var bottomButtonBottomConstraint: Constraint?
    
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
        
        bottomGradientView.layoutIfNeeded()
    }
}

// MARK: - Configure View
private extension ArtistViewController {
    func configureUI() {
        view.backgroundColor = .gray700
        
        configureNavigationBar()
        
        configureDescriptionLabel()
        
        configureCollectionView()
        
        configureBottomGradientView()
        
        configureBottomButton()
        
        configureDataSource()
    }
    
    func configureLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        bottomGradientView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(56)
        }
        
        bottomButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            // 동적으로 변경할 제약 조건 저장
            bottomButtonBottomConstraint = make.bottom.equalToSuperview().offset(100).constraint
        }
    }
    
    func configureNavigationBar() {
        view.addSubview(navigationBar)
    }
    
    func configureDescriptionLabel() {
        descriptionLabel.text = "관심 있는 아티스트를 선택해주세요"
        descriptionLabel.font = KRFont.H2.font
        descriptionLabel.textColor = .gray300
        view.addSubview(descriptionLabel)
    }
    
    func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        view.addSubview(collectionView)
    }
    
    func configureBottomGradientView() {
        view.addSubview(bottomGradientView)
    }
    
    func configureBottomButton() {
        bottomButton.ctaButton.isEnabled = true // 버튼 자체는 항상 활성화 상태로 유지
        bottomButton.isHidden = true // 초기에는 숨김
        view.addSubview(bottomButton)
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
        group.interItemSpacing = .fixed(18)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 18
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 16 + 70, // 버튼 높이(약 50) + 여백(20)을 고려하여 하단 여백 추가
            trailing: 16
        )
        
        return section
    }
    
    // 버튼 애니메이션 메서드
    func updateBottomButtonVisibility(showSubscribeButton: Bool) {
        let isButtonVisible = !bottomButton.isHidden
        if showSubscribeButton == isButtonVisible { return }
        
        if showSubscribeButton {
            bottomButton.isHidden = false
            bottomButtonBottomConstraint?.update(offset: 0)
            bottomButton.alpha = 0
            UIView.springAnimate { [weak self] in
                self?.collectionView.allowsSelection = false
                self?.bottomButton.alpha = 1
                self?.view.layoutIfNeeded()
            } completion: { [weak self] _ in
                self?.collectionView.allowsSelection = true
            }
        } else {
            bottomButtonBottomConstraint?.update(offset: 100)
            UIView.springAnimate { [weak self] in
                self?.collectionView.allowsSelection = false
                self?.bottomButton.alpha = 0
                self?.view.layoutIfNeeded()
            } completion: { [weak self] _ in
                self?.bottomButton.isHidden = true
                self?.collectionView.allowsSelection = true
            }
        }
    }
}

// MARK: - DataSource and Snapshot
private extension ArtistViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int, CaseIterable {
        case artists
    }
    
    enum Item: Hashable {
        case artist(ArtistEntity, Bool)
    }
    
    func configureDataSource() {
        let artistCellRegistration = UICollectionView.CellRegistration<ArtistCell, ArtistEntity> { cell, _, artist in
            cell.layoutIfNeeded()
        }
        
        dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            switch item {
            case let .artist(artist, isSelected):
                let cell = collectionView.dequeueConfiguredReusableCell(
                    using: artistCellRegistration,
                    for: indexPath,
                    item: artist
                )
                cell.registration(
                    artist: artist,
                    isDelete: false,
                    isSelected: isSelected
                )
                return cell
            }
        }
    }
    
    func applySnapshot(artists: [ArtistEntity], selectedArtists: Set<ArtistEntity>) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(
            artists.map { .artist($0, selectedArtists.contains($0)) },
            toSection: .artists
        )
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Binding
private extension ArtistViewController {
    func bindAction() {
        collectionView.rx.itemSelected
            .map { Action.collectionViewItemSelected($0.item) }
            .bind(to: composer.action)
            .disposed(by: disposeBag)
        
        navigationBar.rx.backButtonTap
            .bind(to: rx.popViewController(animated: true))
            .disposed(by: disposeBag)
    }
    
    func bindState() {
        Driver.combineLatest(
            composer.$state.observable.map(\.artists),
            composer.$state.observable.map(\.selectedArtists)
        )
        .drive(with: self) { this, value in
            let (artists, selectedArtists) = value
            this.applySnapshot(
                artists: artists,
                selectedArtists: selectedArtists
            )
        }
        .disposed(by: disposeBag)
        
        composer.$state.present(\.$showSubscribeButton)
            .drive(with: self) { this, showSubscribeButton in
                this.updateBottomButtonVisibility(
                    showSubscribeButton: showSubscribeButton
                )
            }
            .disposed(by: disposeBag)
    }
}

@available(iOS 17.0, *)
#Preview {
    ArtistViewController()
}
