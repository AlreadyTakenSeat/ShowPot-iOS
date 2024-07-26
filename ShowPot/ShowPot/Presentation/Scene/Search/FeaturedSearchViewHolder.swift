//
//  FeaturedSearchViewHolder.swift
//  ShowPot
//
//  Created by 이건준 on 7/22/24.
//

import UIKit
import SnapKit

final class FeaturedSearchViewHolder {
    
    let backButton = UIButton().then {
        $0.setImage(.icArrowLeft.withTintColor(.gray300), for: .normal)
    }
    
    let featuredSearchTextField = FeaturedSearchTextField()
    
    private let recentSearchFlowLayout = LeftAlignedCollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = 8
        $0.minimumLineSpacing = 8
        $0.sectionInset = .init(top: 8, left: 16, bottom: .zero, right: 16)
        $0.scrollDirection = .vertical
    }
    
    lazy var recentSearchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: recentSearchFlowLayout).then {
        $0.register(FeaturedRecentSearchCell.self)
        $0.register(FeaturedRecentSearchHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FeaturedRecentSearchHeaderView.identifier)
        $0.backgroundColor = .gray700
        $0.alwaysBounceVertical = true
    }
    
    private lazy var searchResultFlowLayout = UICollectionViewCompositionalLayout { [weak self] sec, env -> NSCollectionLayoutSection? in
        guard let self = self else { return nil }
        let type = FeaturedSearchViewModel.SearchResultSection.allCases[sec]
        return self.setupSearchQueryResultCollectionViewLayoutSection(type: type)
    }
    
    lazy var searchQueryResultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: searchResultFlowLayout).then {
        $0.register(FeaturedSubscribeArtistCell.self)
        $0.register(PerformanceInfoCollectionViewCell.self)
        $0.register(FeaturedOnlyTitleHeaderView.self, of: UICollectionView.elementKindSectionHeader)
        $0.backgroundColor = .gray700
        $0.alwaysBounceVertical = true
    }
    
    let emptyLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.font = KRFont.B1_semibold
        $0.textColor = .gray400
        $0.textAlignment = .center
        $0.setAttributedText(font: KRFont.self, string: "검색 기록이 없어요")
    }
    
    lazy var indicatorView = UIActivityIndicatorView().then {
        $0.style = .large
    }
}

extension FeaturedSearchViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        [backButton, featuredSearchTextField, recentSearchCollectionView, searchQueryResultCollectionView, indicatorView].forEach { view.addSubview($0) }
        recentSearchCollectionView.addSubview(emptyLabel)
    }
    
    func configureConstraints(for view: UIView) {
        
        featuredSearchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(52)
        }
        
        backButton.snp.makeConstraints {
            $0.size.equalTo(36)
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalTo(featuredSearchTextField.snp.leading).offset(-8)
            $0.centerY.equalTo(featuredSearchTextField)
        }
        
        recentSearchCollectionView.snp.makeConstraints {
            $0.top.equalTo(featuredSearchTextField.snp.bottom).offset(12)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(44 + 44) // 헤더뷰 높이 + 헤더뷰~emptyLabel사이간격
            $0.centerX.equalToSuperview()
        }
        
        searchQueryResultCollectionView.snp.makeConstraints {
            $0.top.equalTo(featuredSearchTextField.snp.bottom).offset(12)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
        
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension FeaturedSearchViewHolder {
    
    private func setupSearchQueryResultCollectionViewLayoutSection(type: FeaturedSearchViewModel.SearchResultSection) -> NSCollectionLayoutSection {
        switch type {
        case .artistList:
            return searchResultArtistLayoutSection()
        case .performanceInfo:
            return searchResultPerformanceLayoutSection()
        }
    }
    
    private func searchResultArtistLayoutSection() -> NSCollectionLayoutSection {
        let groupLayoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(100),
            heightDimension: .absolute(129)
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
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupLayoutSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 14, leading: 16, bottom: 36, trailing: 16)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 12
        return section
    }
    
    private func searchResultPerformanceLayoutSection() -> NSCollectionLayoutSection {
        let groupLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(80)
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
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupLayoutSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 6, leading: 16, bottom: .zero, trailing: 16)
        section.boundarySupplementaryItems = [header]
        section.interGroupSpacing = 16
        return section
    }
}
