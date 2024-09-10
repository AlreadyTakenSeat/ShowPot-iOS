//
//  MyPageViewHolder.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/28/24.
//

import UIKit
import SnapKit

final class MyPageViewHolder {
    
    lazy var mypageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { [weak self] sec, env -> NSCollectionLayoutSection? in
        guard let self = self else { return nil }
        return self.setupMypageCollectionViewLayoutSection()
    }).then {
        $0.register(MenuCell.self)
        $0.register(MyPageHeaderView.self, of: UICollectionView.elementKindSectionHeader)
        $0.backgroundColor = .gray700
    }
}

extension MyPageViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        view.addSubview(mypageCollectionView)
    }
    
    func configureConstraints(for view: UIView) {
        mypageCollectionView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

extension MyPageViewHolder {
    
    private func setupMypageCollectionViewLayoutSection() -> NSCollectionLayoutSection {
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
}
