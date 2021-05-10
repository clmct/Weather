import UIKit

protocol WeatherViewModelProtocol {
  var pressure: Int? { get set }
  var humidity: Int? { get set }
  var temperature: Int? { get set }
  var image: UIImage? { get set }
  var windSpeed: Double? { get set }
  var windDeg: String? { get set }
  var cityName: String? { get set }
  var description: String? { get set }
  var icon: String? { get set }
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
  var pressure: Int?
  var humidity: Int?
  var temperature: Int?
  var image: UIImage?
  var windSpeed: Double?
  var windDeg: String?
  var cityName: String?
  var description: String?
  var icon: String?
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
      switch result {
      case .success(let weather):
        self.pressure = weather.main.pressure
        self.windSpeed = weather.wind.speed
        self.humidity = weather.main.humidity
        self.temperature = Int(weather.main.temp - 273.15)
        self.windDeg = self.getCommonDegrees(deg: weather.wind.deg)
        self.cityName = weather.name
        self.description = weather.weather.first?.description
        self.icon = weather.weather.first?.icon
        DispatchQueue.main.async {
          self.updateView?()
          self.didRequestEnd?()
        }
        
      case .failure(let networkError):
        DispatchQueue.main.async {
          self.delegate?.showNetworkError(networkError: networkError) { [weak self] in
            self?.getWeather()
          }
          self.didRequestEnd?()
        }
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
