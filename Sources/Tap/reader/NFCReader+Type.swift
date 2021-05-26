#if os(iOS)
import Foundation
import CoreNFC
/**
 * Type & const
 * - Fixme: ⚠️️ add doc
 */
extension NFCReader {
   typealias OnTagDetected = (Result<(tag: NFCNDEFTag, status: NFCNDEFStatus), Error>) -> Void
   typealias ReadCompleted = (Result<(Data), Error>) -> Void
}
#endif
