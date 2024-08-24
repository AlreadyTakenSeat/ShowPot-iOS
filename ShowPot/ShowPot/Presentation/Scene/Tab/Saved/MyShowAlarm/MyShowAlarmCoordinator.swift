//
//  MyShowAlarmCoordinator.swift
//  ShowPot
//
//  Created by 이건준 on 8/9/24.
//

import UIKit

final class MyShowAlarmCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: MyShowAlarmViewController = MyShowAlarmViewController(viewModel: MyShowAlarmViewModel(coordinator: self, usecase: MyShowAlarmUseCase()))
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        LogHelper.debug("내 알림 화면으로 pop 호출")
        self.parentCoordinator?.removeChildCoordinator(child: self)
        self.navigationController.popViewController(animated: true)
    }
    
    func goToAllShowScreen() {
        let coordinator = AllPerformanceCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    func goToShowDetailScreen(showID: String) {
        let coordinator = ShowDetailCoordinator(showID: showID, navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
}
