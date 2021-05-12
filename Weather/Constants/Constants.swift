import Foundation

struct Constants {
  struct NoInternet {
    static let title = NSLocalizedString("ERROR_NO_INTERNET_TITLE", comment: "")
    static let description = NSLocalizedString("ERROR_NO_INTERNET_DESCRIPTION", comment: "")
  }
  
  struct SomethingWentWrong {
    static let title = NSLocalizedString("ERROR_SOMETHING_WENT_WRONG_TITLE", comment: "")
    static let description = NSLocalizedString("ERROR_SOMETHING_WENT_WRONG_DESCRIPTION", comment: "")
  }
  
  struct ErrorButton {
    static let title = NSLocalizedString("ERROR_BUTTON_TITLE", comment: "")
  }
  
  struct Map {
    static let showWeather = NSLocalizedString("MAP_CARD_VIEW_BTN", comment: "")
    static let title = NSLocalizedString("MAP_TITLE", comment: "")
    static let backItem = NSLocalizedString("MAP_BACK_ITEM", comment: "")
  }
  
  struct Weather {
    static let pressure = NSLocalizedString("PRESSURE", comment: "")
    static let pressureUnitOfMeasurement = NSLocalizedString("PRESSURE_UNIT_OF_MEASUREMENT", comment: "")
    static let wind = NSLocalizedString("WIND", comment: "")
    static let windUnitOfMeasurement = NSLocalizedString("WIND_UNIT_OF_MEASUREMENT", comment: "")
    static let humidity = NSLocalizedString("HUMIDITY", comment: "")
  }

  struct CardinalDirection {
    static let north = NSLocalizedString("DIRECTION_NORTH", comment: "")
    static let east = NSLocalizedString("DIRECTION_EAST", comment: "")
    static let south = NSLocalizedString("DIRECTION_SOUTH", comment: "")
    static let west = NSLocalizedString("DIRECTION_WEST", comment: "")
  }
  
  struct ErrorImage {
    static let title = NSLocalizedString("ERROR_IMAGE_TITLE", comment: "")
    static let subtitle = NSLocalizedString("ERROR_IMAGE_SUBTITLE", comment: "")
  }
  
  struct ErrorIcon {
    static let title = NSLocalizedString("ERROR_ICON_TITLE", comment: "")
    static let subtitle = NSLocalizedString("ERROR_ICON_SUBTITLE", comment: "")
  }
  
  struct DefaultLocation {
    static let latitude = 50
    static let longitude = 10
    static let meters = 2000000
  }
}
