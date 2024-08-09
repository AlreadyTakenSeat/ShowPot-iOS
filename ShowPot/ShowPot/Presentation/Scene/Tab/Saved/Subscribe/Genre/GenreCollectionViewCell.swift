//
//  GenreCollectionViewCell.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/8/24.
//

import UIKit
import SnapKit
import Then

class GenreCollectionViewCell: UICollectionViewCell, ReusableCell {
    
    lazy var genreImageView = UIImageView().then { imageView in
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        self.contentView.addSubview(genreImageView)
        genreImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension GenreCollectionViewCell {
    
    func setData(image: UIImage?) {
        self.genreImageView.image = image
    }
    
    func setData(genre: GenreType) {
        let genreImage = genreImage(type: genre)
        self.setData(image: genreImage)
    }
}
