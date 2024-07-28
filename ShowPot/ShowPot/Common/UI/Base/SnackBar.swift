//
//  SnackBar.swift
//  ShowPot
//
//  Created by Daegeon Choi on 7/28/24.
//

import UIKit
import SnapKit

protocol SnackBarAction {
    func setAction(with title: String, action: (() -> Void)?) -> SnackBarPresentable
}

protocol SnackBarPresentable {
    func show()
    func dismiss()
}

struct SnackBarStyle {
    /// 좌측 아이콘
    let icon: UIImage?
    /// 설명 문구
    let message: String
    /// 우측 버튼 문구
    let actionTitle: String
}

class SnackBar: UIView {
    
    /// SnackBar 표출 데이터
    var style: SnackBarStyle
    
    // MARK: - UI Component
    private lazy var contentStackView = UIStackView().then { stack in
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 3
        stack.backgroundColor = .clear
    }
    
    private lazy var iconImage = UIImageView().then { imageView in
        imageView.contentMode = .scaleAspectFit
        imageView.image = style.icon
        imageView.backgroundColor = .clear
    }
    
    private lazy var descriptionLabel = UILabel().then { label in
        label.font = KRFont.B1_semibold
        label.textColor = .gray000
        label.setAttributedText(font: KRFont.self, string: style.message, alignment: .left)
    }
    
    private lazy var actionButton = UIButton().then { button in
        button.setTitle(style.actionTitle, for: .normal)
        button.setTitleColor(.mainOrange, for: .normal)
        button.titleLabel?.font = KRFont.B1_semibold
    }
    
    // MARK: - 내부 로직 프로퍼티
    
    /// SnackBar가 올라갈 뷰
    private let contextView: UIView
    /// 자동 소거 시간 유형
    private let duration: Duration
    /// 자동 소거를 위한 타이머
    private var dismissTimer: Timer?
    
    required init(contextView: UIView, style: SnackBarStyle, duration: Duration) {
        self.contextView = contextView
        self.style = style
        self.duration = duration
        super.init(frame: .zero)
        
        setUpView()
        setupLayout()
        setUpGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Init 관련 methods
    
    /// 뷰 설정
    private func setUpView() {
        self.backgroundColor = .gray500
        self.layer.cornerRadius = 2
    }
    
    /// layout 설정
    private func setupLayout() {
        self.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().inset(7)
            make.trailing.equalToSuperview().inset(13)
        }
        
        [iconImage, descriptionLabel].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        iconImage.snp.makeConstraints { make in
            make.size.equalTo(36)
        }
        
        contentStackView.setCustomSpacing(16, after: descriptionLabel)  // 버튼 왼쪽 최소간격 16
    }

    /// 제스쳐 설정
    private func setUpGesture() {
        self.addSwipeGesture(for: .down, action: #selector(swipeAction(_:)))
    }
    
}

// MARK: - 내부 동작 관련 로직
extension SnackBar {
    
    /// 설정한 방향의 Swipe 제스쳐 동작
    @objc private func swipeAction(_ sender: UISwipeGestureRecognizer) {
        self.dismiss()
    }
    
    /// 새로운 SnackBar 표출시 현재 표출중인 SnackBar 소거
    private static func removeOldViews(form view: UIView) {
        view.subviews
            .filter { $0 is Self }
            .forEach { $0.removeFromSuperview() }
    }
    
    /// 스낵바 올라오는 애니메이션 동작
    private func animation(with offset: CGFloat, completion: ((Bool) -> Void)? = nil) {
        
        superview?.layoutIfNeeded()
        
        self.snp.updateConstraints {
            $0.bottom.equalTo(self.contextView.safeAreaLayoutGuide).offset(offset)
        }
        
        UIView.animate(
            withDuration: 0.6,
            delay: 0.0, usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.7, options: .curveEaseOut,
            animations: { self.superview?.layoutIfNeeded() },
            completion: completion
        )
    }
    
    /// SnackBar 자동 소거 타이머 비활성화
    private func invalidDismissTimer() {
        dismissTimer?.invalidate()
        dismissTimer = nil
    }
}

// MARK: - Public 메서드 (실제 사용하는 ViewController에서 사용)
extension SnackBar: SnackBarPresentable {
    
    /// SnackBar 객체 생성
    public static func make(in view: UIView, style: SnackBarStyle, duration: Duration) -> Self {
        removeOldViews(form: view)
        return Self.init(contextView: view, style: style, duration: duration)
    }
    
    /// SnackBar 우측 버튼 생성
    public func setAction(with title: String = Strings.snackbarActionTitle, action: (() -> Void)? = nil) -> SnackBarPresentable {
        contentStackView.addArrangedSubview(actionButton)
        actionButton.setTitle(title, for: .normal)
        
        actionButton.actionHandler(event: .touchUpInside) { [weak self] in
            self?.dismiss()
            action?()
        }
        
        return self
    }
    
    /// SnackBar 표출
    public func show() {
        
        contextView.addSubview(self)
        self.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(30)
            make.bottom.equalTo(self.contextView.safeAreaLayoutGuide).offset(200)
            make.height.equalTo(46)
        }
        
        animation(with: -8) { _ in
            
            if self.duration != .infinite {
                self.dismissTimer = Timer.init(
                    timeInterval: TimeInterval(self.duration.value),
                    target: self, selector: #selector(self.dismiss),
                    userInfo: nil, repeats: false
                )
                RunLoop.main.add(self.dismissTimer!, forMode: .common)
            }
        }
        
    }
    
    /// SnackBar 소거
    @objc public func dismiss() {
        
        invalidDismissTimer()
        
        animation(with: 200, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
}

// MARK: - Duration 타입
extension SnackBar {
    
    public enum Duration: Equatable {
        case long
        case short
        case infinite
        case custom(CGFloat)
        
        var value: CGFloat {
            switch self {
            case .long:
                return 3.5
            case .short:
                return 2
            case .infinite:
                return -1
            case .custom(let duration):
                return duration
            }
        }
    }
}
