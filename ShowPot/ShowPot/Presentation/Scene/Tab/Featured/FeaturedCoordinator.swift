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
    
    func goToFeaturedSearchScreen() {
        // TODO: - 홈 검색화면으로 이동하는 코드 추가 필요
        LogHelper.debug("홈 검색화면 이동")
    }
    
    func goToSubscribeGenreScreen() {
        // TODO: - 장르구독하기위한 화면으로 이동하는 코드 추가 필요
        LogHelper.debug("장르구독화면 이동")
    }
    
    func goToSubscribeArtistScreen() {
        // TODO: - 아티스트구독하기위한 화면으로 이동하는 코드 추가 필요
        LogHelper.debug("아티스트구독화면 이동")
    }
    
    func goToFullPerformanceScreen() {
        // TODO: - 전체공연을 볼 수 있는 화면으로 이동하는 코드 추가 필요
        LogHelper.debug("전체공연화면 이동")
    }
}
