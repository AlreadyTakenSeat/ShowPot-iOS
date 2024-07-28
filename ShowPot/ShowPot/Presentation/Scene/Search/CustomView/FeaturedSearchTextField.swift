//
//  FeaturedSearchTextField.swift
//  ShowPot
//
//  Created by 이건준 on 7/22/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class FeaturedSearchTextField: UITextField {
    
    private let disposeBag = DisposeBag()
    
    var didTappedXButton: Observable<Void> {
        xButton.rx.tap.asObservable().share(replay: 1)
    }
    
    var didTappedReturnButton: Observable<String> {
        rx.controlEvent(.editingDidEndOnExit).asObservable()
            .withUnretained(self)
            .filter { $0.0.returnKeyType == .search }
            .compactMap { $0.0.text }
            .share(replay: 1)
    }
    
    private let xButton = UIButton().then {
        $0.setImage(.icCancel.withTintColor(.white), for: .normal)
        $0.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyles()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        delegate = self
        becomeFirstResponder()
        
        textColor = .white
        tintColor = .white
        backgroundColor = .gray500
        layer.masksToBounds = true
        layer.cornerRadius = 2
        
        returnKeyType = .default
        autocorrectionType = .no
        spellCheckingType = .no
        autocapitalizationType = .sentences
        
        leftViewMode = .always
        leftView = UIView(frame: .init(x: .zero, y: .zero, width: 8, height: .zero))
        
        clearButtonMode = .never
        
        rightViewMode = .always
        rightView = xButton
    }
    
    private func bind() {
        xButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.text?.removeAll()
                owner.updateReturnKey(type: .default)
                owner.searchTextFieldDelegate?.didTappedXButton()
            }
            .disposed(by: disposeBag)
        
        didTappedReturnButton
            .subscribe(with: self) { owner, _ in
                owner.resignFirstResponder()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - FeaturedSearchTextField Helper

extension FeaturedSearchTextField {
    private func updateReturnKey(type: UIReturnKeyType) {
        self.returnKeyType = type
        self.reloadInputViews()
    }
}

// MARK: - FeaturedSearchTextField UITextFieldDelegate

extension FeaturedSearchTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let newText = text.replacingCharacters(in: range, with: string)
            let isEmpty = newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            updateReturnKey(type: isEmpty ? .default : .search)
        }
        return true
    }
}

// MARK: - FeaturedSearchTextField Padding

extension FeaturedSearchTextField {
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var padding = super.rightViewRect(forBounds: bounds)
        padding.origin.x -= 5
        
        return padding
    }
}
