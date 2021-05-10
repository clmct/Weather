import UIKit

protocol WeatherCoordinatorDelegate: class {
  func weatherCoordinatorDidFinishWork()
}

final class WeatherCoordinator: CoordinatorProtocol {
  weak var delegate: WeatherCoordinatorDelegate?
  var navigationController: UINavigationController
  private var childCoordinators: [CoordinatorProtocol] = []
  private var services: ServiceAssemblyProtocol
  private var city: String
  
  init(navigationController: UINavigationController, services: ServiceAssemblyProtocol, city: String) {
    self.navigationController = navigationController
    self.services = services
    self.city = city
  }
  
  func start() {
    let viewController = WeatherViewController()
    viewController.navigationItem.largeTitleDisplayMode = .always
    let viewModel = WeatherViewModel(networkService: services.networkService, city: city)
    viewModel.delegate = self
    viewController.viewModel = viewModel
    navigationController.pushViewController(viewController, animated: true)
  }
}

extension WeatherCoordinator: WeatherViewModelDelegate {
  func showNetworkError(networkError: NetworkError, completion: @escaping (() -> Void)) {
    navigationController.showNetworkError(networkError: networkError) {
      completion()
    }
  }
  
  func closeViewController() {
    self.delegate?.weatherCoordinatorDidFinishWork()
  }
}
