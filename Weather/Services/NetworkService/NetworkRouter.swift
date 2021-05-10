import Foundation

enum NetworkRouter {
  
  case getWeather(city: String, key: String)
  case getImage(code: String)
  
  var scheme: String {
    switch self {
    case .getWeather:
      return "https"
    case .getImage:
      return "http"
    }
  }
  
  var host: String {
    switch self {
    case .getWeather:
      return "api.openweathermap.org"
    case .getImage:
      return "openweathermap.org"
    }
  }
  
  var path: String {
    switch self {
    case .getWeather:
      return "/data/2.5/weather"
    case .getImage(let code):
      return "/img/wn/\(code)@2x.png"
    }
  }
  
  var method: String {
    switch self {
    case .getWeather, .getImage:
      return "GET"
    }
  }
  
  var queryItems: [URLQueryItem] {
    switch self {
    case .getWeather(let city, let key):
      return [
        URLQueryItem(name: "q", value: city),
        URLQueryItem(name: "appid", value: key)]
    case .getImage:
      return [URLQueryItem]()
    }
  }
  
  func getURL() -> URL? {
    var components = URLComponents()
    components.scheme = self.scheme
    components.host = self.host
    components.path = self.path
    components.queryItems = self.queryItems
    return components.url
  }
}
