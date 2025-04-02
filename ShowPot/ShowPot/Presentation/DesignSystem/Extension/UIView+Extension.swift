//
//  UIView+Extension.swift
//  CoinCo
//
//  Created by 김도형 on 3/6/25.
//

import UIKit

extension UIView {
    static func springAnimate(
        duration: TimeInterval = 0.7,
        damping: CGFloat = 0.7,
        velocity: CGFloat = 1,
        options: UIView.AnimationOptions = [.curveEaseOut],
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: damping,
            initialSpringVelocity: velocity,
            options: options,
            animations: animations,
            completion: completion
        )
    }
    
    static func fadeAnimate(
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        options: UIView.AnimationOptions = [.curveEaseInOut],
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: options,
            animations: animations,
            completion: completion
        )
    }
}
