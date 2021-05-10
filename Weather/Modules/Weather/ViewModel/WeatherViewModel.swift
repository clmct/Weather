import UIKit

protocol WeatherViewModelProtocol {
  var data: WeatherViewModelData? { get }
  var updateView: (() -> Void)? { get set }
  var didRequestStart: (() -> Void)? { get set }
  var didRequestEnd: (() -> Void)? { get set }
  func getWeather()
  func closeViewController()
}

protocol WeatherViewModelDelegate: class {
  func showNetworkError(networkError: NetworkError, completion: @escaping (() -> Void) )
  func closeViewController()
}

final class WeatherViewModel: WeatherViewModelProtocol {
  var data: WeatherViewModelData?
  var updateView: (() -> Void)?
  var didRequestStart: (() -> Void)?
  var didRequestEnd: (() -> Void)?
  weak var delegate: WeatherViewModelDelegate?
  private let networkService: NetworkServiceProtocol
  private let city: String
  
  init(networkService: NetworkServiceProtocol, city: String) {
    self.networkService = networkService
    self.city = city
  }
  
  func closeViewController() {
    delegate?.closeViewController()
  }
  
  func getWeather() {
    didRequestStart?()
    networkService.getWeather(city: city) { (result: Result<CityWeather, NetworkError>) in
      DispatchQueue.main.async {
        switch result {
        case .success(let weather):
          self.data = WeatherViewModelData(pressure: weather.main.pressure,
                                           humidity: weather.main.humidity,
                                           temperature: Int(weather.main.temp - 273.15),
                                           windSpeed: weather.wind.speed,
                                           windDeg: self.getCommonDegrees(deg: weather.wind.deg),
                                           cityName: weather.name,
                                           description: weather.weather.first?.description,
                                           icon: weather.weather.first?.icon)
          self.updateView?()
        case .failure(let networkError):
          self.delegate?.showNetworkError(networkError: networkError) { [weak self] in
            self?.getWeather()
          }
          self.didRequestEnd?()
        }
        self.didRequestEnd?()
      }
    }
  }
  
  private func getCommonDegrees(deg: Int) -> String {
    switch deg {
    case 0...90:
      return "N"
    case 90...180:
      return "E"
    case 180...270:
      return "S"
    case 270...360:
      return "W"
    default:
      return ""
    }
  }
  
}
