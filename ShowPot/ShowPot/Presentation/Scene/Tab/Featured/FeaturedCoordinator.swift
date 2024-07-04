//
//  FeaturedCoordinator.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/28/24.
//

import UIKit

final class FeaturedCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: FeaturedViewController = FeaturedViewController(viewModel: FeaturedViewModel(coordinator: self))
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
