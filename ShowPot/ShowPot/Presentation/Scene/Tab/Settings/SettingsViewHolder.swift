//
//  SettingsViewHolder.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/28/24.
//

import UIKit
import SnapKit

final class SettingsViewHolder {
    
    lazy var mypageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { [weak self] sec, env -> NSCollectionLayoutSection? in
        guard let self = self else { return nil }
        return self.setupMypageCollectionViewLayoutSection(type: MypageSectionType.allCases[sec])
    }).then {
        $0.register(MenuCell.self)
        $0.register(PerformanceInfoCollectionViewCell.self)
        $0.register(MyPageHeaderView.self, of: UICollectionView.elementKindSectionHeader)
        $0.backgroundColor = .gray700
    }
}

extension SettingsViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        view.addSubview(mypageCollectionView)
    }
    
    func configureConstraints(for view: UIView) {
        mypageCollectionView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

extension SettingsViewHolder {
    
    func updateCollectionViewLayout(sectionModel: [MypageSectionType]) {
        mypageCollectionView.setCollectionViewLayout(UICollectionViewCompositionalLayout { [weak self] sec, env -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            let type = sectionModel[sec]
            return self.setupMypageCollectionViewLayoutSection(type: type)
        }, animated: true)
    }
    
    private func setupMypageCollectionViewLayoutSection(type: MypageSectionType) -> NSCollectionLayoutSection {
        switch type {
        case .menu:
            return menuLayoutSection()
        case .recentShow:
            return recentShowLayoutSection()
        }
    }
    
    private func menuLayoutSection() -> NSCollectionLayoutSection {
        let groupLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(44)
        )
        
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupLayoutSize,
            subitems: [item]
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(113 + 8)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 12, leading: .zero, bottom: 18, trailing: .zero)
        return section
    }
    
    private func recentShowLayoutSection() -> NSCollectionLayoutSection {
        let groupLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(80)
        )
        
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupLayoutSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = .init(top: .zero, leading: 16, bottom: .zero, trailing: 16)
        return section
    }
}

enum MypageSectionType: CaseIterable {
    case menu
    case recentShow
}
