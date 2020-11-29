import CoreNFC
/**
 * NFCReader
 */
final class NFCReader: NSObject {
   static let shared: NFCReader = .init()
   /**
    * we need to store it in memory so it stays active
    */
   var session: NFCNDEFReaderSession?
   var onReadCompleted: ReadCompleted?
   var onTagDetected: OnTagDetected?
}
