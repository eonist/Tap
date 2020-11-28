import Foundation
import CoreNFC
/**
 * Detection
 */
extension NFCManager {
   /**
    * Detect
    */
   func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
      guard let tag = tags.first, tags.count == 1 else {
         session.alertMessage = """
         There are too many tags present. Remove all and then try again.
         """
         DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(500)) {
            session.restartPolling()
         }
         return
      }
      session.connect(to: tag) { error in
         if let error = error {
            self.handleError(error)
            return
         }
         tag.queryNDEFStatus { status, _, error in
            if let error = error {
               self.handleError(error)
               return
            }
            switch (status, self.action) {
            case (.notSupported, _):
               session.alertMessage = "Unsupported tag."
               session.invalidate()
            case (.readOnly, _):
               session.alertMessage = "Unable to write to tag."
               session.invalidate()
            case (.readWrite, .setupLocation(let locationName)):
               self.createLocation(Location(name: locationName), tag: tag)
            case (.readWrite, .readLocation):
               self.read(tag: tag)
            default:
               return
            }
         }
      }
   }
}
/**
 * NFC NDEF Reader Session Delegate (message)
 */
extension NFCManager: NFCNDEFReaderSessionDelegate {
   func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
      // Not used
   }
   func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
      if let error = error as? NFCReaderError,
         error.code != .readerSessionInvalidationErrorFirstNDEFTagRead &&
            error.code != .readerSessionInvalidationErrorUserCanceled {
         completion?(.failure(NFCError.invalidated(message: error.localizedDescription)))
      }
      
      self.session = nil
      completion = nil
   }
}
/**
 * Read - alert
 */
extension NFCManager {
   func readLocation(from tag: NFCNDEFTag) {
      // 1
      tag.readNDEF { message, error in
         if let error = error {
            self.handleError(error)
            return
         }
         guard let message = message, let location = Location(message: message) else {
            self.session?.alertMessage = "Could not read tag data."
            self.session?.invalidate()
            return
         }
         self.completion?(.success(location))
         self.session?.alertMessage = "Read tag."
         self.session?.invalidate()
      }
   }
}
/**
 * Private
 */
extension NFCManager {
   /*private*/ func handleError(_ error: Error) {
      session?.alertMessage = error.localizedDescription
      session?.invalidate()
   }
}
/**
 * process msg
 */
extension NFCManager {
   /**
    * decode raw data to types
    * - parameter readCompletion: Call a completion handler and pass the message to it. This will be useful for chaining multiple NFC tasks together.
    */
   func read(tag: NFCNDEFTag, alertMessage: String = "Tag Read", readCompletion: NFCReadingCompletion? = nil) {
      tag.readNDEF { message, error in
         if let error = error {
            self.handleError(error)
            return
         }
         if let readCompletion = readCompletion,
            let message = message {
            readCompletion(.success(message))
         } else if
            let message = message,
            let record = message.records.first,
            let location = Location.init(message: NFCNDEFMessage.init(data: .init())) { //try? JSONDecoder().decode(Location.self, from: record.payload) {
            _ = record
            self.completion?(.success(location))
            self.session?.alertMessage = alertMessage
            self.session?.invalidate()
         } else {
            self.session?.alertMessage = "Could not decode tag data."
            self.session?.invalidate()
         }
      }
   }
}
