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
  func requestShowLocationCard(coordinate: CLLocationCoordinate2D)
  func requestHideLocationCard()
  func showWeather()
  func requestShowLocationCard(text: String)
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
  
  func showWeather() {
    if let city = city {
      delegate?.showWeather(city: city)
    }
  }
  
  func requestHideLocationCard() {
    coordinateString = nil
    city = nil
    coordinate = nil
    didRequestHideCard?()
  }
  
  private func requestShowLocationCard(city: String, coordinate: CLLocationCoordinate2D) {
    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    coordinateString = location.coordinateString
    self.city = city
    self.coordinate = coordinate
    didRequestShowCard?()
  }
  
  func requestShowLocationCard(text: String) {
    didRequestStart?()
    geocodingService.getLocationCoordinate(city: text) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let coordinate):
          self?.requestShowLocationCard(city: text, coordinate: coordinate)
        case .failure( _):
          self?.requestHideLocationCard()
        }
        self?.didRequestEnd?()
      }
    }
  }
  
  func requestShowLocationCard(coordinate: CLLocationCoordinate2D) {
    didRequestStart?()
    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    geocodingService.getLocationName(location: location) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let city):
          self?.requestShowLocationCard(city: city, coordinate: coordinate)
        case .failure(let error):
          self?.requestHideLocationCard()
        }
        self?.didRequestEnd?()
      }
    }
  }
}
