//
//  FeaturedCoordinator.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/28/24.
//

import UIKit

final class FeaturedCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: FeaturedViewController = FeaturedViewController(viewModel: FeaturedViewModel(coordinator: self))
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
}

// TODO: 각 화면 개발 이후, 실제 로직 추가 필요
extension FeaturedCoordinator {
    
    func goToFeaturedSearchScreen() {
        let coordinator = FeaturedSearchCoordinator(navigationController: self.navigationController)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func goToSubscribeGenreScreen() {
        LogHelper.debug("장르구독화면 이동")
    }
    
    func goToSubscribeArtistScreen() {
        let coordinator = SubscribeArtistCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    func goToFullPerformanceScreen() {
        let coordinator = AllPerformanceCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
}
