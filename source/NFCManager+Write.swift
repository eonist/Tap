import Foundation
import CoreNFC
/**
 * Write to tag
 */
extension NFCManager {
   /**
    * 
    */
   func createLocation(_ location: Location, tag: NFCNDEFTag) {
      read(tag: tag) { _ in
         self.updateLocation(location, tag: tag)
      }
   }
   private func updateLocation(_ location: Location, withVisitor visitor: Visitor? = nil, tag: NFCNDEFTag) {
      // 1
      let alertMessage = "Successfully setup location."
      _ = alertMessage
      let tempLocation = location
      _ = tempLocation
      
 
      let jsonEncoder = JSONEncoder()
      _ = jsonEncoder
      guard let customData = Optional(Data.init()) /*try? jsonEncoder.encode(tempLocation)*/ else {
         self.handleError(NFCError.invalidated(message: "Bad data"))
         return
      }
 
      let payload = NFCNDEFPayload(
         format: .unknown,
         type: Data(),
         identifier: Data(),
         payload: customData)
 
      let message = NFCNDEFMessage(records: [payload])
      _ = message
      
      tag.queryNDEFStatus { _, capacity, _ in
 
         guard message.length <= capacity else {
            self.handleError(NFCError.invalidPayloadSize)
            return
         }
         
 
         tag.writeNDEF(message) { error in
            if let error = error {
               self.handleError(error)
               return
            }
            
            if self.completion != nil {
               self.read(tag: tag, alertMessage: alertMessage)
            }
         }
      }
   }
}
/**
 * create loc
 */
//   func createLocation(name: String, with tag: NFCNDEFTag) {
//      guard let payload = NFCNDEFPayload
//         .wellKnownTypeTextPayload(string: name, locale: Locale.current)
//         else {
//            handleError(NFCError.invalidated(message: "Could not create payload"))
//            return
//      }
//      let message = NFCNDEFMessage(records: [payload])
//      tag.writeNDEF(message) { error in
//         if let error = error { self.handleError(error); return }
//         self.session?.alertMessage = "Wrote location data."
//         self.session?.invalidate()
//         self.completion?(.success(Location(name: name)))
//      }
//   }
