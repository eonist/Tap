#if os(iOS)
import CoreNFC
/**
 * NFCReader
 * - Fixme: ⚠️️ add doc
 */
final class NFCReader: NSObject {
   static let shared: NFCReader = .init()
   /**
    * We need to store it in memory so it stays active
    */
   var session: NFCNDEFReaderSession?
   var onReadCompleted: ReadCompleted?
   var onTagDetected: OnTagDetected?
}
#endif
