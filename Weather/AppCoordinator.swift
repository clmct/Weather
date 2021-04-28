import UIKit

final class AppCoordinator: CoordinatorProtocol {
  var navigationController: UINavigationController
  private var childCoordinators: [CoordinatorProtocol] = []
  
  init() {
    self.navigationController = UINavigationController()
  }
  
  func start() {
  }
}
