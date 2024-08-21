//
//  ShowDetailArtistInfoView.swift
//  ShowPot
//
//  Created by 이건준 on 8/22/24.
//

import UIKit

import SnapKit
import Then

final class ShowDetailArtistInfoView: UIView {
    
    private let titleLabel = SPLabel(KRFont.H2).then { label in
        label.textColor = .gray000
        label.setText(Strings.showArtistInfo)
    }
    
    private let artistCollectionViewLayout = UICollectionViewFlowLayout().then {
        $0.sectionInset = .init(top: 12, left: 16, bottom: 14, right: 16)
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 18
        $0.itemSize = .init(width: 100, height: 129)
    }
    
    lazy var artistCollectionView = UICollectionView(frame: .zero, collectionViewLayout: artistCollectionViewLayout).then {
        $0.register(FeaturedSubscribeArtistCell.self)
        $0.backgroundColor = .gray700
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        [titleLabel, artistCollectionView].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        artistCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(168)
        }
    }
}
