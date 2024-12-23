//
//  FeaturedViewController.swift
//  ShowPot
//
//  Created by Daegeon Choi on 5/25/24.
//

import UIKit

import RxSwift
import RxGesture

final class FeaturedViewController: ViewController {
    
    private let didTappedSubscribeGenreButtonSubject = PublishSubject<Void>()
    private let didTappedSubscribeArtistButtonSubject = PublishSubject<Void>()
    private let didTappedWatchTheFullPerformanceButtonSubject = PublishSubject<Void>()
    
    let viewHolder: FeaturedViewHolder = .init()
    let viewModel: FeaturedViewModel
    
    init(viewModel: FeaturedViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolderConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let headerView = viewHolder.featuredCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: .init(row: 0, section: viewModel.featuredSectionModel.endIndex - 1)) as? FeaturedOnlyTitleHeaderView else { return }
        
        let headerTitle: String
        if let nickName = viewModel.userProfileInfo?.nickName {
            headerTitle = "\(nickName)님을 위한 추천 공연"
        } else {
            headerTitle = Strings.homeNonLoginRecommendedTitle
        }
        headerView.configureUI(with: headerTitle)
    }
    
    override func setupStyles() {
        super.setupStyles()
        viewHolder.featuredCollectionView.delegate = self
        viewHolder.featuredCollectionView.dataSource = self
    }
    
    override func bind() {
        let input = FeaturedViewModel.Input(
            requestFeaturedSectionModel: .just(()),
            didTapSearchField: viewHolder.searchFieldTopView.rx.tapGesture().when(.recognized),
            didTappedSubscribeGenreButton: didTappedSubscribeGenreButtonSubject,
            didTappedSubscribeArtistButton: didTappedSubscribeArtistButtonSubject, 
            didTappedFeaturedCell: viewHolder.featuredCollectionView.rx.itemSelected.asObservable(), 
            didTappedWatchTheFullPerformanceButton: didTappedWatchTheFullPerformanceButtonSubject.asObservable()
        )
        let output = viewModel.transform(input: input)
        output.updateFeaturedLayout
            .emit(with: self) { owner, _ in
                owner.viewHolder.updateCollectionViewLayout(sectionModel: owner.viewModel.featuredSectionModel)
            }
            .disposed(by: disposeBag)
        
        output.showLoginBottomSheet.subscribe(with: self) { owner, _ in
            owner.showLoginBottomSheet()
        }
        .disposed(by: disposeBag)
    }
}

extension FeaturedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.featuredSectionModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = viewModel.featuredSectionModel[section]
        switch type {
        case let .subscribeGenre(model):
            return model.count
        case let .subscribeArtist(model):
            return model.count
        case let .ticketingPerformance(model):
            return model.count
        case let .recommendedPerformance(model):
            return model.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.featuredSectionModel[indexPath.section]
        switch sectionType {
        case let .subscribeGenre(model):
            let cell = collectionView.dequeueReusableCell(FeaturedSubscribeGenreCell.self, for: indexPath) ?? FeaturedSubscribeGenreCell()
            cell.configureUI(subscribeGenreImage: model[indexPath.row].normalImage)
            return cell
        case let .subscribeArtist(model):
            let cell = collectionView.dequeueReusableCell(FeaturedSubscribeArtistCell.self, for: indexPath) ?? FeaturedSubscribeArtistCell()
            cell.configureUI(with: model[indexPath.row])
            return cell
        case let .ticketingPerformance(model):
            let cell = collectionView.dequeueReusableCell(FeaturedPerformanceWithTicketOnSaleSoonCell.self, for: indexPath) ?? FeaturedPerformanceWithTicketOnSaleSoonCell()
            cell.configureUI(with: model[indexPath.row])
            return cell
        case let .recommendedPerformance(model):
            let cell = collectionView.dequeueReusableCell(FeaturedRecommendedPerformanceCell.self, for: indexPath) ?? FeaturedRecommendedPerformanceCell()
            cell.configureUI(with: model[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let type = viewModel.featuredSectionModel[indexPath.section]
        switch type {
        case .subscribeGenre, .subscribeArtist:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FeaturedWithButtonHeaderView.reuseIdentifier, for: indexPath) as? FeaturedWithButtonHeaderView ?? FeaturedWithButtonHeaderView()
            headerView.configureUI(with: .init(headerTitle: type.headerTitle))
            headerView.onTap = { self.handleHeaderButtonTapped(for: type) }
            return headerView
        case .ticketingPerformance, .recommendedPerformance:
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FeaturedOnlyTitleHeaderView.reuseIdentifier, for: indexPath) as? FeaturedOnlyTitleHeaderView ?? FeaturedOnlyTitleHeaderView()
                headerView.configureUI(with: type.headerTitle)
                return headerView
            }
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FeaturedWatchTheFullPerformanceFooterView.reuseIdentifier, for: indexPath) as? FeaturedWatchTheFullPerformanceFooterView ?? FeaturedWatchTheFullPerformanceFooterView()
            footerView.onButtonTap = { self.didTappedWatchTheFullPerformanceButtonSubject.onNext(()) }
            return footerView
        }
    }
    
    private func handleHeaderButtonTapped(for type: FeaturedSectionType) {
        switch type {
        case .subscribeGenre:
            didTappedSubscribeGenreButtonSubject.onNext(())
        case .subscribeArtist:
            didTappedSubscribeArtistButtonSubject.onNext(())
        default:
            return
        }
    }
}

extension FeaturedViewController {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let isTop = scrollView.contentOffset.y <= -scrollView.contentInset.top/2
        let isDragUp = velocity.y < 0
        self.animateTopApperance(isAppear: isTop || isDragUp)
    }
    
    private func animateTopApperance(isAppear: Bool) {
        
        viewHolder.updateSearchFieldConstraint(for: self.view, isAppear: isAppear)
                
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }

    }
}

enum FeaturedSectionType { // TODO: 추후 Usecase로 코드 전환 예정
    case subscribeGenre([GenreType])
    case subscribeArtist([FeaturedSubscribeArtistCellModel])
    case ticketingPerformance([FeaturedPerformanceWithTicketOnSaleSoonCellModel])
    case recommendedPerformance([FeaturedRecommendedPerformanceCellModel])
    
    var headerTitle: String {
        switch self {
        case .subscribeGenre:
            return Strings.homeSubscribeGenreTitle
        case .subscribeArtist:
            return Strings.homeSubscribeArtistTitle
        case .ticketingPerformance:
            return Strings.homeTicketingPerformanceTitle
        case .recommendedPerformance:
            guard let userprofile = UserDefaultsManager.shared.get(objectForkey: .userProfileInfo, type: UserProfileInfo.self) else { return Strings.homeNonLoginRecommendedTitle }
            return "\(userprofile.nickName)님을 위한 추천 공연"
        }
    }
}
