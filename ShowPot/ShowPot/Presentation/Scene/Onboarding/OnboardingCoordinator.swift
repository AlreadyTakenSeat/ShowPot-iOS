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
        self.modalViewController = OnboardingViewController(viewModel: OnboardingViewModel(coordinator: self))
        self.modalViewController?.modalPresentationStyle = .fullScreen
        
        if let modalView = modalViewController {
            self.rootViewController.present(modalView, animated: true)
        }
    }
}

extension OnboardingCoordinator {
    func dismiss() {
        if let modalView = modalViewController {
            modalView.dismiss(animated: true)
            parentCoordinator?.removeChildCoordinator(child: self)
        }
    }
}
