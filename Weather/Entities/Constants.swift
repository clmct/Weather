import Foundation

struct Constants {
  enum NoInternet: String {
    case title = "No internet"
    case description = "Try refreshing the screen when communication is restored."
  }
  
  enum SomethingWentWrong: String {
    case title = "Something went wrong"
    case description = "The problem is on our side, we are already looking into it. Please try refreshing the screen later."
  }
  
  enum DefaultLocation: Int {
    case latitude = 50
    case longitude = 10
    case meters = 2000000
  }
}
