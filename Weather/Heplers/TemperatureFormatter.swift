import Foundation

struct TemperatureFormatter {
  static func convertKelvinToCelsius(temperature: Double) -> Double {
    return temperature - 273.15
  }
}
