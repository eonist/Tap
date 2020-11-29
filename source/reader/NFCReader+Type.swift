import Foundation
import CoreNFC
/**
 * type & const
 */
extension NFCReader {
   typealias OnTagDetected = (Result<(tag: NFCNDEFTag, status: NFCNDEFStatus), Error>) -> Void
   typealias ReadCompleted = (Result<(Data), Error>) -> Void
}
