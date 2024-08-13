//
//  MyShowAlarmViewHolder.swift
//  ShowPot
//
//  Created by 이건준 on 8/9/24.
//

import UIKit
import SnapKit

final class MyShowAlarmViewHolder {
    
    private let myShowCollectionViewLayout = UICollectionViewFlowLayout().then {
        $0.sectionInset = .init(top: 12, left: 16, bottom: .zero, right: 16)
        $0.minimumLineSpacing = 12
    }
    
    lazy var myShowCollectionView = UICollectionView(frame: .zero, collectionViewLayout: myShowCollectionViewLayout).then {
        $0.register(ShowAlarmCell.self)
        $0.backgroundColor = .gray700
        $0.alwaysBounceVertical = true
    }
    
    lazy var emptyView = MyShowEmptyView()
}

extension MyShowAlarmViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        [myShowCollectionView, emptyView].forEach { view.addSubview($0) }
    }
    
    func configureConstraints(for view: UIView) {
        myShowCollectionView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
}
