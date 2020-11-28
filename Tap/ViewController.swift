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
extension ViewController {
   @objc func buttonTouched(sender:UIButton!) {
      beginScanning()
   }
   @objc func writeButtonTouched(sender:UIButton!) {
      beginWrite()
   }
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
      NFCManager.shared.completion = { result in
         switch result {
         case .success(let value):
            Swift.print("success")
           _ = value
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
      NFCManager.performAction(.readLocation)
   }
   /**
    * write
    * - Note: To write to a tag, the sample app starts a new reader session. This session must be active to write an NDEF message to the tag, so this time, invalidateAfterFirstRead is set to false, preventing the session from becoming invalid after reading the tag.
    * - Note: writes to one tag only
    */
   func beginWrite() {
      NFCManager.shared.session = NFCNDEFReaderSession(delegate: NFCManager.shared, queue: nil, invalidateAfterFirstRead: false)
      NFCManager.shared.session?.alertMessage = "Hold your iPhone near an NDEF tag to write the message."
      NFCManager.shared.session?.begin()
   }
}
