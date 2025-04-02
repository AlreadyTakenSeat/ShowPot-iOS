//
//  SPTextField.swift
//  ShowPot
//
//  Created by 김도형 on 3/29/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class SPTextField: UIView {
    let textField = UITextField()
    let button = UIButton()
    
    private let disposeBag = DisposeBag()
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        configureUI(placeholder: placeholder)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure View
private extension SPTextField {
    func configureUI(placeholder: String) {
        backgroundColor = .gray500
        layer.cornerRadius = 2
        clipsToBounds = true
        
        configureTextField(placeholder: placeholder)
        
        configureButton()
    }
    
    func configureLayout() {
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.trailing.equalTo(button.snp.leading)
            make.centerY.equalTo(button)
        }
        
        button.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(5)
            make.size.equalTo(36)
        }
    }
    
    func configureTextField(placeholder: String) {
        textField.attributedPlaceholder = NSAttributedString(
            placeholder,
            fontType: KRFont.B1_semibold
        )
        .setForegroundColor(color: .gray300)
        textField.tintColor = .gray000
        
        textField.rx.controlEvent(.editingDidBegin)
            .bind(with: self) { this, _ in
                this.updateButtonImage(.icCancel)
            }
            .disposed(by: disposeBag)
        textField.rx.controlEvent(.editingDidEnd)
            .bind(with: self) { this, _ in
                this.updateButtonImage(.icMagnifier)
            }
            .disposed(by: disposeBag)
        
        addSubview(textField)
    }
    
    func configureButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .icMagnifier.withRenderingMode(.alwaysTemplate)
        configuration.baseForegroundColor = .gray000
        button.configuration = configuration
        addSubview(button)
    }
    
    func updateButtonImage(_ image: UIImage?) {
        button.configuration?.image = image?.withRenderingMode(.alwaysTemplate)
    }
}

@available(iOS 17.0, *)
#Preview {
    SPTextField(placeholder: "관심 있는 공연과 가수를 검색해보세요")
}
