import UIKit

final class MapCoordinator: CoordinatorProtocol {
  var navigationController: UINavigationController
  private var childCoordinators: [CoordinatorProtocol] = []
  private var dependencies: Dependencies
  
  init(navigationController: UINavigationController, dependencies: Dependencies) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }
  
  func start() {
    let viewController = MapViewController()
    viewController.navigationItem.largeTitleDisplayMode = .never
    let viewModel = MapViewModel(dependencies: dependencies)
    viewModel.delegate = self
    viewController.viewModel = viewModel
    navigationController.pushViewController(viewController, animated: true)
  }
}

// MARK: MapViewModelDelegate
extension MapCoordinator: MapViewModelDelegate {
  func mapViewModel(_ viewModel: MapViewModel, didRequestShowCityWith name: String) {
    let coordinator = WeatherCoordinator(navigationController: navigationController, dependencies: dependencies, city: name)
    childCoordinators.append(coordinator)
    coordinator.delegate = self
    coordinator.start()
  }
}

// MARK: WeatherCoordinatorDelegate
extension MapCoordinator: WeatherCoordinatorDelegate {
  func weatherCoordinatorDidFinishWork(_ coordinator: WeatherCoordinator) {
    childCoordinators.removeAll()
  } 
}
