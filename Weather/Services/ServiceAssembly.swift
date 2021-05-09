import Foundation

protocol ServiceAssemblyProtocol {
  var networkService: NetworkServiceProtocol { get }
  var geocodingService: GeocodingServiceProtocol { get }
}

final class ServiceAssembly: ServiceAssemblyProtocol {
  var networkService: NetworkServiceProtocol = NetworkService()
  var geocodingService: GeocodingServiceProtocol = GeocodingService()
}
