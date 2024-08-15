//
//  MenuCell.swift
//  ShowPot
//
//  Created by 이건준 on 8/13/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class MenuCell: UICollectionViewCell, ReusableCell {
    
    private let indicatorView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = .icArrowRight.withTintColor(.gray300)
    }
    
    private let mainMenuImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let menuTitleLabel = SPLabel(KRFont.H1).then {
        $0.textColor = .gray100
    }
    
    private let countBadgeLabel = SPLabel(KRFont.B1_semibold).then {
        $0.textColor = .gray100
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        [mainMenuImageView, menuTitleLabel, countBadgeLabel, indicatorView].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        mainMenuImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        menuTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(mainMenuImageView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        countBadgeLabel.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(menuTitleLabel.snp.trailing)
            $0.centerY.equalToSuperview()
        }
        
        indicatorView.snp.makeConstraints {
            $0.leading.equalTo(countBadgeLabel.snp.trailing)
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
}

// MARK: - Data Configuration

struct MenuCellModel {
    let menuImage: UIImage
    let menuTitle: String
    let badgeCount: Int?
}

extension MenuCell {
    func configureUI(with model: MenuCellModel) {
        self.configureUI(
            menuImage: model.menuImage,
            menuTitle: model.menuTitle,
            badgeCount: model.badgeCount
        )
    }
    
    func configureUI(
        menuImage: UIImage,
        menuTitle: String,
        badgeCount: Int? = nil
    ) {
        mainMenuImageView.image = menuImage
        menuTitleLabel.setText(menuTitle)
        if let badgeCount = badgeCount {
            countBadgeLabel.setText("\(badgeCount)")
        }
    }
}

/// 내 알림 메뉴 타입
enum MyAlarmMenuType: CaseIterable {
    case alarmPerformance
    case artist
    case genre
    
    var menuTitle: String {
        switch self {
        case .alarmPerformance:
            return Strings.myAlarmMenuButton1
        case .artist:
            return Strings.myAlarmMenuButton2
        case .genre:
            return Strings.myAlarmMenuButton3
        }
    }
    
    var menuImage: UIImage {
        switch self {
        case .alarmPerformance:
            return .icAlarm.withTintColor(.gray300)
        case .artist:
            return .icArtist.withTintColor(.gray300)
        case .genre:
            return .icGenre.withTintColor(.gray300)
        }
    }
    
    static func menuType(title: String) -> Self {
        guard let type = MyAlarmMenuType.allCases.first(where: { $0.menuTitle == title }) else {
            fatalError("Not Found MyAlarmMenuType")
        }
        return type
    }
}
