import Foundation
/**
 * Private
 */
extension NFCReader {
   /**
    * Error handler
    */
   func handleError(_ error: Error) {
      session?.alertMessage = error.localizedDescription
      session?.invalidate()
   }
}
