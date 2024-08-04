//
//  SubscribeArtistViewHolder.swift
//  ShowPot
//
//  Created by 이건준 on 8/5/24.
//

import UIKit
import SnapKit

final class SubscribeArtistViewHolder {
    
    let label = UILabel().then { label in
        label.text = "Saved"
    }
}

extension SubscribeArtistViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        view.addSubview(label)
    }
    
    func configureConstraints(for view: UIView) {
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}
