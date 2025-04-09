//
//  SPAccountHeaderCell.swift
//  ShowPot
//
//  Created by 김도형 on 4/6/25.
//

import UIKit
import SnapKit

final class SPAccountHeaderCell: UICollectionViewCell {
    // MARK: - Properties
    private let titleLabel = UILabel()
    private let platformIcon = UIImageView()
    private let platformLabel = UILabel()
    private let divider = SPDivider(style: .short)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(profile: ProfileEntity) {
        titleLabel.attributedText = NSAttributedString(
            profile.nickname + "님",
            fontType: KRFont.H2
        ).setForegroundColor(color: .gray100)
        
        guard let platform = profile.platform else { return }
        
        switch platform {
        case .kakao:
            platformIcon.image = .icKakao.withTintColor(.gray100)
        case .google:
            platformIcon.image = .icApple.withTintColor(.gray100)
        case .apple:
            platformIcon.image = .icGoogle.withTintColor(.gray100)
        }
        
        platformLabel.attributedText = NSAttributedString(
            platform.name + "로그인",
            fontType: KRFont.B1_regular
        )
        .setForegroundColor(color: .gray000)
    }
}

// MARK: - Configure Views
private extension SPAccountHeaderCell {
    func configureUI() {
        contentView.backgroundColor = .gray700
        
        contentView.addSubview(titleLabel)
        
        platformIcon.contentMode = .scaleAspectFit
        contentView.addSubview(platformIcon)
        
        contentView.addSubview(platformLabel)
        
        contentView.addSubview(divider)
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(10)
        }
        
        platformLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
        platformIcon.snp.makeConstraints { make in
            make.trailing.equalTo(platformLabel.snp.leading).offset(-4)
            make.centerY.equalTo(platformLabel)
            make.size.equalTo(24)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(22)
            make.bottom.equalToSuperview().inset(2)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    let cell = SPAccountHeaderCell()
    cell.configure(profile: .mock)
    cell.snp.makeConstraints { make in
        make.height.equalTo(57)
    }
    return cell
}
