import Foundation
import MapKit

enum GeocodingError: Error {
  case error
}

protocol GeocodingServiceProtocol {
  func getLocationName(location: CLLocation, completion: @escaping (Result<String, GeocodingError>) -> Void)
}

final class GeocodingService: GeocodingServiceProtocol {
  private let geocoder = CLGeocoder()
  
  func getLocationName(location: CLLocation, completion: @escaping (Result<String, GeocodingError>) -> Void) {
    geocoder.reverseGeocodeLocation(location) { [weak self] placeMarks, error in
      guard let self = self else { return }
      guard let placeMark = placeMarks?.first else { return }
      let city = self.getCityName(placeMark: placeMark)
      if let city = city {
        completion(.success(city))
      } else {
        completion(.failure(.error))
      }
    }
  }
  
  private func getCityName(placeMark: CLPlacemark) -> String? {
    let city = placeMark.locality
    return city
  }

}
