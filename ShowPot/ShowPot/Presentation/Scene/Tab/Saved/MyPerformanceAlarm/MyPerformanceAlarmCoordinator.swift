//
//  MyPerformanceAlarmCoordinator.swift
//  ShowPot
//
//  Created by 이건준 on 8/9/24.
//

import UIKit

final class MyPerformanceAlarmCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: MyPerformanceAlarmViewController = MyPerformanceAlarmViewController(viewModel: MyPerformanceAlarmViewModel(coordinator: self))
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        LogHelper.debug("내 알림 화면으로 pop 호출")
        self.parentCoordinator?.removeChildCoordinator(child: self)
        self.navigationController.popViewController(animated: true)
    }
    
    func goToPerformanceInfoScreen() {
        LogHelper.debug("공연정보화면으로 이동")
    }
}