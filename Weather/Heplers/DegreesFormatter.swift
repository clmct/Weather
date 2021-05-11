import Foundation

struct DegreesFormatter {
  var degrees: Int
  
  func convertToCompassDirection() -> String {
    switch degrees {
    case 0...90:
      return "N"
    case 90...180:
      return "E"
    case 180...270:
      return "S"
    case 270...360:
      return "W"
    default:
      return ""
    }
  }
}
