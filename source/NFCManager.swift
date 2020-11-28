import CoreNFC
/**
 * NFCManager
 */
final class NFCManager: NSObject {
   static let shared: NFCManager = .init()
   var action: NFCAction?
   var session: NFCNDEFReaderSession?
   var completion: LocationReadingCompletion?
}
