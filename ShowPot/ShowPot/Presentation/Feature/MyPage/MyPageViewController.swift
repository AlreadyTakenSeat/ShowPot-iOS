//
//  MyPageViewController.swift
//  ShowPot
//
//  Created by 김도형 on 4/6/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxCompose
import RxGesture
import SnapKit

final class MyPageViewController: UIViewController, Composable {
    // MARK: - Properties
    private let pageTitleLabel = UILabel() // "마이" 타이틀 라벨 추가
    private let titleLabel = UILabel()
    private let settingButton = UIButton()
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout()
    )
    private var dataSource: DataSource?
    
    @Compose
    var composer = MyPageViewModel()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        composer.action.accept(.viewDidAppear)
    }
}

// MARK: - Configure View
private extension MyPageViewController {
    private func configureUI() {
        view.backgroundColor = .gray700
        
        configurePageTitleLabel() // "마이" 타이틀 라벨 설정
        
        configureTitleLabel()
        
        configureSettingButton()
        
        configureCollectionView()
        
        configureDataSource()
    }
    
    private func configureLayout() {
        pageTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.leading.equalToSuperview().inset(16)
        }
        
        settingButton.snp.makeConstraints { make in
            make.centerY.equalTo(pageTitleLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(pageTitleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(40)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configurePageTitleLabel() {
        pageTitleLabel.attributedText = NSAttributedString(
            "마이",
            fontType: KRFont.H1,
            multiline: true
        )
        .setForegroundColor(color: .gray300)
        view.addSubview(pageTitleLabel)
    }
    
    private func configureTitleLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.isUserInteractionEnabled = true // 탭 제스처를 위해 활성화
        view.addSubview(titleLabel)
    }
    
    private func configureSettingButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .icSetting
            .resized(to: CGSize(width: 36, height: 36))
            .withTintColor(.gray400)
        configuration.contentInsets = .zero
        settingButton.configuration = configuration
        view.addSubview(settingButton)
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
    
    private func createMenuSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        configuration.backgroundColor = .clear
        
        let section = NSCollectionLayoutSection.list(
            using: configuration,
            layoutEnvironment: environment
        )
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        // Divider 추가
        let dividerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(8)
        )
        let divider = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: dividerSize,
            elementKind: "divider",
            alignment: .top
        )
        section.boundarySupplementaryItems = [divider]
        
        return section
    }
}

// MARK: - Bind
private extension MyPageViewController {
    func bindAction() {
        settingButton.rx.tap
            .map { SettingViewController() }
            .bind(to: rx.pushViewController(animated: true))
            .disposed(by: disposeBag)
        
        // UILabel의 탭 제스처를 Rx로 바인딩
        titleLabel.rx.tapGesture()
            .filter { $0.state == .recognized } // 제스처 상태가 recognized일 때만 처리
            .flatMapLatest { [weak self] (gesture: UITapGestureRecognizer) -> Observable<Bool> in
                guard let self = self else { return .just(false) }
                let point = gesture.location(in: self.titleLabel)
                if let index = self.titleLabel.indexOfAttributedTextCharacter(at: point),
                   let attributedText = self.titleLabel.attributedText {
                    let fullText = attributedText.string
                    let loginRange = (fullText as NSString).range(of: "로그인")
                    return .just(NSLocationInRange(index, loginRange))
                }
                return .just(false)
            }
            .filter { $0 } // "로그인" 텍스트가 탭된 경우만 처리
            .map { _ in LoginViewController() }
            .bind(to: rx.pushViewController(animated: true))
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .withUnretained(self)
            .compactMap { this, indexPath -> UIViewController? in
                let item = this.dataSource?.itemIdentifier(for: indexPath)
                switch item {
                case .subscribedArtists: return ArtistViewController()
                case .subscribedGenres: return GenreViewController()
                default: return nil
                }
            }
            .bind(to: rx.pushViewController(animated: true))
            .disposed(by: disposeBag)
    }
    
    func bindState() {
        composer.$state.observable.map(\.nickname)
            .drive(with: self) { this, nickname in
                var nsStr: NSAttributedString
                
                if let nickname {
                    nsStr = NSAttributedString(
                        "\(nickname)님,\n안녕하세요!",
                        fontType: KRFont.H0,
                        multiline: true
                    )
                    nsStr = nsStr.setForegroundColor(color: .gray100)
                } else {
                    nsStr = NSAttributedString(
                        "로그인 후 다채로운\n내한공연을 만나보세요.",
                        fontType: KRFont.H0,
                        multiline: true
                    )
                    
                    nsStr = nsStr
                        .setForegroundColor(color: .gray100) // 전체 텍스트 색상 설정
                        .setUnderline(to: "로그인")
                        .addAttributes([.foregroundColor: UIColor.gray000], at: "로그인") // "로그인" 텍스트 색상 설정
                }
                
                this.titleLabel.attributedText = nsStr
            }
            .disposed(by: disposeBag)
        
        Driver.zip(
            composer.$state.observable.map(\.subscribedArtistsCount),
            composer.$state.observable.map(\.subscribedGenresCount)
        )
        .drive(with: self) { this, value in
            let (artistsCount, genresCount) = value
            this.applySnapshot(
                artistsCount: artistsCount,
                genresCount: genresCount
            )
        }
        .disposed(by: disposeBag)
    }
}

// MARK: - DataSource and Snapshot
private extension MyPageViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int, CaseIterable {
        case subscription
    }
    
    enum Item: Hashable {
        case subscribedArtists(Int)
        case subscribedGenres(Int)
    }
    
    func configureDataSource() {
        let menuCellRegistration = UICollectionView.CellRegistration<SPMenuArrowIconCell, Item> { cell, _, item in
            switch item {
            case .subscribedArtists(let count):
                cell.registration(
                    title: "구독한 아티스트",
                    count: count,
                    icon: .icArtist
                )
            case .subscribedGenres(let count):
                cell.registration(
                    title: "구독한 장르",
                    count: count,
                    icon: .icGenre
                )
            }
        }
        
        let dividerRegistration = UICollectionView.SupplementaryRegistration<SPDividerReusableView>(
            elementKind: "divider"
        ) { divider, _, _ in
            
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
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: dividerRegistration,
                for: indexPath
            )
        }
    }
    
    func applySnapshot(artistsCount: Int, genresCount: Int) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        
        snapshot.appendItems([
            .subscribedArtists(artistsCount),
            .subscribedGenres(genresCount)
        ], toSection: .subscription)
        
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

@available(iOS 17.0, *)
#Preview {
    MyPageViewController()
}
