//
//  FeaturedCoordinator.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/28/24.
//

import UIKit

final class FeaturedCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: FeaturedViewController = FeaturedViewController(viewModel: FeaturedViewModel(coordinator: self))
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
}

// TODO: 각 화면 개발 이후, 실제 로직 추가 필요
extension FeaturedCoordinator {
    
    func goToFeaturedSearchScreen() {
        LogHelper.debug("홈 검색화면 이동")
    }
    
    func goToSubscribeGenreScreen() {
        LogHelper.debug("장르구독화면 이동")
    }
    
    func goToSubscribeArtistScreen() {
        LogHelper.debug("아티스트구독화면 이동")
    }
    
    func goToFullPerformanceScreen() {
        LogHelper.debug("전체공연화면 이동")
    }
}
