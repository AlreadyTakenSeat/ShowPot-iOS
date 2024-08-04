//
//  AllPerformanceCoordinator.swift
//  ShowPot
//
//  Created by 이건준 on 8/2/24.
//

import UIKit

final class AllPerformanceCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: AllPerformanceViewController = AllPerformanceViewController(viewModel: AllPerformanceViewModel(coordinator: self, usecase: DefaultAllPerformanceUseCase()))
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        LogHelper.debug("홈 화면으로 pop 호출")
        self.parentCoordinator?.removeChildCoordinator(child: self)
        self.navigationController.popViewController(animated: true)
    }
    
    func goToSearchScreen() {
        LogHelper.debug("검색 화면으로 이동")
        let coordinator = FeaturedSearchCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
}
