//
//  ShowListCell.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import Foundation

import UIKit

import Kingfisher
import SnapKit

final class ShowListCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let startAtLabel = UILabel()
    private let locationLabel = UILabel()
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.updateGradientLayerFrame()
    }
    
    func registration(showSearch: ShowEntity, isNotification: Bool = false) {
        let url = URL(string: showSearch.imageURL)
        imageView.kf.setImage(
            with: url,
            options: [.transition(.fade(0.3))]
        )
        
        titleLabel.attributedText = NSAttributedString(
            showSearch.title,
            fontType: isNotification ? KRFont.B1_semibold : ENFont.H3
        )
        .setForegroundColor(color: .gray000)
        
        startAtLabel.attributedText = NSAttributedString(
            showSearch.startAt,
            fontType: KRFont.B2_regular,
            multiline: true
        )
        .setForegroundColor(color: .gray300)
        
        locationLabel.attributedText = NSAttributedString(
            showSearch.location,
            fontType: KRFont.B2_regular,
            multiline: true
        )
        .setForegroundColor(color: .gray300)
    }
}

// MARK: - Configure Views
private extension ShowListCell {
    func configureUI() {
        contentView.backgroundColor = .clear
        
        configureTitleLabel()
        
        configureStartAtLabel()
        
        configureLocationLabel()
        
        configureImageView()
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.leading.equalTo(imageView.snp.trailing).offset(14)
            make.trailing.equalToSuperview()
        }
        
        startAtLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(imageView.snp.trailing).offset(14)
            make.trailing.equalToSuperview()
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(startAtLabel.snp.bottom).offset(1)
            make.leading.equalTo(imageView.snp.trailing).offset(14)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(2)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.size.equalTo(80)
        }
    }
    
    func configureTitleLabel() {
        contentView.addSubview(titleLabel)
    }
    
    func configureStartAtLabel() {
        contentView.addSubview(startAtLabel)
    }
    
    func configureLocationLabel() {
        contentView.addSubview(locationLabel)
    }
    
    func configureImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }
}

@available(iOS 17.0, *)
#Preview {
    let cell = ShowListCell()
    cell.backgroundColor = .gray700
    cell.registration(showSearch: ShowResponse.mock.toEntity())
    cell.snp.makeConstraints { make in
        make.height.equalTo(80)
    }
    
    return cell
}
