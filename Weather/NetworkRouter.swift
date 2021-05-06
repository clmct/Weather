import Foundation

enum NetworkRouter {
  
  case getWeather(city: String, key: String)
  case getImage(code: String)
  
  var scheme: String {
    switch self {
    case .getWeather, .getImage:
      return "https"
    }
  }
  
  var host: String {
    let base = "api.openweathermap.org"
    switch self {
    case .getWeather, .getImage:
      return base
    }
  }
  
  var path: String {
    switch self {
    case .getWeather:
      return "/data/2.5/weather"
    case .getImage:
      return "img/wn"
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
}
