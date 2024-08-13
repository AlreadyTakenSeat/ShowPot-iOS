//
//  MyUpcomingTicketingHeaderView.swift
//  ShowPot
//
//  Created by 이건준 on 8/13/24.
//

import UIKit

import SnapKit
import Then

final class MyUpcomingTicketingHeaderView: UIView {
    
    private let titleLabel = SPLabel(KRFont.H1).then {
        $0.textColor = .gray300
        $0.setText("티켓팅이 임박한 공연")
    }
    
    private let performanceArtistNameLabel = SPLabel(ENFont.H0).then {
        $0.textColor = .gray100
    }
    
    private let upcomingTimeLabel = SPLabel(KRFont.H0).then {
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
        [titleLabel, performanceArtistNameLabel, upcomingTimeLabel].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        performanceArtistNameLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        upcomingTimeLabel.snp.makeConstraints {
            $0.top.equalTo(performanceArtistNameLabel.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Data Configuration

struct MyUpcomingTicketingHeaderViewModel {
    let artistName: String
    let upcomingTime: String
}

extension MyUpcomingTicketingHeaderView {
    func configureUI(with model: MyUpcomingTicketingHeaderViewModel) {
        self.configureUI(
            artistName: model.artistName,
            upcomingTime: model.upcomingTime
        )
    }
    
    func configureUI(
        artistName: String,
        upcomingTime: String
    ) {
        performanceArtistNameLabel.setText(artistName)
        applyFontAndColorToText(fullText: upcomingTime, startText: "D", font: KRFont.H0.font, foregroundColor: .mainOrange) // TODO: - 추후 SPLabel에 추가 혹은 SPLabel 2개를 생성해 해결할지 논의 필요
    }
    
    private func applyFontAndColorToText(
        fullText: String,
        startText: String,
        font: UIFont,
        foregroundColor: UIColor
    ) {
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedString.length))
        
        if let range = fullText.range(of: startText) {
            let nsRange = NSRange(range.lowerBound..<fullText.endIndex, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: foregroundColor, range: nsRange)
        }
        
        upcomingTimeLabel.attributedText = attributedString
    }
}

