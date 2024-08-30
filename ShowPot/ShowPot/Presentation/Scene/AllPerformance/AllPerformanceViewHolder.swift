//
//  AllPerformanceViewHolder.swift
//  ShowPot
//
//  Created by 이건준 on 8/2/24.
//

import UIKit

import SnapKit
import Then

final class AllPerformanceViewHolder {
    
    private let performanceListViewLayout = UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 10
        $0.scrollDirection = .vertical
        $0.sectionInset = .init(top: 8, left: 16, bottom: .zero, right: 16)
    }
    
    lazy var performanceListView = UICollectionView(frame: .zero, collectionViewLayout: performanceListViewLayout).then {
        $0.register(FeaturedPerformanceWithTicketOnSaleSoonCell.self)
        $0.register(PerformanceFilterHeaderView.self, of: UICollectionView.elementKindSectionHeader)
        $0.backgroundColor = .gray700
        $0.alwaysBounceVertical = true
    }
    
}

extension AllPerformanceViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        view.addSubview(performanceListView)
    }
    
    func configureConstraints(for view: UIView) {
        
        performanceListView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
