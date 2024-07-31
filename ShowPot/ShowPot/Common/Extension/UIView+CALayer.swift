//
//  UIView+CALayer.swift
//  ShowPot
//
//  Created by 이건준 on 7/30/24.
//

import UIKit

extension UIView {
    
    /// 뷰에 선형 그라디언트를 적용하는 함수
    ///
    /// - Parameters:
    ///   - colors: 그라디언트에 사용될 `UIColor` 객체들의 배열입니다.
    ///   - startPoint: 레이어의 좌표 공간에서 그라디언트의 시작 지점입니다.
    ///   - endPoint: 레이어의 좌표 공간에서 그라디언트의 끝 지점입니다.
    ///   - locations: 각 그라디언트 색상에 해당하는 끝의 위치입니다. (0.0 ~ 1.0)
    func applyLinearGradient(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint, locations: [NSNumber]? = nil) {
        
        self.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = self.layer.cornerRadius
        gradientLayer.locations = locations
        
        self.layer.addSublayer(gradientLayer)
    }
    
    /// 그라디언트 레이어의 프레임을 업데이트하는 함수
    func updateGradientLayerFrame() {
        self.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.frame = self.bounds }
    }
}
