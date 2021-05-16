import Foundation

struct CardinalDirectionFormatter {
  static func convertDegreesToNameOfCardinalDirection(degrees: Int) -> String {
    switch degrees {
    case 0...90:
      return R.string.localizable.directionNorth()
    case 90...180:
      return R.string.localizable.directionEast()
    case 180...270:
      return R.string.localizable.directionSouth()
    case 270...360:
      return R.string.localizable.directionWest()
    default:
      return ""
    }
  }
}
