//
//  UIButton+Trigger.swift
//  ShowPot
//
//  Created by Daegeon Choi on 7/28/24.
//

import UIKit

extension UIButton {
    
    struct Trigger {
        static var action: (() -> Void)?
    }
    
    private func actionHandler(action: (() -> Void)? = nil) {
        if action != nil {
            Trigger.action = action
            
        } else {
            Trigger.action?()
            
        }
    }
    
    @objc private func triggerActionHandler() {
        self.actionHandler()
    }
    
    func actionHandler(
        event control: UIControl.Event,
        for action: @escaping () -> Void
    ) {
        self.actionHandler(action: action)
        self.addTarget(self, action: #selector(triggerActionHandler), for: control)
    }
}
