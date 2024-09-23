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

    let label = UILabel().then { label in
        label.text = "MyAlarmList"
        label.textColor = .gray000
    }
}

extension MyAlarmListViewHolder: ViewHolderType {

    func place(in view: UIView) {
        view.addSubview(label)
    }

    func configureConstraints(for view: UIView) {
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

}
