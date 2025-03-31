//
//  ArtistCell.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import UIKit

import Kingfisher
import SnapKit

final class ArtistCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let dimmedView = UIView()
    private let nameLabel = UILabel()
    private let iconView = UIImageView()
    private let deleteButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registration(artist: ArtistEntity) {
        let url = URL(string: artist.imageURL)
        imageView.kf.setImage(
            with: url,
            options: [.transition(.fade(0.3))]
        )
        
        nameLabel.text = artist.name
        
        if let isSubscribed = artist.isSubscribed {
            configureAlarmState(isSubscribed: isSubscribed)
        } else {
            configureDefaultState()
        }
    }
}

// MARK: - Configure Views
private extension ArtistCell {
    func configureUI() {
        contentView.backgroundColor = .clear
        
        configureImageView()
        
        configureDimmedView()
        
        configureNameLabel()
        
        configureIconView()
        
        configureDeleteButton()
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.size.equalTo(100)
        }
        
        dimmedView.snp.makeConstraints { make in
            make.edges.equalTo(imageView)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.center.equalTo(imageView)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(imageView)
        }
    }
    
    func configureImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }
    
    func configureDimmedView() {
        dimmedView.layer.cornerRadius = 50
        dimmedView.clipsToBounds = true
        imageView.addSubview(dimmedView)
    }
    
    func configureNameLabel() {
        nameLabel.font = ENFont.H5.font
        nameLabel.textColor = .gray100
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
    }
    
    func configureIconView() {
        iconView.contentMode = .scaleAspectFit
        iconView.isHidden = true
        contentView.addSubview(iconView)
    }
    
    func configureDeleteButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .icXmarkCircle.resized(
            to: CGSize(
                width: 30,
                height: 30
            )
        )
        deleteButton.configuration = configuration
        deleteButton.isHidden = true
        contentView.addSubview(deleteButton)
    }
    
    func configureAlarmState(isSubscribed: Bool) {
        dimmedView.backgroundColor = isSubscribed
        ? .mainOrange.withAlphaComponent(0.7)
        : .gray700.withAlphaComponent(0.5)
        dimmedView.isHidden = false
        
        iconView.image = isSubscribed
        ? .icAlarmComplete.resized(to: CGSize(width: 30, height: 30)).withTintColor(.gray000)
        : .icAlarmPlus.resized(to: CGSize(width: 30, height: 30)).withTintColor(.gray000)
        iconView.isHidden = false
    }
    
    func configureDefaultState() {
        configurationUpdateHandler = { [weak self] cell, state in
            if state.isSelected {
                self?.dimmedView.isHidden = false
                self?.iconView.isHidden = false
                self?.dimmedView.backgroundColor = .mainOrange.withAlphaComponent(0.7)
                self?.iconView.image = .icCheck.resized(
                    to: CGSize(
                        width: 30,
                        height: 30
                    )
                )
                .withTintColor(.gray000)
            } else {
                self?.dimmedView.isHidden = true
                self?.iconView.isHidden = true
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    let cell = ArtistCell()
    cell.registration(artist: ArtistResponse.mock.toEntity())
    cell.isSelected = true
    cell.snp.makeConstraints { make in
        make.width.equalTo(100)
        make.height.equalTo(129)
    }
    return cell
}
