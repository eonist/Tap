#if os(iOS)
import Foundation
/**
 * - Fixme: ⚠️️ add doc
 */
enum NFCError: Error {
   case unavailable
   case invalidated(message: String)
   case invalidPayloadSize
}
#endif
