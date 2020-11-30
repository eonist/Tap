import UIKit
import CoreNFC

class ViewController: UIViewController {
   override func viewDidLoad() {
      super.viewDidLoad()
      view = View()
      view.backgroundColor = .orange
      (view as? View)?.button.addTarget(self, action: #selector(buttonTouched), for: .touchUpInside)
      (view as? View)?.writebutton.addTarget(self, action: #selector(writeButtonTouched), for: .touchUpInside)
   }
   override var prefersStatusBarHidden: Bool { return false }
}
/**
 * Event
 */
extension ViewController {
   @objc func buttonTouched(sender: UIButton!) {
      beginScanning()
   }
   @objc func writeButtonTouched(sender: UIButton!) {
      beginWrite()
   }
}
/**
 * Action
 */
extension ViewController {
   /**
    * read (begin scanning)
    */
   func beginScanning() {
      guard NFCNDEFReaderSession.readingAvailable else {
         let alertController = UIAlertController(
            title: "Scanning Not Supported",
            message: "This device doesn't support tag scanning.",
            preferredStyle: .alert
         )
         alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         self.present(alertController, animated: true, completion: nil)
         return
      }
      // move somewhere else
      NFCReader.shared.scanTag { result in
         switch result {
         case .success(let value):
            Swift.print("success")
            NFCReader.shared.read(tag: value.tag, status: value.status) { result in // read
               let data: Data? = try? result.get()
               Swift.print("Payload:  \(String(describing: String(data: data!, encoding: .utf8)))")
            }
         case .failure(let error):
            let alertController = UIAlertController(
               title: "Session Invalidated",
               message: error.localizedDescription,
               preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            DispatchQueue.main.async {
               self.present(alertController, animated: true, completion: nil)
            }
         }
      }
   }
   /**
    * Write
    * - Note: To write to a tag, the sample app starts a new reader session. This session must be active to write an NDEF message to the tag, so this time, invalidateAfterFirstRead is set to false, preventing the session from becoming invalid after reading the tag.
    * - Note: writes to one tag only
    * - Note: "Hold your iPhone near an NDEF tag to write the message."
    */
   func beginWrite() {
      NFCWriter.shared.write(data: "Hello world".data(using: .utf8)!) { result in
         let data: Data? = try? result.get()
         Swift.print("data.count:  \(String(describing: data?.count))")
      }
   }
}
