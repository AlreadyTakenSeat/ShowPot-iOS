//
//  FeaturedSubscribeArtistCell.swift
//  ShowPot
//
//  Created by 이건준 on 7/11/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then


/// 아티스트구독버튼에 대한 상태값
enum FeaturedSubscribeArtistCellState {
    
    /// 기본 상태
    case none
    
    /// 구독 선택됐을때
    case selected
    
    /// 구독 선택가능한 상태
    case availableSubscription
}

final class FeaturedSubscribeArtistCell: UICollectionViewCell, ReusableCell {
    
    private var state: FeaturedSubscribeArtistCellState = .none {
        didSet {
            updateLayoutIfNeeded()
        }
    }
    
    private let artistImageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 50
        $0.contentMode = .scaleAspectFill
    }
    
    private let artistNameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .gray100
        $0.font = ENFont.H5
        $0.numberOfLines = 1
    }
    
    private lazy var alertImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
    }
    
    private lazy var alphaView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        artistImageView.image = nil
        artistNameLabel.text = nil
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

extension FeaturedSubscribeArtistCell {
    private func updateLayoutIfNeeded() {
        switch state {
        case .none:
            return
        case .selected:
            setupSubscribeArtistCell(
                image: .icCheck.withTintColor(.white),
                alpha: 0.7,
                alphaBackgroundColor: .mainOrange
            )
        case .availableSubscription:
            setupSubscribeArtistCell(
                image: .icAlarmPlus.withTintColor(.white),
                alpha: 0.5,
                alphaBackgroundColor: .gray700
            )
        }
    }
    
    private func setupSubscribeArtistCell(
        image: UIImage,
        alpha: CGFloat,
        alphaBackgroundColor: UIColor
    ) {
        
        let isContain = artistImageView.contains(alphaView) && artistImageView.contains(alertImageView)
        
        if !isContain {
            [alphaView, alertImageView].forEach { artistImageView.addSubview($0) }
            
            alertImageView.snp.makeConstraints {
                $0.size.equalTo(36)
                $0.center.equalToSuperview()
            }
            
            alphaView.snp.makeConstraints {
                $0.directionalEdges.equalToSuperview()
            }
        }
        alertImageView.image = image
        alphaView.alpha = alpha
        alphaView.backgroundColor = alphaBackgroundColor
    }
}

// MARK: Data Configuration

struct FeaturedSubscribeArtistCellModel {
    var state: FeaturedSubscribeArtistCellState
    let artistImageURL: URL?
    let artistName: String
}

extension FeaturedSubscribeArtistCell {
    func configureUI(with model: FeaturedSubscribeArtistCellModel) {
        self.state = model.state
        artistImageView.kf.setImage(with: model.artistImageURL)
        artistNameLabel.setAttributedText(font: ENFont.self, string: model.artistName)
        artistNameLabel.lineBreakMode = .byTruncatingTail // TODO: - attribute적용 이후 lineBreakMode동작안하는 문제 해결요망
    }
    
    func configureUI(
        state: FeaturedSubscribeArtistCellState,
        artistImageURL: URL?,
        artistName: String
    ) {
        self.state = state
        artistImageView.kf.setImage(with: artistImageURL)
        artistNameLabel.setAttributedText(font: ENFont.self, string: artistName)
        artistNameLabel.lineBreakMode = .byTruncatingTail // TODO: - attribute적용 이후 lineBreakMode동작안하는 문제 해결요망
    }
}