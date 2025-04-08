//
//  UpcomingTicketingButtonCell.swift
//  ShowPot
//
//  Created by 김도형 on 4/2/25.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class UpcomingTicketingButtonCell: UICollectionViewCell {
    let button = UIButton()
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
        var configuration = UIButton.Configuration.plain()
        let nsStr = NSAttributedString(
            "전체 공연 보러가기",
            fontType: KRFont.B1_semibold
        ).setForegroundColor(color: .gray100)
        configuration.attributedTitle = AttributedString(nsStr)
        configuration.image = .icArrowRight.resized(
            to: CGSize(
                width: 24,
                height: 24
            )
        )
        .withTintColor(.gray300)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 0
        configuration.background.backgroundColor = .gray500
        configuration.background.cornerRadius = 2
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 9,
            leading: 0,
            bottom: 9,
            trailing: 0
        )
        button.configuration = configuration
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}
