//
//  SettingsCoordinator.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/28/24.
//

import UIKit

final class SettingsCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: SettingsViewController = SettingsViewController(viewModel: SettingsViewModel(coordinator: self))
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
