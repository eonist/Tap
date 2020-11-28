import Foundation
import CoreNFC

struct Location/*: Decodable*/  {
   let message: NFCNDEFMessage?
   let name: String
   init?(message: NFCNDEFMessage? = nil) {
      self.name = ""
      self.message = message
   }
   init(name: String) {
      self.name = name
      self.message = nil
   }
   func setupLocation(name: String, location: String) {
      Swift.print("not implemented")
   }
}
