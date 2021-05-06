import Foundation
import MapKit

protocol GeocodingServiceProtocol {
  func getLocationName(location: CLLocation, completion: @escaping (Result<String, Error>) -> Void)
}

final class GeocodingService: GeocodingServiceProtocol {
  private let geocoder = CLGeocoder()
  
  func getLocationName(location: CLLocation, completion: @escaping (Result<String, Error>) -> Void) {
    geocoder.reverseGeocodeLocation(location) { [weak self] placeMarks, error in
      guard let self = self else { return }
      guard let placeMark = placeMarks?.first else { return }
      let city = self.getCityName(placeMark: placeMark)
      if let city = city {
        completion(.success(city))
      } else {
        guard let error = error else { return }
        completion(.failure(error))
      }
    }
  }
  
  private func getCityName(placeMark: CLPlacemark) -> String? {
    let city = placeMark.locality
    return city
  }

}
