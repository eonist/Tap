import CoreNFC
/**
 * Private
 */
extension NFCWriter {
   /**
    * Helper
    */
   func handleError(_ error: Error, session: NFCNDEFReaderSession?) {
      session?.alertMessage = error.localizedDescription
      session?.invalidate()
   }
}
