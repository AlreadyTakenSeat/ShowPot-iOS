//
//  PosterCell.swift
//  ShowPot
//
//  Created by 김도형 on 4/4/25.
//


import UIKit

import Kingfisher
import RxSwift
import RxCocoa
import SnapKit

final class PosterCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let gradientView = SPGradientView(
        colors: [
            UIColor(red: 0.063, green: 0.063, blue: 0.071, alpha: 0.5),
            UIColor(red: 0.063, green: 0.063, blue: 0.071, alpha: 0)
        ],
        startPoint: CGPoint(x: 0.5, y: 0.25),
        endPoint: CGPoint(x: 0.5, y: 0.75),
        locations: [0.5, 1]
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        gradientView.layoutIfNeeded()
    }
    
    private func configureUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(gradientView)
    }
    
    private func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(524)
        }
        
        gradientView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(153)
        }
    }
    
    func configure(with imageURL: String) {
        imageView.kf.setImage(
            with: URL(string: imageURL),
            options: [.transition(.fade(0.3))]
        )
    }
}

@available(iOS 17.0, *)
#Preview {
    ShowDetailViewController(viewModel: ShowDetailViewModel(state: ShowDetailViewModel.State(showId: "")))
}
