//
//  InterestShowListCoordinator.swift
//  ShowPot
//
//  Created by 이건준 on 8/16/24.
//

import UIKit

final class InterestShowListCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: InterestShowListViewController = InterestShowListViewController(viewModel: InterestShowListViewModel(coordinator: self, usecase: DefaultInterestShowUseCase()))
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        self.parentCoordinator?.removeChildCoordinator(child: self)
        self.navigationController.popViewController(animated: true)
    }
    
    func goToFullPerformanceScreen() {
        let coordinator = AllPerformanceCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
}
