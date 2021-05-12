import Foundation

protocol HasNetworkService {
  var networkService: NetworkServiceProtocol { get }
}

protocol HasGeocodingService {
  var geocodingService: GeocodingServiceProtocol { get }
}

final class Dependencies: HasNetworkService, HasGeocodingService {
  var networkService: NetworkServiceProtocol = NetworkService()
  var geocodingService: GeocodingServiceProtocol = GeocodingService()
}
