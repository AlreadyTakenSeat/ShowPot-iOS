//
//  SettingViewHolder.swift
//  ShowPot
//
//  Created by 이건준 on 8/25/24.
//

import UIKit
import SnapKit

final class SettingViewHolder {
    
    private let settingListViewLayout = UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 8
        $0.sectionInset = .init(top: 12, left: .zero, bottom: .zero, right: .zero)
    }
    
    lazy var settingListView = UICollectionView(frame: .zero, collectionViewLayout: settingListViewLayout).then {
        $0.register(MenuCell.self)
        $0.register(LabelMenuCell.self)
        $0.backgroundColor = .gray700
        $0.alwaysBounceVertical = true
    }
    
}

extension SettingViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        view.addSubview(settingListView)
    }
    
    func configureConstraints(for view: UIView) {
        settingListView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

