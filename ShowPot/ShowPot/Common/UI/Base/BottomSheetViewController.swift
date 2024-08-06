//
//  BottomSheetViewController.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/5/24.
//

import UIKit
import SnapKit
import Then

class BottomSheetViewController: UIViewController {
    
    /// 뷰 최상단과의 최소 간격
    private let minTopSpacing: CGFloat = 80
    
    /// 상단 드래그 가능 영역
    private let draggableHeight: CGFloat = 15
    
    /// 해당 높이까지 드래그 될 경우 dismiss
    private let minDismissiblePanHeight: CGFloat = 50
    
    /// 뒷배경 최대 불투명도
    private let maxDimmedAlpha: CGFloat = 0.8
    
    // MARK: UI Component
    
    lazy var mainContainerView = UIView().then { view in
        view.backgroundColor = .gray600
    }
    
    lazy var contentView = UIView()
    
    lazy var topBarView = UIView()
    
    lazy var barLineView = UIView().then { view in
        view.backgroundColor = .gray400
        view.layer.cornerRadius = 3
    }
    
    /// Dimmed background view
    private lazy var dimmedView = UIView().then { view in
        view.backgroundColor = .black
        view.alpha = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dimmedView.alpha = 0
        mainContainerView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animatePresent()
    }
    
    private func setUpView() {
        view.backgroundColor = .clear
        
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(mainContainerView)
        mainContainerView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(view.snp.top).offset(minTopSpacing)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        mainContainerView.addSubview(topBarView)
        topBarView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(draggableHeight)
        }
        
        topBarView.addSubview(barLineView)
        barLineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(43)
            make.height.equalTo(4)
        }
        
        mainContainerView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(topBarView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapDimmedView))
        dimmedView.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        topBarView.addGestureRecognizer(panGesture)
    }
}

// MARK: Configuration
extension BottomSheetViewController {
    
    func setContent(content: UIView) {
        contentView.addSubview(content)
        content.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.layoutIfNeeded()
    }
    
    func dismissBottomSheet() {
        UIView.animate(withDuration: 0.5, animations: {  [weak self] in
            guard let self = self else { return }
            self.dimmedView.alpha = 0
            self.mainContainerView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        }, completion: {  [weak self] _ in
            self?.dismiss(animated: false)
        })
    }
}

extension UIViewController {
    
    func presentBottomSheet(viewController: BottomSheetViewController) {
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false, completion: nil)
    }
}

// MARK: - Drag Gesture
extension BottomSheetViewController {
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        let isDraggingDown = translation.y > 0
        guard isDraggingDown else { return }
        
        let pannedHeight = translation.y
        let currentY = self.view.frame.height - self.mainContainerView.frame.height
        
        switch gesture.state {
        case .changed:
            self.mainContainerView.frame.origin.y = currentY + pannedHeight
        case .ended:
            if pannedHeight >= minDismissiblePanHeight {
                dismissBottomSheet()
            } else {
                self.mainContainerView.frame.origin.y = currentY
            }
        default:
            break
        }
    }
    
    @objc private func handleTapDimmedView() {
        dismissBottomSheet()
    }
    
    private func animatePresent() {
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.mainContainerView.transform = .identity
        }
        
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self = self else { return }
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
}
