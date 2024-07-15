//
//  OnboardingCoordinator.swift
//  ShowPot
//
//  Created by Daegeon Choi on 7/4/24.
//

import UIKit

final class OnboardingCoordinator: Coordinator {
    
    var rootViewController: UIViewController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        let modalViewController = OnboardingViewController(viewModel: OnboardingViewModel(coordinator: self))
        modalViewController.modalPresentationStyle = .fullScreen
        self.rootViewController.present(modalViewController, animated: true)
    }
}

extension OnboardingCoordinator {
    func dismiss() {
        let currentVC = self.rootViewController.navigationController?.topViewController
        currentVC?.dismiss(animated: true)
        parentCoordinator?.removeChildCoordinator(child: self)
    }
}
