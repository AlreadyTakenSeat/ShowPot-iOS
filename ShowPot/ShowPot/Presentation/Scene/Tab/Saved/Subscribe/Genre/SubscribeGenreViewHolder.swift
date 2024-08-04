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
    
    let label = UILabel().then { label in
        label.text = "SubscribeGenre"
        label.textColor = .gray000
    }
}

extension SubscribeGenreViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        view.addSubview(label)
    }
    
    func configureConstraints(for view: UIView) {
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}
