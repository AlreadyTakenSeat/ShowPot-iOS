//
//  GenreViewController.swift
//  ShowPot
//
//  Created by 김도형 on 4/2/25.
//

import UIKit

import SnapKit
import RxCompose
import RxSwift
import RxCocoa

final class GenreViewController: UIViewController, Composable {
    // MARK: - Properties
    private let navigationBar = SPNavigationBar(title: "장르 구독하기")
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
    var composer = GenreViewModel()
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
        
        composer.action.accept(.viewDidLoad)
    }
}

// MARK: - Configure View
private extension GenreViewController {
    private func configureUI() {
        view.backgroundColor = .gray700
        
        configureNavigationBar()
        
        configureDescriptionLabel()
        
        configureCollectionView()
        
        configureBottomGradientView()
        
        configureBottomButton()
        
        configureDataSource()
    }
    
    private func configureLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(48)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(16)
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
            // safeAreaLayoutGuide 기준으로 설정, 초기에는 숨김 위치
            bottomButtonBottomConstraint = make.bottom.equalToSuperview().offset(100).constraint
        }
    }
    
    private func configureNavigationBar() {
        view.addSubview(navigationBar)
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.text = "관심 장르의 내한공연 알람을 보내드려요"
        descriptionLabel.font = KRFont.H2.font
        descriptionLabel.textColor = .gray300
        view.addSubview(descriptionLabel)
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        view.addSubview(collectionView)
    }
    
    private func configureBottomGradientView() {
        view.addSubview(bottomGradientView)
    }
    
    private func configureBottomButton() {
        bottomButton.ctaButton.isEnabled = true // 버튼 자체는 항상 활성화 상태로 유지
        bottomButton.isHidden = true // 초기에는 숨김
        view.addSubview(bottomButton)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            return self?.createGenreSection(environment: environment)
        }
    }
    
    private func createGenreSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        // 아이템 크기 정의
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(140),
            heightDimension: .absolute(140)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // 전체 아이템 개수 (동적으로 변한다고 가정)
        let totalItemCount = self.dataSource?.snapshot().numberOfItems(inSection: .genres) ?? 0

        guard totalItemCount > 0 else {
            let section = NSCollectionLayoutSection(
                group: NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(140)
                    ),
                    subitems: [item]
                )
            )
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 16,
                bottom: 16 + 140,
                trailing: 16
            )
            return section
        }
        
        // 왼쪽 열 그룹
        let leftItemCount = totalItemCount / 2 + totalItemCount % 2 // 홀수일 때 하나 더
        let leftGroupHeight = CGFloat(leftItemCount) * 140 + CGFloat(leftItemCount - 1) * 40 // 아이템 높이 + 간격
        let leftGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 2),
            heightDimension: .absolute(leftGroupHeight) // 명시적 높이
        )
        let leftGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: leftGroupSize,
            repeatingSubitem: item,
            count: leftItemCount
        )
        leftGroup.interItemSpacing = .fixed(40)

        // 오른쪽 열 그룹: 상단 여백 90 포함
        let rightItemCount = totalItemCount / 2
        let rightContentHeight = CGFloat(rightItemCount) * 140 + CGFloat(rightItemCount - 1) * 40 // 콘텐츠 높이
        let rightGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 2),
            heightDimension: .absolute(rightContentHeight + 90) // 상단 여백 90 추가
        )
        let rightGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: rightGroupSize,
            repeatingSubitem: item,
            count: rightItemCount
        )
        rightGroup.interItemSpacing = .fixed(40)
        rightGroup.contentInsets = NSDirectionalEdgeInsets(
            top: 90, // 상단 여백으로 오프셋
            leading: 0,
            bottom: 0,
            trailing: 0
        )

        // 컨테이너 그룹: 최대 높이로 설정
        let containerGroupHeight = max(leftGroupHeight, rightContentHeight + 90)
        let containerGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(containerGroupHeight) // 명시적 높이
        )
        let containerGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: containerGroupSize,
            subitems: [leftGroup, rightGroup]
        )
        containerGroup.interItemSpacing = .fixed(14)

        // 섹션 설정
        let padding = (environment.container.contentSize.width - 294) / 2
        let section = NSCollectionLayoutSection(group: containerGroup)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: padding,
            bottom: 16 + 140, // 하단 여백
            trailing: padding
        )

        return section
    }
    
    // 버튼 애니메이션 메서드
    private func updateBottomButtonVisibility(showSubscribeButton: Bool) {
        let isButtonVisible = !bottomButton.isHidden
        if showSubscribeButton == isButtonVisible { return }
        
        if showSubscribeButton {
            bottomButton.isHidden = false
            bottomButtonBottomConstraint?.update(offset: 0)
            bottomButton.alpha = 0
            UIView.springAnimate { [weak self] in
                self?.bottomButton.alpha = 1
                self?.view.layoutIfNeeded()
            }
        } else {
            bottomButtonBottomConstraint?.update(offset: 100)
            UIView.springAnimate { [weak self] in
                self?.bottomButton.alpha = 0
                self?.view.layoutIfNeeded()
            } completion: { [weak self] _ in
                self?.bottomButton.isHidden = true
            }
        }
    }
}

