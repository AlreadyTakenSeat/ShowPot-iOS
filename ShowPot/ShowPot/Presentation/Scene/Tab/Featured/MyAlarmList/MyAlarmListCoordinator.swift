//
//  MyAlarmListCoordinator.swift
//  ShowPot
//
//  Created by 이건준 on 9/23/24.
//

import UIKit

final class MyAlarmListCoordinator: Coordinator {

    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = MyAlarmListViewModel(coordinator: self, usecase: DefaultMyAlarmListUseCase())
        let viewController = MyAlarmListViewController(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        self.parentCoordinator?.removeChildCoordinator(child: self)
        self.navigationController.popViewController(animated: true)
    }
}
