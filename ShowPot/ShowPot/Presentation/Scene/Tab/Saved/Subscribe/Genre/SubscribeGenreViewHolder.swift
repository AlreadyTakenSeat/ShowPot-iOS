//
//  GenreSelectViewHolder.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/4/24.
//

import UIKit
import SnapKit
import Then

final class SubscribeGenreViewHolder {
    
    lazy var descriptionLabel = SPLabel(KRFont.H2).then { label in
        label.textColor = .gray300
        label.setText(Strings.subscribeGenreDescription)
    }
    
    lazy var genreCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: genreGridLayout()
    ).then { collection in
        collection.register(GenreCollectionViewCell.self)
        collection.backgroundColor = .clear
        collection.alwaysBounceVertical = true
        collection.allowsMultipleSelection = true
    }
    
    lazy var gradientView = GradientView(
        colors: [
            .gray700.withAlphaComponent(0.0),
            .gray700.withAlphaComponent(1.0)
        ],
        startPoint: .init(x: 0.5, y: 0.0),
        endPoint: .init(x: 0.5, y: 1.0)
    )

}

extension SubscribeGenreViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        [descriptionLabel, genreCollectionView, gradientView].forEach { view.addSubview($0) }
    }
    
    func configureConstraints(for view: UIView) {
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(27)
        }
        
        genreCollectionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}

extension SubscribeGenreViewHolder {
    private func genreGridLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let elementSize = NSCollectionLayoutSize(
                widthDimension: .absolute(140),
                heightDimension: .absolute(140)
            )
            
            let leftItem = NSCollectionLayoutItem(layoutSize: elementSize)
            let rightItem = NSCollectionLayoutItem(layoutSize: elementSize)
            rightItem.contentInsets = NSDirectionalEdgeInsets(top: 90, leading: 0, bottom: -90, trailing: 0)
            
            let verticalGroupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(140),
                heightDimension: .absolute(140)
            )
            
            let leftVerticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: verticalGroupSize,
                repeatingSubitem: leftItem,
                count: 1
            )

            let rightVerticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: verticalGroupSize,
                repeatingSubitem: rightItem,
                count: 1
            )
            
            //Horizontal Group
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .estimated(280),
                heightDimension: .absolute(140)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [leftVerticalGroup, rightVerticalGroup])
            group.interItemSpacing = .fixed(15)
            
            let totalGroupWidth: CGFloat = 140 * 2 + 15
            let horizontalPadding = (layoutEnvironment.container.effectiveContentSize.width - totalGroupWidth) / 2.0
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 40
            section.contentInsets = .init(top: 32, leading: horizontalPadding, bottom: 90, trailing: horizontalPadding)
            
            return section
        }
    }
}
