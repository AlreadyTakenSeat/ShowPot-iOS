//
//  FeaturedSubscribeGenreCell.swift
//  ShowPot
//
//  Created by 이건준 on 7/11/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class FeaturedSubscribeGenreCell: UICollectionViewCell, ReusableCell {
    
    private let subscribeGenreImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyles()
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subscribeGenreImageView.image = nil
    }
    
    private func setupStyles() {
        contentView.backgroundColor = .gray700
        contentView.layer.masksToBounds = true
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

// MARK: Data Configuration

struct FeaturedSubscribeGenreCellModel {
    let subscribeGenreImageURL: URL?
}

extension FeaturedSubscribeGenreCell {
    func configureUI(with model: FeaturedSubscribeGenreCellModel) {
        subscribeGenreImageView.kf.setImage(with: model.subscribeGenreImageURL)
    }
    
    func configureUI(subscribeGenreImageURL: URL?) {
        subscribeGenreImageView.kf.setImage(with: subscribeGenreImageURL)
    }
}
