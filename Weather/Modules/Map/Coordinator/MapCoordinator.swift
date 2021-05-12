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
  func requiredShowWeather(cityName: String) {
    let coordinator = WeatherCoordinator(navigationController: navigationController, dependencies: dependencies, city: cityName)
    childCoordinators.append(coordinator)
    coordinator.delegate = self
    coordinator.start()
  }
}

extension MapCoordinator: WeatherCoordinatorDelegate {
  func weatherCoordinatorDidFinishWork() {
    childCoordinators.removeAll()
  }  
}
