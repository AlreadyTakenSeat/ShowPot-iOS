//
//  ShowTicketCell.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import UIKit

import Kingfisher
import SnapKit

final class ShowTicketCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let ticketImageView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let locationLabel = UILabel()
    private let ticketOpenLabel = UILabel()
    private let ticketingAtLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registration(showAlarm: ShowAlarmEntity) {
        let url = URL(string: showAlarm.imageURL)
        imageView.kf.setImage(
            with: url,
            options: [.transition(.fade(0.3))]
        )
        
        ticketImageView.image = UIImage(named: "\(showAlarm.color)_ticket")
        
        titleLabel.text = showAlarm.title
        
        dateLabel.text = "\(showAlarm.startAt) - \(showAlarm.endAt)"
        
        locationLabel.text = showAlarm.location
        
        ticketingAtLabel.text = showAlarm.ticketingAt
    }
}

// MARK: - Configure Views
private extension ShowTicketCell {
    func configureUI() {
        configureTicketImageView()
        
        configureImageView()
        
        configureTitleLabel()
        
        configureDateLabel()
        
        configureLocationLabel()
        
        configureTicketOpenLabel()
        
        configureTicketingAtLabel()
    }
    
    func configureLayout() {
        ticketImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(160)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        ticketOpenLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        ticketingAtLabel.snp.makeConstraints { make in
            make.top.equalTo(ticketOpenLabel.snp.bottom).offset(-5)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureTicketImageView() {
        ticketImageView.contentMode = .scaleAspectFit
        ticketImageView.clipsToBounds = true
        contentView.addSubview(ticketImageView)
    }
    
    func configureImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        ticketImageView.addSubview(imageView)
    }
    
    func configureTitleLabel() {
        titleLabel.font = ENFont.H0.font
        titleLabel.textColor = .gray800
        ticketImageView.addSubview(titleLabel)
    }
    
    func configureDateLabel() {
        dateLabel.font = KRFont.B2_regular.font
        dateLabel.textColor = .gray700
        ticketImageView.addSubview(dateLabel)
    }
    
    func configureLocationLabel() {
        locationLabel.font = KRFont.B2_regular.font
        locationLabel.textColor = .gray700
        ticketImageView.addSubview(locationLabel)
    }
    
    func configureTicketOpenLabel() {
        ticketOpenLabel.text = "TICKET OPEN"
        ticketOpenLabel.font = ENFont.H5.font
        ticketOpenLabel.textColor = .gray700
        ticketOpenLabel.textAlignment = .center
        ticketImageView.addSubview(ticketOpenLabel)
    }
    
    func configureTicketingAtLabel() {
        ticketingAtLabel.font = ENFont.H1.font
        ticketingAtLabel.textColor = .gray700
        ticketingAtLabel.textAlignment = .center
        ticketImageView.addSubview(ticketingAtLabel)
    }
}

@available(iOS 17.0, *)
#Preview {
    let cell = ShowTicketCell()
    cell.registration(showAlarm: ShowAlarmResponse.mock.toEntity())
    cell.snp.makeConstraints { make in
        make.width.equalTo(258)
        make.height.equalTo(368)
    }
    return cell
}
