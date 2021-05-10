import Foundation

extension BinaryFloatingPoint {
  var degrees: Int {
    let degrees = Int(self)
    return degrees
  }
  
  var minutes: Int {
    let minutes = Int(self * 3600) % 3600 / 60
    return minutes
  }
  
  var seconds: Float {
    let seconds = Float(self * 3600).truncatingRemainder(dividingBy: 60)
    return seconds
  }
}
