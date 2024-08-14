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
        [performanceArtistNameLabel, upcomingTimeLabel].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        
        performanceArtistNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
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
    let remainDay: Int
}

extension MyUpcomingTicketingHeaderView {
    func configureUI(with model: MyUpcomingTicketingHeaderViewModel) {
        self.configureUI(
            artistName: model.artistName,
            remainDay: model.remainDay
        )
    }
    
    func configureUI(
        artistName: String,
        remainDay: Int
    ) {
        performanceArtistNameLabel.setText(artistName)
        let targetText = "D-\(remainDay)"
        applyFontAndColorToText(
            fullText: "공연 티켓팅까지, \(targetText)",
            targetText: targetText,
            font: KRFont.H0.font,
            foregroundColor: .mainOrange
        ) // TODO: - 추후 SPLabel에 추가 혹은 SPLabel 2개를 생성해 해결할지 논의 필요
    }
    
    private func applyFontAndColorToText(
        fullText: String,
        targetText: String,
        font: UIFont,
        foregroundColor: UIColor
    ) {
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedString.length))
        
        if let range = fullText.range(of: targetText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: foregroundColor, range: nsRange)
        }
        
        upcomingTimeLabel.attributedText = attributedString
    }
}
