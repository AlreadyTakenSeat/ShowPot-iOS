//
//  MainTabController.swift
//  ShowPot
//
//  Created by Daegeon Choi on 7/4/24.
//

import UIKit

final class MainTabController: UITabBarController {
    
    override func viewDidLoad() {
        
        let tabCoordinators: [NavigationCoordinator] = [
            FeaturedCoordinator(navigationController: NavigationController()),
            SavedCoordinator(navigationController: NavigationController()),
            SettingsCoordinator(navigationController: NavigationController())
        ]
        
        let viewControllers = tabCoordinators.map { $0.navigationController }
        // TODO: #24 디자인 가이드에 명시된 아이콘 & 텍스트 지정
        viewControllers[0].tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        viewControllers[1].tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        viewControllers[2].tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)
        
        tabCoordinators.forEach { coordinator in
            coordinator.start()
        }
        
        self.viewControllers = viewControllers
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstLaunch() {
            let onboardingCoordinator = OnboardingCoordinator(rootViewController: self)
            onboardingCoordinator.start()
        }
    }
}

extension MainTabController {
    private func isFirstLaunch() -> Bool {
        
        if let isFirstLaunch: Bool = UserDefaultsManager.shared.get(for: .firstLaunch) {
            return isFirstLaunch
        }
        
        return true // 저장된 값이 없으면 최초 실행
    }
}
