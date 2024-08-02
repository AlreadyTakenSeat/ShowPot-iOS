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
    let label = UILabel().then { label in
        label.text = "Saved"
    }
}

extension AllPerformanceViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        view.addSubview(label)
    }
    
    func configureConstraints(for view: UIView) {
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}
