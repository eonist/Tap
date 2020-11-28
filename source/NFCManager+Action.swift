import Foundation
import CoreNFC
/**
 * Action
 */
extension NFCManager {
   /**
    * Perform action
    * ## Example:
    * NFCManager.performAction(.setupLocation(locationName: self.locationName)) // prep
    * NFCManager.performAction(.readLocation) { location in // read
    *    self.locationModel = try? location.get()
    * }
    * NFCManager.performAction(.addVisitor(visitorName: self.visitorName)) { location in
    *    self.locationModel = try? location.get()
    *    self.visitorName = ""
    * }
    */
   static func performAction(_ action: NFCAction, completion: LocationReadingCompletion? = nil) {
      guard NFCNDEFReaderSession.readingAvailable else {
         completion?(.failure(NFCError.unavailable))
         print("NFC is not available on this device")
         return
      }
      shared.action = action
      shared.completion = completion
      shared.session = NFCNDEFReaderSession(
         delegate: shared.self,
         queue: nil,
         invalidateAfterFirstRead: false)
      shared.session?.alertMessage = action.alertMessage
      shared.session?.begin()
   }
}
