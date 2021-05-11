import Foundation

struct CityWeather: Codable {
  let weather: [Weather]
  let main: MainWeather
  let wind: Wind
  let name: String
}
