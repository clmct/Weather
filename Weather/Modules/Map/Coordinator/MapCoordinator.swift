import UIKit

final class MapCoordinator: CoordinatorProtocol {
  var navigationController: UINavigationController
  private var childCoordinators: [CoordinatorProtocol] = []
  private var services: ServiceAssemblyProtocol
  
  init(navigationController: UINavigationController, services: ServiceAssemblyProtocol) {
    self.navigationController = navigationController
    self.services = services
  }
  
  func start() {
    let viewController = MapViewController()
    viewController.navigationItem.largeTitleDisplayMode = .never
    let viewModel = MapViewModel(geocodingService: services.geocodingService)
    viewModel.delegate = self
    viewController.viewModel = viewModel
    navigationController.pushViewController(viewController, animated: true)
  }
}

// MARK: MapViewModelDelegate
extension MapCoordinator: MapViewModelDelegate {
  func requiredShowWeather(cityName: String) {
    let coordinator = WeatherCoordinator(navigationController: navigationController, services: services, city: cityName)
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
