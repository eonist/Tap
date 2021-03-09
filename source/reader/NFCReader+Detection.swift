import CoreNFC
/**
 * Detection
 */
extension NFCReader {
   /**
    * Detect
    * - Fixme: ⚠️️ add doc
    */
   func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
      guard let tag = tags.first, tags.count == 1 else {
         session.alertMessage = Self.multipleTagMessage
         DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(500)) {
            session.restartPolling()
         }
         return
      }
      session.connect(to: tag) { error in // Connect to the found tag and write an NDEF message to it.
         if let error = error { self.handleError(error); return } // Unable to connect to tag.
         tag.queryNDEFStatus { (ndefStatus: NFCNDEFStatus, capacity: Int, error: Error?) in
            if let error = error { self.handleError(error); return }
            self.onTagDetected?(.success((tag, ndefStatus)))
         }
      }
   }
}
