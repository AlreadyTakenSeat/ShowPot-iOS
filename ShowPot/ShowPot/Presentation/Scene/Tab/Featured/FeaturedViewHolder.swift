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
    
    private let searchAreaHeight: CGFloat = 66
    
    lazy var alarmRightBarButton = SPButton().then {
        $0.configuration?.baseBackgroundColor = .clear
        $0.setImage(.icAlarmLarge.withTintColor(.gray000), for: .normal)
        $0.snp.makeConstraints {
            $0.size.equalTo(36)
        }
    }
    
    lazy var logoTopView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.layoutMargins = .init(top: 13, left: 17, bottom: 18, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.backgroundColor = .gray700
        
        let logoImageView = UIImageView(image: .logoTitle)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.sizeToFit()
        
        [logoImageView, UIView()].forEach { stackView.addArrangedSubview($0) }
        logoImageView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.width.equalTo(91)
        }
    }
    
    lazy var searchFieldTopView = UIView().then { view in
        lazy var searchField = UIStackView().then { stackView in
            stackView.axis = .horizontal
            stackView.backgroundColor = .gray500
            stackView.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
            stackView.isLayoutMarginsRelativeArrangement = true
        }
        
        lazy var placeholderLabel = SPLabel(KRFont.B1_semibold).then { label in
            label.textColor = .gray300
            label.setText(Strings.homeSearchbarPlaceholder)
        }
        
        lazy var searchIconImageView = UIImageView().then { imageView in
            imageView.image = .icMagnifier.withTintColor(.gray000)
            imageView.contentMode = .scaleAspectFit
        }
        
        [placeholderLabel, searchIconImageView].forEach { searchField.addArrangedSubview($0) }
        
        view.backgroundColor = .gray700
        view.addSubview(searchField)
        searchField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(14)
        }
    }
    
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
        $0.contentInset = .init(top: searchAreaHeight, left: .zero, bottom: 100, right: .zero)
    }
    
}

extension FeaturedViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        [featuredCollectionView, searchFieldTopView, logoTopView].forEach { view.addSubview($0) }
        logoTopView.addArrangedSubview(alarmRightBarButton)
    }
    
    func configureConstraints(for view: UIView) {
        
        logoTopView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
        }
        
        searchFieldTopView.snp.makeConstraints { make in
            make.top.equalTo(logoTopView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(searchAreaHeight)
        }
        
        featuredCollectionView.snp.makeConstraints {
            $0.top.equalTo(logoTopView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        logoTopView.layoutSubviews()
    }
    
}

// MARK: Update constraint for Animation
extension FeaturedViewHolder {
    public func updateSearchFieldConstraint(for view: UIView, isAppear: Bool) {
        if isAppear {
            searchFieldTopView.snp.remakeConstraints { make in
                make.top.equalTo(logoTopView.snp.bottom)
                make.horizontalEdges.equalToSuperview()
                make.height.equalTo(searchAreaHeight)
            }
        } else {
            searchFieldTopView.snp.remakeConstraints { make in
                make.bottom.equalTo(logoTopView.snp.bottom)
                make.horizontalEdges.equalToSuperview()
                make.height.equalTo(searchAreaHeight)
            }
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
