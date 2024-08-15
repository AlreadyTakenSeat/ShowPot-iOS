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
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToMyPerformanceAlarmScreen() {
        let coordinator = MyShowAlarmCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    func goToEndShowScreen() {
        LogHelper.debug("티켓팅 종료 공연 화면으로 이동")
    }
    
    func goToInterestShowScreen() {
        LogHelper.debug("관심 공연 화면으로 이동")
    }
    
    func goToLoginScreen() {
        let coordinator = LoginCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
}

