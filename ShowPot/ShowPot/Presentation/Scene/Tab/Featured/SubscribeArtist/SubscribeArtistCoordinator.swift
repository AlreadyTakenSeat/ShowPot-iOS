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
        let viewController: SubscribeArtistViewController = SubscribeArtistViewController(viewModel: SubscribeArtistViewModel(coordinator: self))
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
