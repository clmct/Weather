import Foundation
import MapKit

protocol MapViewModelProtocol {
  var city: String? { get }
  var coordinate: CLLocationCoordinate2D? { get }
  var coordinateString: String? { get }
  var didRequestShowCard: (() -> Void)? { get set }
  var didRequestHideCard: (() -> Void)? { get set }
  var didRequestShowError: (() -> Void)? { get set }
  var didRequestStart: (() -> Void)? { get set }
  var didRequestEnd: (() -> Void)? { get set }
  var delegate: MapViewModelDelegate? { get set }
  func requestLocationCard(coordinate: CLLocationCoordinate2D)
  func showWeather()
  func updateSearchResults(text: String)
  }

protocol MapViewModelDelegate: class {
  func showWeather(city: String)
}

final class MapViewModel: MapViewModelProtocol {
  var city: String?
  var coordinate: CLLocationCoordinate2D?
  var coordinateString: String?
  var didRequestShowCard: (() -> Void)?
  var didRequestHideCard: (() -> Void)?
  var didRequestShowError: (() -> Void)?
  var didRequestStart: (() -> Void)?
  var didRequestEnd: (() -> Void)?
  weak var delegate: MapViewModelDelegate?
  
  private let geocodingService: GeocodingServiceProtocol

  init(geocodingService: GeocodingServiceProtocol) {
    self.geocodingService = geocodingService
  }
  
  func updateSearchResults(text: String) {
    didRequestStart?()
    geocodingService.getLocationCoordinate(city: text) { [weak self] result in
      switch result {
      case .success(let coordinate):
        DispatchQueue.main.async {
          let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
          self?.coordinateString = location.coordinateString
          self?.coordinate = coordinate
          self?.city = text
          self?.didRequestShowCard?()
          self?.didRequestEnd?()
        }
      case .failure(_):
        DispatchQueue.main.async {
          self?.city = nil
          self?.coordinateString = nil
          self?.didRequestHideCard?()
          self?.didRequestEnd?()
        }
      }
    }
  }
  
  func getCityName(location: CLLocation) {
    didRequestStart?()
    geocodingService.getLocationName(location: location) { [weak self] result in
      switch result {
      case .success(let city):
        DispatchQueue.main.async {
          self?.city = city
          self?.didRequestShowCard?()
          self?.didRequestEnd?()
        }
      case .failure(_):
        DispatchQueue.main.async {
          self?.city = nil
          self?.didRequestHideCard?()
          self?.didRequestEnd?()
        }
      }
    }
  }
  
  func showWeather() {
    if let city = city {
      delegate?.showWeather(city: city)
    }
  }
  
  func requestLocationCard(coordinate: CLLocationCoordinate2D) {
    self.coordinate = coordinate
    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    self.coordinateString = location.coordinateString
    getCityName(location: location)
  }
}
