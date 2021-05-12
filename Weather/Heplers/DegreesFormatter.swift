import Foundation

struct CardinalDirectionFormatter {
  var degrees: Int
  
  func convertToCompassDirection() -> String {
    switch degrees {
    case 0...90:
      return Constants.CardinalDirection.north
    case 90...180:
      return Constants.CardinalDirection.east
    case 180...270:
      return Constants.CardinalDirection.south
    case 270...360:
      return Constants.CardinalDirection.west
    default:
      return ""
    }
  }
}
