#if os(iOS)
import Foundation

extension NFCWriter {
   typealias WriteCompleted = (Result<Data, Error>) -> Void
}
#endif