// MARK: - DataSource and Snapshot
private extension GenreViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int, CaseIterable {
        case genres
    }
    
    enum Item: Hashable {
        case genre(GenreEntity, Set<GenreEntity>)
    }
    
    func configureDataSource() {
        let genreCellRegistration = UICollectionView.CellRegistration<GenreCell, GenreEntity> { cell, _, genre in
        }
        
        dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            switch item {
            case let .genre(genre, selectedGenres):
                let cell = collectionView.dequeueConfiguredReusableCell(
                    using: genreCellRegistration,
                    for: indexPath,
                    item: genre
                )
                let isSelected = selectedGenres.contains(genre)
                cell.registration(genre: genre, isSelected: isSelected)
                return cell
            }
        }
    }
    
    func applySnapshot(genres: [GenreEntity], selectedGenres: Set<GenreEntity>) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(genres.map { .genre($0, selectedGenres) }, toSection: .genres)
        dataSource?.apply(snapshot, animatingDifferences: true)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - Binding
private extension GenreViewController {
    func bindAction() {
        collectionView.rx.itemSelected
            .map { Action.collectionViewItemSelected($0.item) }
            .bind(to: composer.action)
            .disposed(by: disposeBag)
        
        navigationBar.rx.backButtonTap
            .bind(to: rx.popViewController(animated: true))
            .disposed(by: disposeBag)
        
        bottomButton.ctaButton.rx.tap
            .map { Action.bottomButtonTapped }
            .bind(to: composer.action)
            .disposed(by: disposeBag)
    }
    
    func bindState() {
        Driver.combineLatest(
            composer.$state.observable.map(\.genres.data),
            composer.$state.observable.map(\.selectedGenres)
        )
        .drive(with: self) { this, value in
            let (genres, selectedGenres) = value
            this.applySnapshot(genres: genres, selectedGenres: selectedGenres)
        }
        .disposed(by: disposeBag)
        
        composer.$state.present(\.$showSubscribeButton)
            .drive(with: self) { this, showSubscribeButton in
                this.updateBottomButtonVisibility(
                    showSubscribeButton: showSubscribeButton
                )
            }
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
        
        composer.$state.present(\.$selectedGenre)
            .compactMap(\.self)
            .drive(with: self) { this, genre in
                let bottomSheet = SPBottomSheet(
                    titleKey: genre.name?.title,
                    message: "구독을 취소하시겠습니까?",
                    buttonTitle: "구독 취소하기"
                )
                bottomSheet.button.rx.tap
                    .map { Action.unsubscribeAlertButtonTapped }
                    .bind(to: this.composer.action)
                    .disposed(by: bottomSheet.disposeBag)
                this.present(bottomSheet, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

@available(iOS 17.0, *)
#Preview {
    GenreViewController()
}
