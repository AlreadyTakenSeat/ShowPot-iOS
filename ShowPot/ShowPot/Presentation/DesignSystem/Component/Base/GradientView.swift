//
//  GradientView.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/9/24.
//

import UIKit

class GradientView: UIView {
    
    init(
        colors: [UIColor],
        startPoint: CGPoint, endPoint: CGPoint,
        locations: [NSNumber]? = nil
    ) {
        super.init(frame: .zero)
        
        self.applyLinearGradient(
            colors: colors,
            startPoint: startPoint, endPoint: endPoint,
            locations: locations
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateGradientLayerFrame()
    }
}
