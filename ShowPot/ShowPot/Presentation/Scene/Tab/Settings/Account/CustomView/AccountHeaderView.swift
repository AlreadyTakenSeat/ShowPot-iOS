//
//  AccountHeaderView.swift
//  ShowPot
//
//  Created by 이건준 on 8/29/24.
//

import UIKit

import SnapKit
import Then

final class AccountHeaderView: UICollectionReusableView, ReusableCell {
    
    private let accountInfoView = AccountInfoView()
    
    private let bottomLineView = UIView().then {
        $0.backgroundColor = .gray500
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
        [accountInfoView, bottomLineView].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        
        accountInfoView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(47)
        }
        
        bottomLineView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.top.equalTo(accountInfoView.snp.bottom).offset(12)
        }
    }
}

extension AccountHeaderView {
    func configureUI(
        nickname: String,
        socialType: String
    ) {
        accountInfoView.nicknameLabel.setText(nickname)
        accountInfoView.socialTypeLabel.setText(socialType)
    }
}

final class AccountInfoView: UIView {
    
    let nicknameLabel = SPLabel(KRFont.H2).then {
        $0.textColor = .gray100
    }
    
    let socialTypeLabel = SPLabel(KRFont.B1_regular).then {
        $0.textColor = .gray000
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
        [nicknameLabel, socialTypeLabel].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        nicknameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        socialTypeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(nicknameLabel.snp.trailing)
        }
    }
}
