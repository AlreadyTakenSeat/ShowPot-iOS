//
//  SPLoadingIndicator.swift
//  ShowPot
//
//  Created by 김도형 on 4/19/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class SPLoadingIndicator: UIView {
    private let indicatorImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        configureLayout()
        startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating() {
        isHidden = false
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0) // 360도 회전
        rotationAnimation.duration = 1.0 // 1초 동안 한 바퀴
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = .infinity // 무한 반복
        indicatorImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func stopAnimating() {
        indicatorImageView.layer.removeAnimation(forKey: "rotationAnimation")
        isHidden = true
    }
}

// MARK: - Configure Views
private extension SPLoadingIndicator {
    func configureUI() {
        backgroundColor = .clear
        
        isHidden = true
        
        configureIndicatorImageView()
    }
    
    func configureLayout() {
        indicatorImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureIndicatorImageView() {
        indicatorImageView.contentMode = .scaleAspectFit
        indicatorImageView.image = .loadingIndcator // 제공된 이미지가 프로젝트에 있다고 가정
        addSubview(indicatorImageView)
    }
}

extension Reactive where Base: SPLoadingIndicator {
    var animating: Binder<Bool> {
        Binder(base) { base, isLoading in
            if isLoading {
                base.startAnimating()
            } else {
                base.stopAnimating()
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    let indicator = SPLoadingIndicator()
    indicator.snp.makeConstraints { make in
        make.width.height.equalTo(50)
    }
    return indicator
}
