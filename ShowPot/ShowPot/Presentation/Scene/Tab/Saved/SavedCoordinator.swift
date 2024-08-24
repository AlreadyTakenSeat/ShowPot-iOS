//
//  SavedCoordinator.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/28/24.
//

import UIKit

final class SavedCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: SavedViewController = SavedViewController(viewModel: SavedViewModel(coordinator: self, usecase: DefaultMyAlarmUseCase()))
        viewController.showTabBar = true
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToMyPerformanceAlarmScreen() {
        let coordinator = MyShowAlarmCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    func goToClosedShowListScreen() {
        let coordinator = ClosedShowListCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    func goToInterestShowListScreen() {
        let coordinator = InterestShowListCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    func goToLoginScreen() {
        let coordinator = LoginCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
}

