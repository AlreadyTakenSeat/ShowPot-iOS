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
    
    let navigationView = AllPerformanceNavigationView()
    
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
        
        [navigationView, performanceListView].forEach { view.addSubview($0) }
    }
    
    func configureConstraints(for view: UIView) {
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        performanceListView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }
    
}
