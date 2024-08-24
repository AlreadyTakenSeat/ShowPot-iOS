//
//  SettingCoordinator.swift
//  ShowPot
//
//  Created by 이건준 on 8/25/24.
//

import UIKit

final class SettingCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: SettingViewController = SettingViewController(viewModel: SettingViewModel(coordinator: self))
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        self.parentCoordinator?.removeChildCoordinator(child: self)
        self.navigationController.popViewController(animated: true)
    }
    
    func goToAccountScreen() {
        LogHelper.debug("계정화면으로 이동")
    }
    
    func goToAppSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
    }
    
    func goToPolicyNotionPage() {
        let coordinator = WebContentCoordinator(navigationController: self.navigationController)
        self.childCoordinators.append(coordinator)
        let notionPage = WebContentViewController(viewModel: WebContentViewModel(urlString: Strings.settingPolicyNotionUrlString, coordinator: coordinator))
        navigationController.pushViewController(notionPage, animated: true)
    }
    
    func goToTermNotionPage() {
        let coordinator = WebContentCoordinator(navigationController: self.navigationController)
        self.childCoordinators.append(coordinator)
        let notionPage = WebContentViewController(viewModel: WebContentViewModel(urlString: Strings.settingTermNotionUrlString, coordinator: coordinator))
        navigationController.pushViewController(notionPage, animated: true)
    }
    
    func goToKakaoChanel() {
        LogHelper.debug("카카오톡 문의 채널로 이동")
    }
}

