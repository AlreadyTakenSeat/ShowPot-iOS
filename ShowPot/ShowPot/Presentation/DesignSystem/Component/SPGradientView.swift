//
//  SPGradientView.swift
//  ShowPot
//
//  Created by 김도형 on 4/4/25.
//

import UIKit

final class SPGradientView: UIView {
    init(
        colors: [UIColor],
        startPoint: CGPoint,
        endPoint: CGPoint,
        locations: [NSNumber]? = nil
    ) {
        super.init(frame: .zero)
        
        applyLinearGradient(
            colors: colors,
            startPoint: startPoint,
            endPoint: endPoint,
            locations: locations
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        updateGradientLayerFrame()
    }
}
