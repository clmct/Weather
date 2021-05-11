import Foundation

struct TemperatureFormatter {
  var kelvinTemperature: Double
  
  func convertKelvinToCelsius() -> Double {
    return kelvinTemperature - 273.15
  }
}
