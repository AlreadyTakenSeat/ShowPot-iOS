//
//  LoginCoordinator.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/1/24.
//

import Foundation
import UIKit

class LoginCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: LoginViewController = LoginViewController(viewModel: LoginViewModel(coordinator: self))
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension LoginCoordinator {
    func didLoggedIn() {
        
    }
    
    func didTappedBackButton() {
        navigationController.popViewController(animated: true)
        parentCoordinator?.removeChildCoordinator(child: self)
    }
}
