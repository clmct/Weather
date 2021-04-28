import UIKit

final class MapCoordinator: CoordinatorProtocol {
  var navigationController: UINavigationController
  private var childCoordinators: [CoordinatorProtocol] = []
  
  init() {
    self.navigationController = UINavigationController()
  }
  
  func start() {
  }
}
