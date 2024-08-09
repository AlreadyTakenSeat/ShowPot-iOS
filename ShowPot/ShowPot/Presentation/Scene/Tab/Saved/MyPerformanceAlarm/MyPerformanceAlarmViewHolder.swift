//
//  MyPerformanceAlarmViewHolder.swift
//  ShowPot
//
//  Created by 이건준 on 8/9/24.
//

import UIKit
import SnapKit

final class MyPerformanceAlarmViewHolder {
    
    private let myPerformanceCollectionViewLayout = UICollectionViewFlowLayout().then {
        $0.sectionInset = .init(top: 12, left: 16, bottom: .zero, right: 16)
        $0.minimumLineSpacing = 12
    }
    
    lazy var myPerformanceCollectionView = UICollectionView(frame: .zero, collectionViewLayout: myPerformanceCollectionViewLayout).then {
        $0.register(PerformanceAlarmCell.self)
        $0.backgroundColor = .gray700
        $0.alwaysBounceVertical = true
    }
    
    lazy var emptyView = MyPerformanceEmptyView()
}

extension MyPerformanceAlarmViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        [myPerformanceCollectionView, emptyView].forEach { view.addSubview($0) }
    }
    
    func configureConstraints(for view: UIView) {
        myPerformanceCollectionView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
}
