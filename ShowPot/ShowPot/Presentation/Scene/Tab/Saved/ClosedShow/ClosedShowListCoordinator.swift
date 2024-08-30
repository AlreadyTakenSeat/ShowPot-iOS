//
//  ClosedShowListCoordinator.swift
//  ShowPot
//
//  Created by 이건준 on 8/17/24.
//

import UIKit

final class ClosedShowListCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: ClosedShowListViewController = ClosedShowListViewController(viewModel: ClosedShowListViewModel(coordinator: self, usecase: DefaultClosedShowUseCase()))
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        self.parentCoordinator?.removeChildCoordinator(child: self)
        self.navigationController.popViewController(animated: true)
    }
    
    func goToMyShowAlarmScreen() {
        let coordinator = MyShowAlarmCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    func goToShowDetailScreen(showID: String) {
        let coordinator = ShowDetailCoordinator(showID: showID, navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
}

