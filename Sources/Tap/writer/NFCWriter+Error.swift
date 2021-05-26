#if os(iOS)
import CoreNFC
/**
 * Private
 */
extension NFCWriter {
   /**
    * Helper
    * - Fixme: ⚠️️ add doc
    * - Parameters:
    *   - error: - Fixme: ⚠️️ add doc
    *   - session: - Fixme: ⚠️️ add doc
    */
   func handleError(_ error: Error, session: NFCNDEFReaderSession?) {
      session?.alertMessage = error.localizedDescription
      session?.invalidate()
   }
}
#endif
