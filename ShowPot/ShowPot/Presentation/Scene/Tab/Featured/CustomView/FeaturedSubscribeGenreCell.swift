//
//  FeaturedSubscribeGenreCell.swift
//  ShowPot
//
//  Created by 이건준 on 7/11/24.
//

import UIKit

import SnapKit
import Then

final class FeaturedSubscribeGenreCell: UICollectionViewCell {
    
    static let identifier = String(describing: FeaturedSubscribeGenreCell.self) // TODO: #46 identifier 지정코드로 변환
    
    private let subscribeGenreImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "heart.fill")
        $0.backgroundColor = .red
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
        contentView.addSubview(subscribeGenreImageView)
    }
    
    private func setupConstraints() {
        subscribeGenreImageView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
}

