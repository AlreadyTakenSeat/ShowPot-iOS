//
//  SPBottomAlert.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import UIKit

import SnapKit

final class SPBottomAlert: UIViewController {
    private let messageLabel = UILabel()
    private var stackView = UIStackView()
    private var cancelButton = SPCTAButton(title: "취소", style: .secondary)
    lazy var primaryButton = SPCTAButton(title: buttonTitle, style: .secondary)
    
    private let message: String
    private let buttonTitle: String
    
    init(
        message: String,
        buttonTitle: String
    ) {
        self.message = message
        self.buttonTitle = buttonTitle
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
    }
}

// MARK: - Configure Views
private extension SPBottomAlert {
    func configureUI() {
        view.backgroundColor = .gray600
        
        configureMessageLabel()
        
        configureStackView()
        
        configurePresentation()
    }
    
    func configureLayout() {
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(19)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(primaryButton)
        view.addSubview(stackView)
    }
    
    func configurePresentation() {
        sheetPresentationController?.preferredCornerRadius = 0
        if #available(iOS 16.0, *) {
            let height = view.bounds.height
            sheetPresentationController?.detents = [
                .custom { _ in return height }
            ]
        } else {
            sheetPresentationController?.detents = [.medium()]
        }
        
        sheetPresentationController?.prefersGrabberVisible = true
    }
    
    func configureMessageLabel() {
        let nsStr = NSAttributedString(message, fontType: KRFont.H1)
            .setForegroundColor(color: .gray000)
        messageLabel.attributedText = nsStr
        messageLabel.numberOfLines = 0
        view.addSubview(messageLabel)
    }
}

@available(iOS 17.0, *)
#Preview {
    SPBottomAlert(
        message: "로그아웃 하시면, 가장 빠른 내한 소식과 티켓팅 알림을 받을 수 없어요. 로그아웃 하시겠습니까?",
        buttonTitle: "로그아웃"
    )
}
