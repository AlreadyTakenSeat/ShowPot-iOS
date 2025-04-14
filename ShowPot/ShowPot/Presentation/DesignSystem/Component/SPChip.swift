//
//  SPChip.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import UIKit
import SnapKit // SnapKit 임포트 추가

final class SPChip: UIButton {
    let cancelButton = UIButton() // 별도의 이미지 뷰
    
    init(title: String, style: Style) {
        super.init(frame: .zero)
        
        configuration(title: title)
        
        switch style {
        case .default: break
        case .cancel: cancelConfiguration(title: title)
        case .filter:
            configurationUpdateHandler = { [weak self] _ in
                self?.filterConfiguration(title: title)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(title: String) {
        let nsStr = NSMutableAttributedString(
            string: title,
            attributes: [.font: KRFont.B1_regular]
        ).setForegroundColor(color: .gray000)
        configuration?.attributedTitle = AttributedString(nsStr)
    }
    
    // MARK: - Configuration
    private func configuration(title: String) {
        var configuration = UIButton.Configuration.plain()
        configuration.cornerStyle = .capsule
        configuration.background.backgroundColor = .gray700
        configuration.background.strokeColor = .gray400
        configuration.background.strokeWidth = 1
        let nsStr = NSMutableAttributedString(
            string: title,
            attributes: [.font: KRFont.B1_regular]
        ).setForegroundColor(color: .gray000)
        configuration.attributedTitle = AttributedString(nsStr)
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 14,
            bottom: 8,
            trailing: 14
        )
        self.configuration = configuration
    }
    
    private func cancelConfiguration(title: String) {
        // 기존 버튼 설정
        var config = self.configuration ?? UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 14,
            bottom: 8,
            trailing: 8 + 24 + 0 // 이미지 크기(24) + 패딩(0)
        )
        self.configuration = config
        
        var configuration = UIButton.Configuration.plain()
        
        // cancelImageView 설정
        configuration.image = .icCancel
            .withTintColor(.gray300)
            .resized(to: CGSize(width: 24, height: 24))
        configuration.contentInsets = .zero
        cancelButton.configuration = configuration
        addSubview(cancelButton)
        
        // SnapKit으로 레이아웃 설정
        cancelButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
    }
    
    private func filterConfiguration(title: String) {
        let strokeColor: UIColor = isSelected ? .gray000 : .gray600
        configuration?.background.strokeColor = strokeColor
        let nsStr = NSAttributedString(
            string: title,
            attributes: [.font: KRFont.B1_regular]
        ).setForegroundColor(color: isSelected ? .gray000 : .gray400)
        configuration?.attributedTitle = AttributedString(nsStr)
    }
}

extension SPChip {
    enum Style {
        case `default`
        case cancel
        case filter
    }
}

@available(iOS 17.0, *)
#Preview {
    let chip = SPChip(title: "크리스토퍼", style: .cancel)
    chip.isSelected = false
    return chip
}
