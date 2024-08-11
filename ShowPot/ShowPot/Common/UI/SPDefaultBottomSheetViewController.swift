//
//  SPDefaultBottomSheetViewController.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/5/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxRelay

class SPDefaultBottomSheetViewController: BottomSheetViewController {
    
    // MARK: Property
    let message: String
    let buttonTitle: String
    
    let didTapBottomButton = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    lazy var messageLabel = SPLabel(KRFont.H1).then { label in
        label.textColor = .gray000
        label.numberOfLines = 0
        label.setText(message)
    }
    
    lazy var bottomButton = SPButton(.accentBottomEnabled).then { button in
        button.setText(buttonTitle)
    }
    
    // MARK: - init
    
    init(message: String, buttonTitle: String) {
        self.message = message
        self.buttonTitle = buttonTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    init(message: NSMutableAttributedString, buttonTitle: String) {
        self.message = ""
        self.buttonTitle = buttonTitle
        super.init(nibName: nil, bundle: nil)
        
        self.messageLabel.attributedText = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }
    
    private func setupView() {
        [messageLabel, bottomButton].forEach { self.contentView.addSubview($0) }
        messageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.horizontalEdges.equalToSuperview().inset(15)
        }
        
        bottomButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(19)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.height.equalTo(55)
        }
    }
    
    private func bind() {
        bottomButton.rx.tap
            .bind(to: didTapBottomButton)
            .disposed(by: disposeBag)
        
        bottomButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.dismissBottomSheet()
            }.disposed(by: disposeBag)
    }
}
