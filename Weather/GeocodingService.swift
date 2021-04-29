import Foundation
import MapKit

protocol GeocodingServiceProtocol {
  func getLocationName(location: CLLocation, completion: @escaping (Result<String, Error>) -> Void)
}

final class GeocodingService: GeocodingServiceProtocol {
  private let gecocoder = CLGeocoder()
  
  func getLocationName(location: CLLocation, completion: @escaping (Result<String, Error>) -> Void) {
    gecocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
      guard let self = self else { return }
      guard let placemark = placemarks?.first else { return }
      let city = self.getCityName(placemark: placemark)
      if let city = city {
        completion(.success(city))
      } else {
        guard let error = error else { return }
        completion(.failure(error))
      }
    }
  }
  
  private func getCityName(placemark: CLPlacemark) -> String? {
    let city = placemark.locality
    return city
  }

}
