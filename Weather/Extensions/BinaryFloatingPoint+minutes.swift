import Foundation

extension BinaryFloatingPoint {
  var minutes: Int {
    let minutes = Int(self * 3600) % 3600 / 60
    return minutes
  }
}
