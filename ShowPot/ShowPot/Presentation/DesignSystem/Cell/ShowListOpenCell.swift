//
//  ShowListOpenCell.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import UIKit

import Kingfisher
import SnapKit

final class ShowListOpenCell: UICollectionViewCell {
    private let openLabel = UILabel()
    private let openLabelContainer = UIView()
    private let ticketingAtLabel = UILabel()
    private let titleLabel = UILabel()
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
    
    func registration(showOpen: ShowOpenEntity) {
        let url = URL(string: showOpen.posterImageURL)
        imageView.kf.setImage(
            with: url,
            options: [.transition(.fade(0.3))]
        )
        
        openLabel.text = showOpen.isOpen ? "예매중" : "오픈예정"
        let color: UIColor = showOpen.isOpen ? .mainBlue : .mainYellow
        openLabel.textColor = color
        openLabelContainer.layer.borderColor = color.cgColor
        
        ticketingAtLabel.text = showOpen.ticketingAt
        
        titleLabel.text = showOpen.title
        
        locationLabel.text = showOpen.location
    }
}

// MARK: - Configure Views
private extension ShowListOpenCell {
    func configureUI() {
        contentView.backgroundColor = .gray700
        
        configureOpenLabel()
        
        configureTicketingAtLabel()
        
        configureTitleLabel()
        
        configureLocationLabel()
        
        configureImageView()
    }
    
    func configureLayout() {
        openLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8)
            make.verticalEdges.equalToSuperview().inset(1.5)
        }
        
        openLabelContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12.5)
            make.leading.equalToSuperview()
        }
        
        ticketingAtLabel.snp.makeConstraints { make in
            make.centerY.equalTo(openLabelContainer)
            make.leading.equalTo(openLabelContainer.snp.trailing).offset(6)
            make.width.lessThanOrEqualTo(140)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(openLabelContainer.snp.bottom).offset(3)
            make.leading.equalToSuperview()
            make.width.lessThanOrEqualTo(210)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().inset(12.5)
            make.width.lessThanOrEqualTo(210)
        }
        
        imageView.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
    }
    
    func configureOpenLabel() {
        openLabelContainer.backgroundColor = .clear
        openLabelContainer.layer.cornerRadius = 2
        openLabelContainer.layer.borderWidth = 1
        
        openLabel.font = KRFont.B2_regular.font
        
        openLabelContainer.addSubview(openLabel)
        contentView.addSubview(openLabelContainer)
    }
    
    func configureTicketingAtLabel() {
        ticketingAtLabel.font = ENFont.H5.font
        ticketingAtLabel.textColor = .mainYellow
        contentView.addSubview(ticketingAtLabel)
    }
    
    func configureTitleLabel() {
        titleLabel.font = ENFont.H3.font
        titleLabel.textColor = .gray000
        contentView.addSubview(titleLabel)
    }
    
    func configureLocationLabel() {
        locationLabel.font = KRFont.B2_regular.font
        locationLabel.textColor = .gray300
        contentView.addSubview(locationLabel)
    }
    
    func configureImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.applyLinearGradient(
            colors: [
                UIColor(red: 0.09, green: 0.09, blue: 0.106, alpha: 1),
                UIColor(red: 0.09, green: 0.09, blue: 0.106, alpha: 0)
            ],
            startPoint: CGPoint(x: 0.25, y: 0.5),
            endPoint: CGPoint(x: 0.75, y: 0.5)
        )
        contentView.addSubview(imageView)
    }
}

@available(iOS 17.0, *)
#Preview {
    let cell = ShowListOpenCell()
    cell.registration(showOpen: ShowOpenResponse.mock.toEntity())
    cell.snp.makeConstraints { make in
        make.height.equalTo(100)
    }
    return cell
}
