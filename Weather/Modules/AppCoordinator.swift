import UIKit

final class AppCoordinator: CoordinatorProtocol {
  var navigationController: UINavigationController
  private var childCoordinators: [CoordinatorProtocol] = []
  private var dependencies = Dependencies()
  
  init() {
    self.navigationController = UINavigationController()
    navigationController.navigationBar.prefersLargeTitles = true
  }
  
  func start() {
    let coordinator = MapCoordinator(navigationController: navigationController, dependencies: dependencies)
    childCoordinators.append(coordinator)
    coordinator.start()
  }
}
