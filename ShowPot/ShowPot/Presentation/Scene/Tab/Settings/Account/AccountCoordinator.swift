//
//  AccountCoordinator.swift
//  ShowPot
//
//  Created by 이건준 on 8/29/24.
//

import UIKit

final class AccountCoordinator: NavigationCoordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: AccountViewController = AccountViewController(viewModel: AccountViewModel(coordinator: self))
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        self.parentCoordinator?.removeChildCoordinator(child: self)
        self.navigationController.popViewController(animated: true)
    }
}
