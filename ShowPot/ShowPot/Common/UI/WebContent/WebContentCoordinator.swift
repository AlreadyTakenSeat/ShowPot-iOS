//
//  WebContentCoordinator.swift
//  ShowPot
//
//  Created by 이건준 on 8/25/24.
//

import UIKit

final class WebContentCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func popViewController() {
        self.parentCoordinator?.removeChildCoordinator(child: self)
        self.navigationController.popViewController(animated: true)
    }
}
