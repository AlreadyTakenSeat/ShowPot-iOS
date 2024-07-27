//
//  FeaturedViewHolder.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/28/24.
//

import UIKit
import SnapKit
import Then

final class FeaturedViewHolder {
    
    lazy var featuredCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.register(FeaturedSubscribeGenreCell.self)
        $0.register(FeaturedSubscribeArtistCell.self)
        $0.register(FeaturedPerformanceWithTicketOnSaleSoonCell.self)
        $0.register(FeaturedRecommendedPerformanceCell.self)
        $0.register(FeaturedWithButtonHeaderView.self, of: UICollectionView.elementKindSectionHeader)
        $0.register(FeaturedOnlyTitleHeaderView.self, of: UICollectionView.elementKindSectionHeader)
        $0.register(FeaturedWatchTheFullPerformanceFooterView.self, of: UICollectionView.elementKindSectionFooter)
        $0.backgroundColor = .gray700
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
        $0.contentInset = .init(top: .zero, left: .zero, bottom: 100, right: .zero)
    }
    
}

extension FeaturedViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        view.addSubview(featuredCollectionView)
    }
    
    func configureConstraints(for view: UIView) {
        featuredCollectionView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
}

// MARK: - Layout Function For UICompositionalLayout

extension FeaturedViewHolder {
    
    /// UICollectionView의 레이아웃을 주어진 섹션모델에 따라 업데이트해주는 함수
    func updateCollectionViewLayout(sectionModel: [FeaturedSectionType]) {
        featuredCollectionView.setCollectionViewLayout(UICollectionViewCompositionalLayout { [weak self] sec, env -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            let type = sectionModel[sec]
            return self.setupFeatureCollectionViewLayoutSection(type: type)
        }, animated: true)
    }
    
    /// 섹션타입에 따라 UICompositionalLayout을 위한 NSCollectionLayoutSection을 리턴하는 함수
    private func setupFeatureCollectionViewLayoutSection(type: FeaturedSectionType) -> NSCollectionLayoutSection {
        switch type {
        case .subscribeGenre:
            return subscribeGenreLayoutSection()
        case .subscribeArtist:
            return subscribeArtistLayoutSection()
        case .ticketingPerformance:
            return ticketingPerformanceLayoutSection()
        case .recommendedPerformance:
            return recommendedPerformanceLayoutSection()
        }
    }
    
    private func subscribeArtistLayoutSection() -> NSCollectionLayoutSection {
        let groupLayoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(100),
            heightDimension: .absolute(100)
        )
        
        let itemLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(44)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.contentInsets = .init(top: .zero, leading: .zero, bottom: .zero, trailing: -7)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupLayoutSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 8, leading: 16, bottom: 36, trailing: 16)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        return section
    }
    
    private func subscribeGenreLayoutSection() -> NSCollectionLayoutSection {
        let groupLayoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(100),
            heightDimension: .absolute(100)
        )
        
        let itemLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(44)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.contentInsets = .init(top: .zero, leading: .zero, bottom: .zero, trailing: -7)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupLayoutSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 8, leading: 16, bottom: 36, trailing: 16)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        return section
    }
    
    private func ticketingPerformanceLayoutSection() -> NSCollectionLayoutSection {
        let groupLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(106)
        )
        
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(106)
            )
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(44)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(42 + 38) // Footer높이 + Footer, 추천헤더 간격
            ),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupLayoutSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header, footer]
        section.contentInsets = .init(top: 6, leading: 16, bottom: 10, trailing: 16)
        section.interGroupSpacing = 10
        return section
    }
    
    private func recommendedPerformanceLayoutSection() -> NSCollectionLayoutSection {
        let groupLayoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(192),
            heightDimension: .absolute(309)
        )
        
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(44)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupLayoutSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 18
        section.contentInsets = .init(top: 6, leading: 16, bottom: .zero, trailing: 16)
        return section
    }
}
