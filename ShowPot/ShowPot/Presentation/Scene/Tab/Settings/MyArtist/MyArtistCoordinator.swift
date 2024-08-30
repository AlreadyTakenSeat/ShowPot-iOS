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
        let viewController: MyArtistViewController = MyArtistViewController(viewModel: MyArtistViewModel(coordinator: self))
        viewController.showTabBar = true
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
