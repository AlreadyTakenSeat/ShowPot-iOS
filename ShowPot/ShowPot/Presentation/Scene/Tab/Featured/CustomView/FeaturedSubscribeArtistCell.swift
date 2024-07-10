//
//  FeaturedSubscribeArtistCell.swift
//  ShowPot
//
//  Created by 이건준 on 7/11/24.
//

import UIKit

import SnapKit
import Then

final class FeaturedSubscribeArtistCell: UICollectionViewCell {
    
    static let identifier = String(describing: FeaturedSubscribeArtistCell.self) // TODO: #46 identifier 지정코드로 변환
    
    private let artistImageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 50
        $0.image = UIImage(systemName: "person.fill")
        $0.backgroundColor = .red
    }
    
    private let artistNameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .gray100
        $0.font = ENFont.H5 // TODO: #37 lineHeight + letterSpacing 적용
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
        $0.text = "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"
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
        [artistImageView, artistNameLabel].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        artistImageView.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.top.directionalHorizontalEdges.equalToSuperview()
        }
        
        artistNameLabel.snp.makeConstraints {
            $0.top.equalTo(artistImageView.snp.bottom).offset(5)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }
    
}
