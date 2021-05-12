import Foundation
import MapKit

enum GeocodingError: Error {
  case errorName
  case errorCoordinate
}

protocol GeocodingServiceProtocol {
  func getLocationName(location: CLLocation, completion: @escaping (Result<String, GeocodingError>) -> Void)
  func getLocationCoordinate(city: String, completion: @escaping (Result<CLLocationCoordinate2D, GeocodingError>) -> Void)
}

final class GeocodingService {
  private let geoCoder = CLGeocoder()
  
  private func getCityName(placeMark: CLPlacemark) -> String? {
    let city = placeMark.locality
    return city
  }
}

// MARK: GeocodingServiceProtocol
extension GeocodingService: GeocodingServiceProtocol {
  func getLocationCoordinate(city: String, completion: @escaping (Result<CLLocationCoordinate2D, GeocodingError>) -> Void) {
    geoCoder.geocodeAddressString(city) { placeMarks, _ in
      guard let placeMark = placeMarks?.first,
            let coordinate = placeMark.location?.coordinate else {
        DispatchQueue.main.async {
          completion(.failure(.errorCoordinate))
        }
        return
      }
      DispatchQueue.main.async {
        completion(.success(coordinate))
      }
    }
  }
  
  func getLocationName(location: CLLocation, completion: @escaping (Result<String, GeocodingError>) -> Void) {
    geoCoder.reverseGeocodeLocation(location) { [weak self] placeMarks, _ in
      guard let self = self else { return }
      guard let placeMark = placeMarks?.first,
            let city = self.getCityName(placeMark: placeMark) else {
        DispatchQueue.main.async {
          completion(.failure(.errorName))
        }
        return
      }
      DispatchQueue.main.async {
        completion(.success(city))
      }
    }
  }
}
