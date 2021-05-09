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
  }

protocol MapViewModelDelegate: class {
  func showWeather(city: String)
}

final class MapViewModel: MapViewModelProtocol {
  weak var delegate: MapViewModelDelegate?
  var city: String?
  var coordinate: CLLocationCoordinate2D?
  var coordinateString: String?
  var location: CLLocation?
  var didRequestShowCard: (() -> Void)?
  var didRequestHideCard: (() -> Void)?
  var didRequestShowError: (() -> Void)?
  var didRequestStart: (() -> Void)?
  var didRequestEnd: (() -> Void)?
  let geocodingService = GeocodingService()
  var geocoder = CLGeocoder()

  func showWeather() {
    if let city = city {
      delegate?.showWeather(city: city)
    }
  }
  // Request Show Card
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
      case .failure(let error):
        DispatchQueue.main.async {
          self?.didRequestHideCard?()
          self?.didRequestEnd?()
        }
        print(error)
      }
    }
  }
  
  func requestLocationCard(coordinate: CLLocationCoordinate2D) {
    self.coordinate = coordinate
    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    self.coordinateString = location.dms
    getCityName(location: location)
  }
}
