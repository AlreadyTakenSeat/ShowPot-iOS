//
//  PaddingLabel.swift
//  ShowPot
//
//  Created by 이건준 on 7/26/24.
//

import UIKit

// 참고하면 좋은 사이트: https://ios-development.tistory.com/698

/// Padding값을 주고싶을때 사용하는 라벨
final class PaddingLabel: UILabel {
    
    /// 라벨의 상단여백
    private var topInset: CGFloat
    
    /// 라벨의 하단여백
    private var bottomInset: CGFloat
    
    /// 라벨의 좌측여백
    private var leftInset: CGFloat
    
    /// 라벨의 우측여백
    private var rightInset: CGFloat
    
    required init(
        withInsets top: CGFloat = 0,
        _ bottom: CGFloat = 0,
        _ left: CGFloat = 0,
        _ right: CGFloat = 0
    ) {
        topInset = top
        bottomInset = bottom
        leftInset = left
        rightInset = right
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(
            top: topInset,
            left: leftInset,
            bottom: bottomInset,
            right: rightInset
        )
        
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}


