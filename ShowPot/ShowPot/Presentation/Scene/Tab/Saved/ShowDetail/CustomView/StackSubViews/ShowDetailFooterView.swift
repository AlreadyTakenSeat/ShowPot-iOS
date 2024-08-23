//
//  ShowDetailFooterView.swift
//  ShowPot
//
//  Created by 이건준 on 8/22/24.
//

import UIKit

import SnapKit
import Then

final class ShowDetailFooterView: UIView {
    
    let likeButton = SPButton().then {
        $0.configuration?.background.cornerRadius = 2
        $0.configurationUpdateHandler = $0.configuration?.toggleButtonImageBySelection(
            backgroundColor: .gray500,
            normalImage: .icHeart.withTintColor(.gray200),
            selectedImage: .icHeartFilled.withTintColor(.gray200)
        )
    }
    
    let alarmButton = SPButton().then {
        $0.configurationUpdateHandler = $0.configuration?.showDetailAlarmButton(
            label: Strings.showDetailBottomButtonTitle,
            disabledTitle: Strings.showDetailDisenabledBottomButtonTitle,
            selectedTitle: Strings.showDetailAlarmUpdateBottomButtonTitle
        )
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        [likeButton, alarmButton].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        likeButton.snp.makeConstraints {
            $0.size.equalTo(55)
            $0.top.equalToSuperview().inset(9)
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(54)
        }
        
        alarmButton.snp.makeConstraints {
            $0.leading.equalTo(likeButton.snp.trailing).offset(15)
            $0.top.equalToSuperview().inset(9)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(55)
            $0.bottom.equalToSuperview().inset(54)
        }
    }
}
