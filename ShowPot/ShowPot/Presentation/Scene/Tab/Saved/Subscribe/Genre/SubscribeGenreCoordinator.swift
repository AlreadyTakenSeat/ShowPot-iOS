//
//  GenreSelectCoordinator.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/4/24.
//

import UIKit

class SubscribeGenreCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let usecase = GenreSubscribeUseCase()
        let viewModel = SubscribeGenreViewModel(coordinator: self, usecase: usecase)
        let viewController = SubscribeGenreViewController(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension SubscribeGenreCoordinator {
    func goBack() {
        self.navigationController.popViewController(animated: true)
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
}
