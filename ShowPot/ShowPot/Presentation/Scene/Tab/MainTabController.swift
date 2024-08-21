//
//  MainTabController.swift
//  ShowPot
//
//  Created by Daegeon Choi on 7/4/24.
//

import UIKit
import SnapKit
import Then

final class MainTabController: UITabBarController {
    
    lazy var customTabBarContainer = UIView().then { view in
        view.backgroundColor = .gray800
    }
    
    lazy var customTabBar = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.spacing = 32
    }
    
    let tabItemViews: [SPTabBarItemView] = [SPTabBarItemView(), SPTabBarItemView(), SPTabBarItemView()]
    
    let tabItems: [SPTabBarItem] = [
        SPTabBarItem(selectedIcon: .icHomeFilled, unselectedIcon: .icHome, title: Strings.tabbarHome),
        SPTabBarItem(selectedIcon: .icShowFilled, unselectedIcon: .icShow, title: Strings.tabbarShow),
        SPTabBarItem(selectedIcon: .icMyFilled, unselectedIcon: .icMy, title: Strings.tabbarMy)
    ]
    
    let tabCoordinators: [NavigationCoordinator] = [
        FeaturedCoordinator(navigationController: NavigationController()),
        SavedCoordinator(navigationController: NavigationController()),
        SettingsCoordinator(navigationController: NavigationController())
    ]
    
    override func viewDidLoad() {
        
        self.setUpTabBar()
        
        let viewControllers = tabCoordinators.map { $0.navigationController }
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

extension MainTabController: SPTabBarItemViewDelegate {
    private func setUpTabBar() {
        tabBar.isTranslucent = false
        tabBar.isHidden = true
        
        self.view.addSubview(customTabBarContainer)
        customTabBarContainer.snp.makeConstraints { make in
            make.top.equalTo(tabBar.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        customTabBarContainer.addSubview(customTabBar)
        customTabBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.verticalEdges.greaterThanOrEqualToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        for (index, item) in self.tabItems.enumerated() {
            let tabView = self.tabItemViews[index]
            item.isSelected = (index == 0)
            tabView.item = item
            tabView.delegate = self
            self.customTabBar.addArrangedSubview(tabView)
        }
    }
    
    func handleTap(_ view: SPTabBarItemView) {
        self.tabItemViews[self.selectedIndex].isSelected = false
        view.isSelected = true
        self.selectedIndex = self.tabItemViews.firstIndex(where: { $0 == view }) ?? 0
    }
}
