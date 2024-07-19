//
//  OnboardingCoordinator.swift
//  ShowPot
//
//  Created by Daegeon Choi on 7/4/24.
//

import UIKit

final class OnboardingCoordinator: Coordinator {
    
    var rootViewController: UIViewController
    var modalViewController: UIViewController?
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        let modalViewController = OnboardingViewController(viewModel: OnboardingViewModel(coordinator: self))
        modalViewController.modalPresentationStyle = .fullScreen
        self.rootViewController.present(modalViewController, animated: true)
        self.modalViewController = modalViewController
    }
}

extension OnboardingCoordinator {
    func dismiss() {
        if let modal = modalViewController {
            modal.dismiss(animated: true)
            parentCoordinator?.removeChildCoordinator(child: self)
        }
    }
}
