#if os(iOS)
import CoreNFC
/**
 * NFCWriter
 * - Fixme: ⚠️️ this class can be pure static
 */
final class NFCWriter: NSObject {
   static let shared: NFCWriter = .init()
   var onWriteCompleted: WriteCompleted?
}
#endif
