import CoreNFC
/**
 * NFC NDEF Reader Session Delegate (message)
 */
extension NFCReader: NFCNDEFReaderSessionDelegate {
   /**
    * Reads an NDEF message
    * - Note: Will be invoked when the session finds a new tag
    * - Note: Each time the reader session retrieves a new NDEF message, the session sends the message to the delegate by calling the readerSession(_:didDetectNDEFs:) method. This is the app’s opportunity to do something useful with the data. For instance, the sample app stores the message so the user can view it later.
    * - Parameter messages: Get an array of detected messages, each of which can contain one or more records describing a single piece of data.
    * - Note: messages is an array of NFCNDEFMessages, one for each scan we perform before the NFC session becomes invalidated, though in our app, we invalidate the session automatically after the first scan. We only need to worry about one object in the array.
    * - Note: records is an array of NFCNDEFPayloads. This is an array because NDEF cards can contain multiple payloads. For our use, we only will have one payload.
    */
   func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
      // - Fixme: ⚠️️ not supported yet
      print("err ⚠️️")
      messages.flatMap { $0.records }.forEach { record in
         if let string = String(data: record.payload, encoding: .ascii) {
            print(string) // result += String.init(data: payload.payload.advanced(by: 3), encoding: .utf8)! // 1
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
         onReadCompleted?(.failure(NFCError.invalidated(message: error.localizedDescription)))
      }
      self.session = nil // To read new tags, a new session instance is required.
   }
}
