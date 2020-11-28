import Foundation

enum NFCAction {
   case setupLocation(locationName: String)
   case readLocation
   var alertMessage: String { "not implemented" }
}
