//
//  MyAlarmListViewHolder.swift
//  ShowPot
//
//  Created by 이건준 on 9/23/24.
//

import UIKit

import SnapKit
import Then

final class MyAlarmListViewHolder {

    private let alarmListViewLayout = UICollectionViewFlowLayout().then {
        $0.sectionInset = .init(top: 12, left: 16, bottom: 12, right: 16)
        $0.minimumLineSpacing = 12
    }
    
    lazy var alarmListView = UICollectionView(frame: .zero, collectionViewLayout: alarmListViewLayout).then {
        $0.register(AlarmCollectionViewCell.self)
        $0.backgroundColor = .gray700
        $0.alwaysBounceVertical = true
    }
}

extension MyAlarmListViewHolder: ViewHolderType {

    func place(in view: UIView) {
        view.addSubview(alarmListView)
    }

    func configureConstraints(for view: UIView) {
        alarmListView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }

}
