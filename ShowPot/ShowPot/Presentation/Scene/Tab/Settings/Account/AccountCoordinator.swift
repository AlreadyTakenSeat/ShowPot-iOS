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
        let viewController: AccountViewController = AccountViewController(viewModel: AccountViewModel(coordinator: self, usecase: DefaultAccountUseCase()))
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        self.parentCoordinator?.removeChildCoordinator(child: self)
        self.navigationController.popViewController(animated: true)
    }
    
    // TODO: - 추후 스낵바가 최상단 화면에 띄워지게 수정
    func popViewController(logoutSuccess: Bool) {
        self.parentCoordinator?.removeChildCoordinator(child: self)
        self.navigationController.popViewController(animated: true)
        
        if let previousViewController = self.navigationController.viewControllers.last {
            SPSnackBar(contextView: previousViewController.view, type: .signOut)
                .show()
        }
    }
    
    // TODO: - 추후 스낵바가 최상단 화면에 띄워지게 수정
    func popViewController(withdrawSuccess: Bool) {
        self.parentCoordinator?.removeChildCoordinator(child: self)
        self.navigationController.popViewController(animated: true)
        
        if let previousViewController = self.navigationController.viewControllers.last {
            SPSnackBar(contextView: previousViewController.view, type: .deleteAccount)
                .show()
        }
    }
}
