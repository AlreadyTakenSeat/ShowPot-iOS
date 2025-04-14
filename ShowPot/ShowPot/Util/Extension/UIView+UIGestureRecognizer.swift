//
//  UIView+UIGestureRecognizer+Extension.swift
//  ShowPot
//
//  Created by Daegeon Choi on 7/28/24.
//

import UIKit

extension UIView {
    
    /// UIView에 특정 **한** 방향 Swipe Gesture 추가
    func addSwipeGesture(for direction: UISwipeGestureRecognizer.Direction, action: Selector) {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: action)
        swipeGesture.direction = direction
        swipeGesture.numberOfTouchesRequired = 1
        self.addGestureRecognizer(swipeGesture)
    }
    
    /// UIView에 특정 **여러** 방향으로 Swipe Gesture 추가
    func addSwipeGestures(_ directions: [UISwipeGestureRecognizer.Direction], action: Selector) {
        directions.forEach { direction in
            self.addSwipeGesture(for: direction, action: action)
        }
    }
    
    /// UIView에 **모든** 방향으로 Swipe Gesture 추가
    func addSwipeGesturesAllDirection(action: Selector) {
        self.addSwipeGestures([.right, .left, .up, .down], action: action)
    }
}
