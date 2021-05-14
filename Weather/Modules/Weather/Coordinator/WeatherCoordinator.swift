import UIKit

protocol WeatherCoordinatorDelegate: class {
  func weatherCoordinatorDidFinishWork()
}

final class WeatherCoordinator: CoordinatorProtocol {
  weak var delegate: WeatherCoordinatorDelegate?
  var navigationController: UINavigationController
  private var childCoordinators: [CoordinatorProtocol] = []
  private var dependencies: Dependencies
  private var city: String
  
  init(navigationController: UINavigationController, dependencies: Dependencies, city: String) {
    self.navigationController = navigationController
    self.dependencies = dependencies
    self.city = city
  }
  
  func start() {
    let viewController = WeatherViewController()
    viewController.navigationItem.largeTitleDisplayMode = .always
    let viewModel = WeatherViewModel(dependencies: dependencies, city: city)
    viewModel.delegate = self
    viewController.viewModel = viewModel
    navigationController.pushViewController(viewController, animated: true)
  }
}

extension WeatherCoordinator: WeatherViewModelDelegate {
  func weatherViewModelDidRequestClose(_ viewModel: WeatherViewModel) {
    self.delegate?.weatherCoordinatorDidFinishWork()
  }
}
