//
//  MyArtistCoordinator.swift
//  ShowPot
//
//  Created by 이건준 on 8/30/24.
//

import UIKit

final class MyArtistCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: MyArtistViewController = MyArtistViewController(viewModel: MyArtistViewModel(coordinator: self, usecase: DefaultMyArtistUseCase()))
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        self.parentCoordinator?.removeChildCoordinator(child: self)
        self.navigationController.popViewController(animated: true)
    }
    
    func goToSubscribeArtistScreen() {
        let coordinator = SubscribeArtistCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
}
