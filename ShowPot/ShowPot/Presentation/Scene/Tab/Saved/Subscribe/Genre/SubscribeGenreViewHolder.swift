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
    
    lazy var bottomButton = SPButton(.accentBottomEnabled).then { button in
        button.setText(Strings.subscribeGenreAddButtonTitle)
    }
}

extension SubscribeGenreViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        [descriptionLabel, genreCollectionView, gradientView, bottomButton].forEach { view.addSubview($0) }
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(80)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        bottomButton.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(view.snp.bottom)
        }
    }
    
}

extension SubscribeGenreViewHolder {
    private func genreGridLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            let columnOffset: CGFloat = 90
            let itemSize: CGFloat = 140
            
            let elementSize = NSCollectionLayoutSize(
                widthDimension: .absolute(itemSize),
                heightDimension: .absolute(itemSize)
            )
            
            let leftItem = NSCollectionLayoutItem(layoutSize: elementSize)
            let rightItem = NSCollectionLayoutItem(layoutSize: elementSize)
            rightItem.contentInsets = NSDirectionalEdgeInsets(
                top: columnOffset,
                leading: 0,
                bottom: -columnOffset,
                trailing: 0
            )
            
            let verticalGroupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(itemSize),
                heightDimension: .absolute(itemSize)
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
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .estimated(itemSize * 2),
                heightDimension: .absolute(itemSize)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [leftVerticalGroup, rightVerticalGroup])
            group.interItemSpacing = .fixed(15)
            
            let totalGroupWidth: CGFloat = itemSize * 2 + 15
            let horizontalPadding = (layoutEnvironment.container.effectiveContentSize.width - totalGroupWidth) / 2.0
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 40
            section.contentInsets = .init(
                top: 32,
                leading: horizontalPadding,
                bottom: columnOffset + 150,
                trailing: horizontalPadding
            )
            
            return section
        }
    }
}

extension SubscribeGenreViewHolder {
    func showBottomButton(in view: UIView, isVisible: Bool) {
        if isVisible {
            bottomButton.snp.remakeConstraints { make in
                make.height.equalTo(55)
                make.horizontalEdges.equalToSuperview().inset(16)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            }
        } else {
            bottomButton.snp.remakeConstraints { make in
                make.height.equalTo(55)
                make.horizontalEdges.equalToSuperview().inset(16)
                make.top.equalTo(view.snp.bottom)
            }
        }
    }
}
