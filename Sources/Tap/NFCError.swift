#if os(iOS)
import Foundation

enum NFCError: Error {
   case unavailable
   case invalidated(message: String)
   case invalidPayloadSize
}
#endif
