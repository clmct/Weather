import Foundation

struct CityWeather: Codable {
  let weather: [Weather]
  let main: Main
  let wind: Wind
  let name: String
}

