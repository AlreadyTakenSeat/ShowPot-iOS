//
//  AppCoordinator.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/1/24.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func removeChildCoordinator(child: Coordinator) {
        childCoordinators.removeAll { $0 === child }
    }
}

/// UINavigation에 속한 ViewController에서 사용할 Coordinator
protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController { get }
}
