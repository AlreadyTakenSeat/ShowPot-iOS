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
        let viewController: AllPerformanceViewController = AllPerformanceViewController(viewModel: AllPerformanceViewModel(coordinator: self))
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
