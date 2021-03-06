import UIKit

protocol WeatherViewModelProtocol {
  var data: WeatherViewModelData? { get }
  var didRequestUpdateView: (() -> Void)? { get set }
  var didRequestStart: (() -> Void)? { get set }
  var didRequestEnd: (() -> Void)? { get set }
  var didRequestShowError: ((NetworkError) -> Void)? { get set }
  func getWeather()
  func viewControllerDidClose()
}

protocol WeatherViewModelDelegate: class {
  func weatherViewModelDidRequestClose(_ viewModel: WeatherViewModel)
}

final class WeatherViewModel: WeatherViewModelProtocol {
  var data: WeatherViewModelData?
  var didRequestUpdateView: (() -> Void)?
  var didRequestStart: (() -> Void)?
  var didRequestEnd: (() -> Void)?
  var didRequestShowError: ((NetworkError) -> Void)?
  weak var delegate: WeatherViewModelDelegate?
  private let networkService: NetworkServiceProtocol
  private let city: String
  typealias Dependencies = HasNetworkService
  
  init(dependencies: Dependencies, city: String) {
    self.networkService = dependencies.networkService
    self.city = city
  }
  
  func viewControllerDidClose() {
    delegate?.weatherViewModelDidRequestClose(self)
  }
  
  func getWeather() {
    didRequestStart?()
    networkService.getWeather(city: city) { [weak self] (result: Result<CityWeather, NetworkError>) in
      guard let self = self else { return }
      switch result {
      case .success(let weather):
        let temperature = TemperatureFormatter.convertKelvinToCelsius(temperature: weather.main.temp)
        let windDegrees = CardinalDirectionFormatter.convertDegreesToNameOfCardinalDirection(degrees: weather.wind.deg)
        self.data = WeatherViewModelData(pressure: weather.main.pressure,
                                         humidity: weather.main.humidity,
                                         temperature: Int(temperature),
                                         windSpeed: weather.wind.speed,
                                         windDeg: windDegrees,
                                         cityName: weather.name,
                                         description: weather.weather.first?.description,
                                         icon: weather.weather.first?.icon)
        self.didRequestUpdateView?()
      case .failure(let networkError):
        self.didRequestShowError?(networkError)
      }
      self.didRequestEnd?()
    }
  }
}
