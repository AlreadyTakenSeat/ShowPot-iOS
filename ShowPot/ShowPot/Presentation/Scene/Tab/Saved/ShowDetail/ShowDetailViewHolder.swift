//
//  ShowDetailViewHolder.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/11/24.
//

import UIKit
import SnapKit
import Then

final class ShowDetailViewHolder {
    
    let label = UILabel().then { label in
        label.text = "ShowDetail"
    }
}

extension ShowDetailViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        view.addSubview(label)
    }
    
    func configureConstraints(for view: UIView) {
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}
