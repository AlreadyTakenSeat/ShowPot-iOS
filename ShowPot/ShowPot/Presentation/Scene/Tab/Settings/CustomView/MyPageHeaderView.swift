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
    
    let alertTextView = UITextView().then {
        $0.tintColor = .gray000
        $0.backgroundColor = .gray700
        $0.isScrollEnabled = false
        $0.isEditable = false
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
        [alertTextView, bottomLineView].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        alertTextView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(25)
        }
        
        bottomLineView.snp.makeConstraints {
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(8)
            $0.top.equalTo(alertTextView.snp.bottom).offset(16)
        }
    }
}

extension MyPageHeaderView {
    
    static let actionID = "didTappedLoginButton"
    
    func configureUI(userNickname: String?) {
        if let userNickname = userNickname {
            let attributedString = NSAttributedString("\(userNickname),\n안녕하세요!", fontType: KRFont.H0, multiline: true)
                .setForegroundColor(color: .gray000)
            
            alertTextView.attributedText = attributedString
        } else {
            let attributedString = NSAttributedString(Strings.myPageLoginAlert, fontType: KRFont.H0, multiline: true)
                .setUnderline(to: "로그인")
                .setLink(to: "로그인", actionID: MyPageHeaderView.actionID)
                .setForegroundColor(color: .gray000)
            
            alertTextView.attributedText = attributedString
        }
    }
}
