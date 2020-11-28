import Foundation
import CoreNFC

extension NFCManager {
   typealias NFCReadingCompletion = (Result<NFCNDEFMessage?, Error>) -> Void
   typealias LocationReadingCompletion = (Result<Location, Error>) -> Void
}
