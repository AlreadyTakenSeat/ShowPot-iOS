//
//  NavigationController.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/3/24.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        self.navigationBar.isHidden = true
        self.navigationBar.prefersLargeTitles = false
        self.navigationBar.isTranslucent = false
        self.navigationBar.backgroundColor = .gray700
        self.navigationBar.tintColor = .gray100
        
        interactivePopGestureRecognizer?.delegate = self
    }
}

extension NavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}
