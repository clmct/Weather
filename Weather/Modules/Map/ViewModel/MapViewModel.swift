import Foundation
import MapKit

protocol MapViewModelProtocol {
  var cityName: String? { get }
  var coordinate: CLLocationCoordinate2D? { get }
  var coordinateDescription: String? { get }
  var didRequestShowCard: (() -> Void)? { get set }
  var didRequestHideCard: (() -> Void)? { get set }
  var didRequestShowError: (() -> Void)? { get set }
  var didRequestStart: (() -> Void)? { get set }
  var didRequestEnd: (() -> Void)? { get set }
  func requestShowLocationCard(coordinate: CLLocationCoordinate2D)
  func requestHideLocationCard()
  func showWeather()
  func requestShowLocationCard(text: String)
}

protocol MapViewModelDelegate: class {
  func requiredShowWeather(cityName: String)
}

final class MapViewModel: MapViewModelProtocol {
  var cityName: String?
  var coordinate: CLLocationCoordinate2D?
  var coordinateDescription: String?
  var didRequestShowCard: (() -> Void)?
  var didRequestHideCard: (() -> Void)?
  var didRequestShowError: (() -> Void)?
  var didRequestStart: (() -> Void)?
  var didRequestEnd: (() -> Void)?
  weak var delegate: MapViewModelDelegate?
  private let geocodingService: GeocodingServiceProtocol
  typealias Dependencies = HasGeocodingService
  
  init(dependencies: Dependencies) {
    self.geocodingService = dependencies.geocodingService
  }
  
  func showWeather() {
    guard let cityName = cityName else { return }
    delegate?.requiredShowWeather(cityName: cityName)
  }
  
  func requestHideLocationCard() {
    coordinateDescription = nil
    cityName = nil
    coordinate = nil
    didRequestHideCard?()
  }
  
  func requestShowLocationCard(text: String) {
    didRequestStart?()
    geocodingService.getLocationCoordinate(city: text) { [weak self] result in
      switch result {
      case .success(let coordinate):
        self?.requestShowLocationCard(cityName: text, coordinate: coordinate)
      case .failure(let error):
        Logger.geocodingError(messageLog: error.localizedDescription)
        self?.requestHideLocationCard()
      }
      self?.didRequestEnd?()
    }
  }
  
  func requestShowLocationCard(coordinate: CLLocationCoordinate2D) {
    didRequestStart?()
    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    geocodingService.getLocationName(location: location) { [weak self] result in
      switch result {
      case .success(let cityName):
        self?.requestShowLocationCard(cityName: cityName, coordinate: coordinate)
      case .failure(let error):
        Logger.geocodingError(messageLog: error.localizedDescription)
        self?.requestHideLocationCard()
      }
      self?.didRequestEnd?()
    }
  }
  
  private func requestShowLocationCard(cityName: String, coordinate: CLLocationCoordinate2D) {
    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    self.coordinateDescription = location.coordinateDescription
    self.cityName = cityName
    self.coordinate = coordinate
    didRequestShowCard?()
  }
}
