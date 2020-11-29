import CoreNFC
/**
 * Write to tag
 */
extension NFCWriter {
   /**
    * Write
    * ## Example:
    * NFCWriter.write(data: .init()) { result in
    *    let data: Data? = try? result.get()
    * }
    */
   func write(data: Data, onWriteCompleted: @escaping WriteCompleted) {
      self.onWriteCompleted = onWriteCompleted
      NFCReader.shared.scanTag(alertMessage: "Hold near device to share") { result in
         guard let tag: NFCNDEFTag = try? result.get().tag, let status: NFCNDEFStatus = try? result.get().status else { Swift.print("cant get status or tag"); return }
         self.write(data: data, tag: tag, status: status, session: NFCReader.shared.session)
      }
   }
   /**
    * Read tag
    */
   func write(data: Data, tag: NFCNDEFTag, status: NFCNDEFStatus, session: NFCNDEFReaderSession?) {
      switch status {
      case .readWrite:
         write(data: data, tag: tag, session: session)
      case .readOnly:
         session?.alertMessage = "Tag is not writable"
         session?.invalidate()
      case .notSupported :
         session?.alertMessage = "Tag is not NDEF compliant."
         session?.invalidate()
      default:
         session?.alertMessage = "Unknown NDEF tag status."
         session?.invalidate()
      }
   }
   /**
    * write
    */
   func write(data: Data, tag: NFCNDEFTag, session: NFCNDEFReaderSession?) {
      let alertMessage = "Successfully wrote to tag"
      let payload = NFCNDEFPayload(format: .unknown, type: data, identifier: data, payload: data)
      let message = NFCNDEFMessage(records: [payload])
      _ = message
      tag.queryNDEFStatus { _, capacity, _ in
         guard message.length <= capacity else { self.handleError(NFCError.invalidPayloadSize, session: session);  return }
         tag.writeNDEF(message) { error in
            if let error = error { self.handleError(error, session: session); return }
            if self.onWriteCompleted != nil { // not sure why we read again here
               NFCReader.shared.onReadCompleted = self.onWriteCompleted
               NFCReader.shared.read(tag: tag, alertMessage: alertMessage)
            }
         }
      }
   }
}
