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
        let viewController: FeaturedViewController = FeaturedViewController(viewModel: FeaturedViewModel(coordinator: self, usecase: DefaultFeaturedUseCase()))
        viewController.showTabBar = true
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
}

extension FeaturedCoordinator {
    
    func goToFeaturedSearchScreen() {
        let coordinator = FeaturedSearchCoordinator(navigationController: self.navigationController)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func goToSubscribeGenreScreen() {
        let coordinator = SubscribeGenreCoordinator(navigationController: self.navigationController)
        coordinator.parentCoordinator = self
        coordinator.start()
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
    
    func goToShowDetailScreen(showID: String) {
        let coordinator = ShowDetailCoordinator(showID: showID, navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    func goToMyAlarmListViewController() {
        let coordinator = MyAlarmListCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
}
