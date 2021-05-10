import MapKit

extension CLLocation {
  var coordinateString: String { latitude + " " + longitude }
  
  var latitude: String {
    let degrees = coordinate.latitude.degrees
    let minutes = coordinate.latitude.minutes
    let seconds = coordinate.latitude.seconds
    return String(format: "%d°%d'%.1f\"%@", abs(degrees), abs(minutes), abs(seconds), degrees >= 0 ? "N" : "S")
  }
  
  var longitude: String {
    let degrees = coordinate.longitude.degrees
    let minutes = coordinate.longitude.minutes
    let seconds = coordinate.longitude.seconds
    return String(format: "%d°%d'%.1f\"%@", abs(degrees), abs(minutes), abs(seconds), degrees >= 0 ? "E" : "W")
  }
}
