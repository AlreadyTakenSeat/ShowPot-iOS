//
//  ClosedShowListViewHolder.swift
//  ShowPot
//
//  Created by 이건준 on 8/17/24.
//

import UIKit
import SnapKit

final class ClosedShowListViewHolder {
    
    private let showListViewLayout = UICollectionViewFlowLayout().then {
        $0.sectionInset = .init(top: 12, left: 16, bottom: .zero, right: 16)
        $0.minimumLineSpacing = 12
    }
    
    lazy var showListView = UICollectionView(frame: .zero, collectionViewLayout: showListViewLayout).then {
        $0.register(PerformanceInfoCollectionViewCell.self)
        $0.backgroundColor = .gray700
        $0.alwaysBounceVertical = true
    }
    
    lazy var emptyView = ClosedShowListEmptyView()
}

extension ClosedShowListViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        [showListView, emptyView].forEach { view.addSubview($0) }
    }
    
    func configureConstraints(for view: UIView) {
        showListView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
}

