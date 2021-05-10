import Foundation
import MapKit

enum GeocodingError: Error {
  case error
}

protocol GeocodingServiceProtocol {
  func getLocationName(location: CLLocation, completion: @escaping (Result<String, GeocodingError>) -> Void)
  func getLocationCoordinate(city: String, completion: @escaping (Result<CLLocationCoordinate2D, GeocodingError>) -> Void)
}

final class GeocodingService {
  private let geocoder = CLGeocoder()
  
  private func getCityName(placeMark: CLPlacemark) -> String? {
    let city = placeMark.locality
    return city
  }
}

// MARK: GeocodingServiceProtocol
extension GeocodingService: GeocodingServiceProtocol {
  func getLocationCoordinate(city: String, completion: @escaping (Result<CLLocationCoordinate2D, GeocodingError>) -> Void) {
    geocoder.geocodeAddressString(city) { placeMarks, error in
      guard let placeMark = placeMarks?.first,
            let coordinate = placeMark.location?.coordinate else {
        completion(.failure(.error))
        return
      }
      completion(.success(coordinate))
    }
  }
  
  func getLocationName(location: CLLocation, completion: @escaping (Result<String, GeocodingError>) -> Void) {
    geocoder.reverseGeocodeLocation(location) { [weak self] placeMarks, error in
      guard let self = self else { return }
      guard let placeMark = placeMarks?.first,
            let city = self.getCityName(placeMark: placeMark) else {
        completion(.failure(.error))
        return
      }
      completion(.success(city))
    }
  }
}
