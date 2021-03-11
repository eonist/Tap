#if os(iOS)
import Foundation
/**
 * Private
 */
extension NFCReader {
   /**
    * Error handler
    * - Fixme: ⚠️️ add doc
    */
   func handleError(_ error: Error) {
      session?.alertMessage = error.localizedDescription
      session?.invalidate()
   }
}
#endif
