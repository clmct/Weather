import Foundation
import Network

enum NetworkError: Error {
  case serverResponse
  case noInternet
}

protocol NetworkServiceProtocol {
  func getWeather(city: String, completion: @escaping (Result<CityWeather, NetworkError>) -> Void)
}

final class NetworkService {
  private func fetch<T: Codable>(router: NetworkRouter, completion: @escaping (Result<T, NetworkError>) -> Void) {
    var components = URLComponents()
    components.scheme = router.scheme
    components.host = router.host
    components.path = router.path
    components.queryItems = router.queryItems

    guard let url = components.url else {
      completion(.failure(.serverResponse))
      
      return
    }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = router.method

    let config = URLSessionConfiguration.default
    config.waitsForConnectivity = true
    config.timeoutIntervalForResource = 60

    URLSession(configuration: config).dataTask(with: urlRequest) { data, response, error in
      guard error == nil else {
        completion(.failure(.noInternet))
        
        return
      }
      print(url)
      guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
        completion(.failure(.serverResponse))
        return
      }

      guard let data = data else {
        completion(.failure(.serverResponse))
        
        return
      }

      if response.statusCode == 200 {
        do {
          let jsonObject = try JSONDecoder().decode(T.self, from: data)
          completion(.success(jsonObject))
        } catch {
          completion(.failure(.serverResponse))
          
        }
      } else {
        completion(.failure(.serverResponse))
        
      }

    }.resume()
  }
}

// MARK: NetworkServiceProtocol
extension NetworkService: NetworkServiceProtocol {
  func getWeather(city: String, completion: @escaping (Result<CityWeather, NetworkError>) -> Void) {
    
    guard let key = Bundle.main.object(forInfoDictionaryKey: "Token") as? String else {
      completion(.failure(.noInternet))
      return
    }
    print(key)
    self.fetch(router: .getWeather(city: "London", key: key)) { (result: Result<CityWeather, NetworkError>) in
      completion(result)
    }
  }
}