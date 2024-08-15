//
//  MyPageHeaderView.swift
//  ShowPot
//
//  Created by 이건준 on 8/14/24.
//

import UIKit

import SnapKit
import Then

final class MyPageHeaderView: UICollectionReusableView, ReusableCell {
    
    private let alertLabel = SPLabel(KRFont.H0).then {
        $0.textColor = .gray000
        $0.numberOfLines = 0
    }
    
    private let bottomLineView = UIView().then {
        $0.backgroundColor = .gray600
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
        [alertLabel, bottomLineView].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        alertLabel.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(25)
        }
        
        bottomLineView.snp.makeConstraints {
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(8)
            $0.top.equalTo(alertLabel.snp.bottom).offset(16)
        }
    }
}

extension MyPageHeaderView {
    func configureUI(userNickname: String?) {
        if let userNickname = userNickname {
            alertLabel.setText("\(userNickname)님,\n안녕하세요!")
        } else {
            applyUnderline(
                to: Strings.myPageLoginAlert,
                targetText: "로그인",
                font: KRFont.H0.font,
                foregroundColor: .gray000
            )
        }
    }
    
    private func applyUnderline(
        to fullText: String,
        targetText: String,
        font: UIFont,
        foregroundColor: UIColor
    ) {
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(.foregroundColor, value: foregroundColor, range: NSRange(location: 0, length: attributedString.length))
        
        // targetText의 범위를 찾아서 밑줄 추가
        if let range = fullText.range(of: targetText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
        }
        alertLabel.attributedText = attributedString
    }
}
