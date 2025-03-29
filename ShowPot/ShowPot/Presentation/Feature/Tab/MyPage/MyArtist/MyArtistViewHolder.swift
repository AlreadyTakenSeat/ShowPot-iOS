//
//  MyArtistViewHolder.swift
//  ShowPot
//
//  Created by 이건준 on 8/30/24.
//

import UIKit
import SnapKit

final class MyArtistViewHolder {
    private let artistCollectionViewLayout = UICollectionViewFlowLayout().then {
        $0.sectionInset = .init(top: 24, left: 25, bottom: .zero, right: 25)
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 24
    }
    
    lazy var artistCollectionView = UICollectionView(frame: .zero, collectionViewLayout: artistCollectionViewLayout).then {
        $0.register(DeleteArtistCell.self)
        $0.backgroundColor = .gray700
        $0.alwaysBounceVertical = true
    }
    
    lazy var emptyView = MyArtistEmptyView()
}

extension MyArtistViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        [artistCollectionView, emptyView].forEach { view.addSubview($0) }
    }
    
    func configureConstraints(for view: UIView) {
        artistCollectionView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}
