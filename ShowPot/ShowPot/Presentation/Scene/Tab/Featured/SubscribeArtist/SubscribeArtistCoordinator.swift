//
//  SubscribeArtistCoordinator.swift
//  ShowPot
//
//  Created by 이건준 on 8/5/24.
//

import UIKit

final class SubscribeArtistCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: SubscribeArtistViewController = SubscribeArtistViewController(viewModel: SubscribeArtistViewModel(coordinator: self, usecase: DefaultSubscribeArtistUseCase()))
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        self.parentCoordinator?.removeChildCoordinator(child: self)
        self.navigationController.popViewController(animated: true)
    }
    
    func goToSubscribeArtistScreen() {
        let coordinator = MyArtistCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
}
