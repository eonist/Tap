#if os(iOS)
import Foundation
import CoreNFC
/**
 * Action
 */
extension NFCReader {
   /**
    * Scan tag
    * ## Example:
    * NFCReader.shared.scanTag { result in
    *    let tag: NFCNDEFTag? = try? result.get().tag
    *    let status: NFCNDEFStatus = try? result.get().status
    * }
    * - Fixme: ⚠️️ add doc
    */
   func scanTag(alertMessage: String = NFCReader.alertMessage, onTagDetected: @escaping OnTagDetected) {
      self.onTagDetected = onTagDetected
      self.session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
      self.session?.alertMessage = alertMessage
      self.session?.begin()
   }
   /**
    * Read tag
    * ## Example:
    * NFCReader.read(tag: ...) { result in // read
    *    let data = try? result.get()
    * }
    * - Fixme: ⚠️️ add doc
    */
   func read(tag: NFCNDEFTag, status: NFCNDEFStatus, onReadCompleted: ReadCompleted?) {
      switch status {
      case .readOnly:
         self.read(tag: tag)
      case .notSupported :
         session?.alertMessage = "Tag is not NDEF compliant."
         session?.invalidate()
      default:
         session?.alertMessage = "Unknown NDEF tag status."
         session?.invalidate()
      }
   }
   /**
    * Decode raw data to types
    * - Fixme: ⚠️️ add doc
    * - Parameter readCompletion: Call a completion handler and pass the message to it. This will be useful for chaining multiple NFC tasks together.
    */
   func read(tag: NFCNDEFTag, alertMessage: String = "Tag Read") {
      tag.readNDEF { message, error in
         if let error = error { self.handleError(error); return }
         guard let message = message, let record = message.records.first else {
            self.session?.alertMessage = "Could not decode tag data."
            self.session?.invalidate()
            return
         }
         self.onReadCompleted?(.success(record.payload))
         self.session?.alertMessage = alertMessage
         self.session?.invalidate()
      }
   }
}

#endif
