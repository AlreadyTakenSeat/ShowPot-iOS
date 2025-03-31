//
//  SPBottomSheet.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import UIKit

import SnapKit

final class SPBottomSheet: UIViewController {
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    lazy var button = SPCTAButton(title: buttonTitle)
    
    private let titleKey: String?
    private let message: String
    private let buttonTitle: String
    
    init(
        titleKey: String? = nil,
        message: String,
        buttonTitle: String
    ) {
        self.titleKey = titleKey
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
private extension SPBottomSheet {
    func configureUI() {
        view.backgroundColor = .gray600
        
        if let titleKey {
            configureTitleLabel(title: titleKey)
        }
        
        configureMessageLabel()
        
        view.addSubview(button)
        
        configurePresentation()
    }
    
    func configureLayout() {
        if titleKey != nil {
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
                make.horizontalEdges.equalToSuperview().inset(16)
            }
            
            messageLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(1)
                make.horizontalEdges.equalToSuperview().inset(16)
            }
        } else {
            messageLabel.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
                make.horizontalEdges.equalToSuperview().inset(16)
            }
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(19)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func configurePresentation() {
        sheetPresentationController?.preferredCornerRadius = 0
        if #available(iOS 16.0, *) {
            sheetPresentationController?.detents = [
                .custom { [weak self] _ in
                    guard let `self` else { return 0 }
                    return view.bounds.height
                }
            ]
        } else {
            sheetPresentationController?.detents = [.medium()]
        }
        
        sheetPresentationController?.prefersGrabberVisible = true
    }
    
    func configureTitleLabel(title: String) {
        let nsStr = NSAttributedString(title, fontType: ENFont.H1)
            .setForegroundColor(color: .gray000)
        titleLabel.attributedText = nsStr
        view.addSubview(titleLabel)
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
    SPBottomSheet(
        titleKey: "Dua lipa",
        message: "구독을 취소하시겠습니까?",
        buttonTitle: "구독 취소하기"
    )
}
