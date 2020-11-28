import CoreNFC
/**
 * NFCManager
 */
final class NFCManager: NSObject {
   static let shared: NFCManager = .init()
   var action: NFCAction?
   /**
    * we need to store it in memory so it stays active
    */
   var session: NFCNDEFReaderSession?
   var completion: LocationReadingCompletion?
}
