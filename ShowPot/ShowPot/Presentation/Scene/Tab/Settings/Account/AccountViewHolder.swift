//
//  AccountViewHolder.swift
//  ShowPot
//
//  Created by 이건준 on 8/29/24.
//

import UIKit

import SnapKit
import Then

final class AccountViewHolder {
    
    lazy var accountCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { [weak self] sec, env -> NSCollectionLayoutSection? in
        guard let self = self else { return nil }
        return self.setupAccountCollectionViewLayoutSection()
    }).then {
        $0.contentInset = .init(top: 16, left: .zero, bottom: .zero, right: .zero)
        $0.register(MenuCell.self)
        $0.register(MyPageHeaderView.self, of: UICollectionView.elementKindSectionHeader)
        $0.backgroundColor = .gray700
    }
}

extension AccountViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        view.addSubview(accountCollectionView)
    }
    
    func configureConstraints(for view: UIView) {
        accountCollectionView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

extension AccountViewHolder {
    private func setupAccountCollectionViewLayoutSection() -> NSCollectionLayoutSection {
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
                heightDimension: .estimated(47)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 25, leading: .zero, bottom: .zero, trailing: .zero)
        return section
    }
}
