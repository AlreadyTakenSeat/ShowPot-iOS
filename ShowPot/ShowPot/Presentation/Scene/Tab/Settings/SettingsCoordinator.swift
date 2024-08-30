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
        let viewController: SettingsViewController = SettingsViewController(viewModel: SettingsViewModel(coordinator: self, usecase: DefaultMyPageUseCase()))
        viewController.showTabBar = true
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToSubscribeArtistScreen() {
        let coordinator = MyArtistCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    func goToSubscribeGenreScreen() {
        let coordinator = SubscribeGenreCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    func goToSettingScreen() {
        let coordinator = SettingCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    func goToLoginScreen() {
        let coordinator = LoginCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
}
