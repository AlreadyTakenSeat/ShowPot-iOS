import UIKit

final class EndShowCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: EndShowViewController = EndShowViewController(viewModel: EndShowViewModel(coordinator: self, usecase: DefaultEndShowUseCase()))
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
