//
//  FeaturedSearchCoordinator.swift
//  ShowPot
//
//  Created by 이건준 on 7/22/24.
//

import UIKit

final class FeaturedSearchCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: FeaturedSearchViewController = FeaturedSearchViewController(viewModel: FeaturedSearchViewModel(coordinator: self, usecase: DefaultSearchUseCase()))
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        LogHelper.debug("홈 화면으로 pop 호출")
        self.parentCoordinator?.removeChildCoordinator(child: self)
        self.navigationController.popViewController(animated: true)
    }
    
    func goToShowDetailScreen(showID: String) {
        let coordinator = ShowDetailCoordinator(showID: showID, navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
}
