import Foundation

enum NFCAction {
   case setupLocation(locationName: String)
   case readLocation
   var alertMessage: String { "Hold near device to share" } // "Hold your iPhone near the item to learn more about it."
}
