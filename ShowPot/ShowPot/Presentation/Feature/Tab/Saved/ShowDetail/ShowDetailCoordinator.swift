//
//  ShowDetailCoordinator.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/11/24.
//

import UIKit

final class ShowDetailCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let showID: String
    
    init(showID: String, navigationController: UINavigationController) {
        self.showID = showID
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = ShowDetailViewModel(showID: showID, coordinator: self, usecase: DefaultShowDetailUseCase())
        let viewController = ShowDetailViewController(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        self.parentCoordinator?.removeChildCoordinator(child: self)
        self.navigationController.popViewController(animated: true)
    }
    
    func goToTicketingWebPage(link: String) {
        let coordinator = WebContentCoordinator(navigationController: self.navigationController)
        self.childCoordinators.append(coordinator)
        let webPage = WebContentViewController(viewModel: WebContentViewModel(urlString: link, coordinator: coordinator))
        navigationController.pushViewController(webPage, animated: true)
    }
}
