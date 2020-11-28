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
   /**
    * Reads an NDEF message
    * - Note: Will be invoked when the session finds a new tag
    * - Note: Each time the reader session retrieves a new NDEF message, the session sends the message to the delegate by calling the readerSession(_:didDetectNDEFs:) method. This is the app’s opportunity to do something useful with the data. For instance, the sample app stores the message so the user can view it later.
    * - Parameter messages: Get an array of detected messages, each of which can contain one or more records describing a single piece of data.
    */
   func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
      messages.flatMap { $0.records }.forEach { record in
         if let string = String(data: record.payload, encoding: .ascii) {
            print(string)
         }
      }
   }
   /**
    * Becomes invalid due to ending the session or encountering an error
    * - Note: Will be invoked when an error has occurred or the scanning session has ended.
    */
   func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
      // Check the invalidation reason from the returned error.
      if let error = error as? NFCReaderError,
         // Show an alert when the invalidation reason is not because of a
         // successful read during a single-tag read session, or because the
         // user canceled a multiple-tag read session from the UI or
         // programmatically using the invalidate method call.
         // - Fixme: ⚠️️ use .contains here
         error.code != .readerSessionInvalidationErrorFirstNDEFTagRead &&
            error.code != .readerSessionInvalidationErrorUserCanceled {
         completion?(.failure(NFCError.invalidated(message: error.localizedDescription)))
      }
      self.session = nil // To read new tags, a new session instance is required.
      completion = nil
   }
}
/**
 * Read - alert
 */
extension NFCManager {
   /**
    * read
    */
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
