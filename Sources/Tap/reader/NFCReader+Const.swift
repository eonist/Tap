#if os(iOS)
import CoreNFC
import Foundation
/**
 * Type & const
 * - Fixme: ⚠️️ add doc
 */
extension NFCReader {
   static let alertMessage: String = "Hold device near to read" // "Hold your iPhone near the item to learn more about it."
   static let multipleTagMessage: String = "More than 1 tag is detected. Please remove all tags and try again."
}
#endif
