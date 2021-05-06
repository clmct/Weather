import Foundation

// MARK: - CityWeather

struct CityWeather: Codable {
    let coord: Coord
    let weather: [Weather]
    let wind: Wind
    let clouds: Clouds
    let name: String
    let cod: Int
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
  let temp: Double
  let feelsLike: Double
  let tempMin: Double
  let tempMax: Double
  let pressure: Int
  let humidity: Int
}

// MARK: - Sys
struct Sys: Codable {
  let type, id: Int
  let country: String
  let sunrise: Int
  let sunset: Int
}

// MARK: - Weather
struct Weather: Codable {
  let id: Int
  let main: String
  let description: String
  let icon: String
  
}

// MARK: - Wind
struct Wind: Codable {
  let speed: Double
  let deg: Int
}
