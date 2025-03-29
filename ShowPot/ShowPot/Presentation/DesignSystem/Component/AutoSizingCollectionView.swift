//
//  AutoSizingCollectionView.swift
//  ShowPot
//
//  Created by 이건준 on 8/22/24.
//

import UIKit

final class AutoSizingCollectionView: UICollectionView {

    override var intrinsicContentSize: CGSize {
        return contentSize
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
}
