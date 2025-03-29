//
//  SPToastBar.swift
//  ShowPot
//
//  Created by 김도형 on 3/29/25.
//

import UIKit

import SnapKit

final class SPToastBar: UIView {
    private let imageView = UIImageView()
    private let messageLabel = UILabel()
    let button = UIButton()
    
    init(style: Style) {
        super.init(frame: .zero)
        
        configureUI(style: style)
        
        configureLayout(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure View
private extension SPToastBar {
    func configureUI(style: Style) {
        layer.cornerRadius = 2
        clipsToBounds = true
        
        switch style {
        case let .plain(icon, message, buttonTitle):
            backgroundColor = .gray500
            configureImageView(icon: icon, color: .gray200)
            configureMessageLabel(message: message)
            configureButton(title: buttonTitle)
        case let .error(message):
            backgroundColor = .error
            configureImageView(icon: .icInfo, color: .gray000)
            configureMessageLabel(message: message)
        }
    }
    
    func configureLayout(style: Style) {
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(7)
            make.verticalEdges.equalToSuperview().inset(5)
            make.size.equalTo(36)
        }
        
        switch style {
        case .plain:
            messageLabel.snp.makeConstraints { make in
                make.leading.equalTo(imageView.snp.trailing).offset(3)
                make.trailing.equalTo(button.snp.leading).inset(-16)
                make.centerY.equalTo(imageView)
            }
            button.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(13)
                make.centerY.equalTo(imageView)
            }
        case .error:
            messageLabel.snp.makeConstraints { make in
                make.leading.equalTo(imageView.snp.trailing).offset(3)
                make.trailing.equalToSuperview().inset(12)
                make.centerY.equalTo(imageView)
            }
        }
    }
    
    func configureImageView(icon: UIImage?, color: UIColor?) {
        imageView.image = icon?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = color
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        addSubview(imageView)
    }
    
    func configureMessageLabel(message: String) {
        messageLabel.attributedText = NSAttributedString(
            message,
            fontType: KRFont.B1_semibold
        )
        .setForegroundColor(color: .gray000)
        addSubview(messageLabel)
    }
    
    func configureButton(title: String) {
        var configuration = UIButton.Configuration.plain()
        let nsStr = NSAttributedString(title, fontType: KRFont.B1_semibold)
            .setForegroundColor(color: .mainOrange)
        configuration.attributedTitle = AttributedString(nsStr)
        button.configuration = configuration
        
        addSubview(button)
    }
}

extension SPToastBar {
    enum Style {
        case plain(icon: UIImage? = UIImage.icCheck, String, String)
        case error(String)
    }
}

@available(iOS 17.0, *)
#Preview {
//    SPToastBar(style: .plain(icon: .icCheck, "알림 설정이 완료되었습니다", "보러가기"))
    SPToastBar(style: .error("구독에 실패하였습니다. 다시 시도해주세요."))
}
