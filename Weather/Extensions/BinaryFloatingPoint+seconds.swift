import Foundation

extension BinaryFloatingPoint {
  var seconds: Float {
    let seconds = Float(self * 3600).truncatingRemainder(dividingBy: 60)
    return seconds
  }
}
