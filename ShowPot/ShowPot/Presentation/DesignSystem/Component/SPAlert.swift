//
//  SPAlert.swift
//  ShowPot
//
//  Created by 김도형 on 3/29/25.
//

import UIKit

import SnapKit

final class SPAlert: UIView {
    private let messageLabel = UILabel()
    let confirmButton = UIButton()
    
    init(message: String) {
        super.init(frame: .zero)
        
        configureUI(message: message)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure View
private extension SPAlert {
    func configureUI(message: String) {
        backgroundColor = .gray600
        
        configureMessageLabel(message: message)
        
        configureConfirmButton()
    }
    
    func configureLayout() {
        snp.makeConstraints { make in
            make.width.equalTo(358)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(12)
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(22)
        }
    }
    
    func configureMessageLabel(message: String) {
        messageLabel.attributedText = NSAttributedString(
            message,
            fontType: KRFont.H1
        )
        .setForegroundColor(color: .gray100)
        .setLetterSpacing(letterSpacingPercent: -0.025)
        .setParagraphStyle(lineHeightMultiple: 1.5, alignment: .left)
        messageLabel.numberOfLines = 0
        addSubview(messageLabel)
    }
    
    func configureConfirmButton() {
        var configuration = UIButton.Configuration.plain()
        let nsStr = NSAttributedString("확인", fontType: KRFont.H2)
            .setForegroundColor(color: .mainOrange)
        configuration.attributedTitle = AttributedString(nsStr)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        confirmButton.configuration = configuration
        addSubview(confirmButton)
    }
}

@available(iOS 17.0, *)
#Preview {
    SPAlert(message: "서비스가 일시적으로 사용 불가능합니다.\n잠시 후 다시 시도해주세요")
}
