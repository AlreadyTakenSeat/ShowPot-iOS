//
//  SPNavigationBar.swift
//  ShowPot
//
//  Created by 김도형 on 4/1/25.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

final class SPNavigationBar: UIView {
    fileprivate let backButton = UIButton()
    private let titleLabel = UILabel()
    
    init(title: String) {
        super.init(frame: .zero)
        
        configureUI(title: title)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Views
private extension SPNavigationBar {
    func configureUI(title: String) {
        backgroundColor = .gray700
        
        configureBackButton()
        
        configureTitleLabel(title: title)
    }
    
    func configureLayout() {
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(6)
            make.verticalEdges.equalToSuperview().inset(4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(backButton.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    func configureBackButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .icArrowLeft.resized(
            to: CGSize(
                width: 36,
                height: 36
            )
        )
        .withTintColor(.gray000)
        configuration.contentInsets = .zero
        backButton.configuration = configuration
        addSubview(backButton)
    }
    
    func configureTitleLabel(title: String) {
        titleLabel.text = title
        titleLabel.font = KRFont.H1.font
        titleLabel.textColor = .gray100
        addSubview(titleLabel)
    }
}

extension Reactive where Base: SPNavigationBar {
    var backButtonTap: ControlEvent<Void> {
        base.backButton.rx.controlEvent(.touchUpInside)
    }
}

@available(iOS 17.0, *)
#Preview {
    SPNavigationBar(title: "장르 구독하기")
}
