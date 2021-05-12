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
    guard let url = router.getURL() else {
      DispatchQueue.main.async {
        completion(.failure(.serverResponse))
      }
      Logger.serverError(messageLog: "url error")
      return
    }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = router.method
    
    let config = URLSessionConfiguration.default
    config.waitsForConnectivity = true
    config.timeoutIntervalForResource = 60
    
    URLSession(configuration: config).dataTask(with: urlRequest) { data, response, error in
      
      if self.checkData(data: data), self.checkResponse(response: response), self.checkError(error: error) {
      } else {
        DispatchQueue.main.async {
          completion(.failure(.serverResponse))
        }
        return
      }
      
      guard let data = data else {
        DispatchQueue.main.async {
          completion(.failure(.noInternet))
        }
        return
      }
      do {
        let jsonObject = try JSONDecoder().decode(T.self, from: data)
        DispatchQueue.main.async {
          completion(.success(jsonObject))
        }
      } catch {
        DispatchQueue.main.async {
          completion(.failure(.serverResponse))
        }
        Logger.serverError(messageLog: "decode isn't success")
      }
    }.resume()
  }

  private func checkResponse(response: URLResponse?) -> Bool {
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
      Logger.serverError(messageLog: "response error, status is not success")
      return false
    }
    
    return true
  }
  
  private func checkData(data: Data?) -> Bool {
    if data == nil {
      Logger.serverError(messageLog: "data isn't valid")
      return false
    }
    return true
  }
  
  private func checkError(error: Error?) -> Bool {
    guard error == nil else {
      Logger.serverError(messageLog: error.debugDescription)
      return false
    }
    return true
  }
}

// MARK: NetworkServiceProtocol
extension NetworkService: NetworkServiceProtocol {
  func getWeather(city: String, completion: @escaping (Result<CityWeather, NetworkError>) -> Void) {
    
    guard let key = Bundle.main.object(forInfoDictionaryKey: "Token") as? String else {
      completion(.failure(.serverResponse))
      return
    }
    
    self.fetch(router: .getWeather(city: city, key: key)) { (result: Result<CityWeather, NetworkError>) in
      completion(result)
    }
  }
}
