//
//  GenreCell.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import Foundation

import UIKit

import Kingfisher
import SnapKit

final class GenreCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let deleteButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registration(genre: GenreEntity, isSelected: Bool, isDelete: Bool = false) {
        imageView.image = genre.isSubscribed
        ? genre.name?.subscribedImage
        : isSelected ? genre.name?.selectedImage : genre.name?.image
        
        deleteButton.isHidden = !isDelete
    }
}

// MARK: - Configure Views
private extension GenreCell {
    func configureUI() {
        contentView.backgroundColor = .clear
        
        configureImageView()
        
        configureDeleteButton()
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
        }
    }
    
    func configureImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }
    
    func configureDeleteButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .icXmarkCircle.resized(
            to: CGSize(
                width: 30,
                height: 30
            )
        )
        configuration.contentInsets = .zero
        deleteButton.configuration = configuration
        deleteButton.isHidden = true
        contentView.addSubview(deleteButton)
    }
}

extension GenreEntity.Genre {
    var image: UIImage? {
        return UIImage(named: "genre_\(self.rawValue)")
    }
    
    var selectedImage: UIImage? {
        return UIImage(named: "genre_selected_\(self.rawValue)")
    }
    
    var subscribedImage: UIImage? {
        return UIImage(named: "genre_subscribed_\(self.rawValue)")
    }
}

@available(iOS 17.0, *)
#Preview {
    let cell = GenreCell()
    cell.registration(genre: .mock, isSelected: false)
    cell.isSelected = true
    cell.snp.makeConstraints { make in
        make.width.equalTo(140)
        make.height.equalTo(140)
    }
    return cell
}
