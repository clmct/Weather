import UIKit
class ServiceAssembly: ServiceAssemblyProtocol {
  
}

final class AppCoordinator: CoordinatorProtocol {
  var navigationController: UINavigationController
  private var childCoordinators: [CoordinatorProtocol] = []
  private var services: ServiceAssemblyProtocol = ServiceAssembly()
  
  init() {
    self.navigationController = UINavigationController()
    navigationController.navigationBar.prefersLargeTitles = true
  }
  
  func start() {
    let coordinator = MapCoordinator(navigationController: navigationController, services: services)
    childCoordinators.append(coordinator)
    coordinator.start()
  }
}
