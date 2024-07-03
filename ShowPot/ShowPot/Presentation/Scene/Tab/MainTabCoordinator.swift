//
//  MainTabCoordinator.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/1/24.
//

import Foundation
import UIKit

class MainTabCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var rootViewController = MainTabController()
    
    init(window: UIWindow?) {
        window?.rootViewController = rootViewController
    }
    
    func start() {

    }
}
