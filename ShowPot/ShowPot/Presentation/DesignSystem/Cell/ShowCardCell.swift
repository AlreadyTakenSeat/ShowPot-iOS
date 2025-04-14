//
//  ShowCardCell.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import UIKit

import Kingfisher
import SnapKit

final class ShowCardCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registration(show: ShowOpenEntity) {
        let url = URL(string: show.posterImageURL)
        imageView.kf.setImage(
            with: url,
            options: [.transition(.fade(0.3))]
        )
        
        titleLabel.text = show.title
    }
}

// MARK: - Configure Views
private extension ShowCardCell {
    func configureUI() {
        contentView.backgroundColor = .gray500
        
        configureImageView()
        
        configureTitleLabel()
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.width.equalTo(192).priority(.high)
            make.height.equalTo(260)
            make.top.horizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(11)
            make.bottom.equalToSuperview().inset(11)
            make.horizontalEdges.equalToSuperview().inset(14)
        }
    }
    
    func configureImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }
    
    func configureTitleLabel() {
        titleLabel.textColor = .gray000
        titleLabel.font = ENFont.H4.font
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
    }
}

@available(iOS 17.0, *)
#Preview {
    let cell = ShowCardCell()
    cell.registration(show: .mock)
    cell.snp.makeConstraints { make in
        make.width.equalTo(192)
        make.height.equalTo(309)
    }
    return  cell
}
