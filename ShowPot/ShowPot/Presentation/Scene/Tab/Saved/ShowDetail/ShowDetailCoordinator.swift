//
//  ShowDetailCoordinator.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/11/24.
//

import UIKit

class ShowDetailCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = ShowDetailViewModel(coordinator: self, usecase: DefaultShowDetailUseCase())
        let viewController = ShowDetailViewController(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
