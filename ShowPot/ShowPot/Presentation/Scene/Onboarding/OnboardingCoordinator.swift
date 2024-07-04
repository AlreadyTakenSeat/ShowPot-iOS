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
        let viewController: OnboardingViewController = OnboardingViewController(viewModel: OnboardingViewModel(coordinator: self))
        viewController.modalPresentationStyle = .fullScreen
        self.rootViewController.present(viewController, animated: true)
    }
}
