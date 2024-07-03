//
//  MainTabController.swift
//  ShowPot
//
//  Created by Daegeon Choi on 7/4/24.
//

import UIKit

class MainTabController: UITabBarController {
    
    override func viewDidLoad() {
        
        let tabCoordinators: [NavigationCoordinator] = [
            FeaturedCoordinator(navigationController: UINavigationController()),
            SavedCoordinator(navigationController: UINavigationController()),
            SettingsCoordinator(navigationController: UINavigationController())
        ]
        
        let viewControllers = tabCoordinators.map { $0.navigationController }
        // TODO: [OMLK-17] 디자인 가이드에 명시된 아이콘 & 텍스트 지정
        viewControllers[0].tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        viewControllers[1].tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        viewControllers[2].tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)
        
        tabCoordinators.forEach { coordinator in
            coordinator.start()
        }
        
        self.viewControllers = viewControllers
    }
}
