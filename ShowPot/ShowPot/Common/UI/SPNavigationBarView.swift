//
//  SPNavigationTitleView.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/4/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxGesture

struct SPNavigationStyle {
    let title: String
    let titleColor: UIColor?
    let leftIcon: UIImage?
    let rightIcon: UIImage?
}

final class SPNavigationBarView: UIStackView {
    
    static let height: CGFloat = 56
    
    let didTapLeftButton = PublishSubject<Void>()
    let didTapRightButton = PublishSubject<Void>()
    
    private var style: SPNavigationStyle
    private let disposeBag = DisposeBag()
    
    lazy var titleLabel = SPLabel(KRFont.H1, alignment: .left).then { label in
        label.textColor = .gray100
        label.setText(style.title)
    }
    
    lazy var leftButtonItem = SPButton().then { button in
        button.configuration = .none
        button.setImage(style.leftIcon, for: .normal)
        button.snp.makeConstraints { $0.size.equalTo(36) }
    }
    
    lazy var rightButtonItem = SPButton().then { button in
        button.configuration = .none
        button.setImage(style.rightIcon, for: .normal)
        button.snp.makeConstraints { $0.size.equalTo(36) }
    }
    
    // MARK: - Init
    
    init (style: SPNavigationStyle) {
        self.style = style
        super.init(frame: .zero)
        
        self.setUpView()
        self.updateSubView()
        self.bind()
    }
    
    convenience init(
        _ title: String, titleColor: UIColor? = .gray100,
        leftIcon: UIImage? = nil, 
        rightIcon: UIImage? = nil
    ) {
        let style = SPNavigationStyle(
            title: title, titleColor: titleColor, 
            leftIcon: leftIcon, 
            rightIcon: rightIcon
        )
        self.init(style: style)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.backgroundColor = .gray700
        self.axis = .horizontal
        self.alignment = .center
        self.spacing = 8
        self.distribution = .fill
        self.layoutMargins = .init(top: 12, left: 6, bottom: 0, right: 6)
        self.isLayoutMarginsRelativeArrangement = true
    }
    
    private func updateSubView() {
        if style.leftIcon != nil { self.addArrangedSubview(leftButtonItem) }
        self.addArrangedSubview(titleLabel)
        if style.rightIcon != nil { self.addArrangedSubview(rightButtonItem) }
    }
    
    private func bind() {
        leftButtonItem.rx.tap
            .bind(to: didTapLeftButton)
            .disposed(by: disposeBag)
        
        rightButtonItem.rx.tap
            .bind(to: didTapRightButton)
            .disposed(by: disposeBag)
    }
}

extension SPNavigationBarView {
    
    func updateStyle(style: SPNavigationStyle) {
        self.style = style
        self.updateSubView()
    }
    
    func updateStyle(
        _ title: String, titleColor: UIColor = .gray100,
        leftIcon: UIImage? = nil,
        rightIcon: UIImage? = nil
    ) {
        self.style = SPNavigationStyle(
            title: title, titleColor: titleColor,
            leftIcon: leftIcon,
            rightIcon: rightIcon
        )
        self.updateSubView()
    }
}
