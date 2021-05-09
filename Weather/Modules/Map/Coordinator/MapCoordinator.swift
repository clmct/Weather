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
    let viewModel = MapViewModel()
    viewModel.delegate = self
    viewController.viewModel = viewModel
    navigationController.pushViewController(viewController, animated: true)
  }
}

extension MapCoordinator: MapViewModelDelegate {
  func showWeather(city: String) {
    let coordinator = WeatherCoordinator(navigationController: navigationController, services: services, city: city)
    childCoordinators.append(coordinator)
    coordinator.start()
  }
}
