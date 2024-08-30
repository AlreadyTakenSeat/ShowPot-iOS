//
//  LoginCoordinator.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/1/24.
//

import UIKit

final class LoginCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: LoginViewController = LoginViewController(viewModel: LoginViewModel(coordinator: self, usecase: DefaultSignInUseCase()))
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
    
    func popViewController() {
        self.parentCoordinator?.removeChildCoordinator(child: self)
        self.navigationController.popViewController(animated: true)
    }
}
