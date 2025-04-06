//
//  TicketSiteCell.swift
//  ShowPot
//
//  Created by 김도형 on 4/4/25.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class TicketSiteCell: UICollectionViewCell {
    private let chip = SPBrandChip(style: .default(""))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(chip)
    }
    
    private func configureLayout() {
        chip.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with ticketSite: ShowDetailEntity.TicketingSite) {
        chip.configuration = nil
        chip.configuration = UIButton.Configuration.plain()
        chip.configuration?.background.backgroundColor = mapTicketingSiteToColor(name: ticketSite.name)
        chip.configuration?.background.cornerRadius = 2
        let nsStr = NSAttributedString(
            ticketSite.name,
            fontType: KRFont.B2_regular
        ).setForegroundColor(color: .gray000)
        chip.configuration?.attributedTitle = AttributedString(nsStr)
        chip.configuration?.image = .icArrowRight
            .withTintColor(.gray000)
            .resized(to: CGSize(width: 24, height: 24))
        chip.configuration?.imagePadding = 1
        chip.configuration?.imagePlacement = .trailing
        chip.configuration?.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 9,
            bottom: 5,
            trailing: 4
        )
    }
    
    private func mapTicketingSiteToColor(name: String) -> UIColor {
        switch name.lowercased() {
        case "yes24":
            return .chipYes24
        case "인터파크":
            return .chipInterpark
        case "멜론티켓":
            return .chipMelonticket
        default:
            return .mainOrange
        }
    }
}