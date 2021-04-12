import UIKit
import CoreNFC

class View: UIView {
   lazy var button: UIButton = {
      let btn = UIButton(type: .system)
      btn.backgroundColor = UIColor.green
      btn.setTitle("Read", for: .normal)
      btn.frame = CGRect(x: 0, y: 50, width: 100, height: 50)
      self.addSubview(btn)
      return btn
   }()
   lazy var writebutton: UIButton = {
      let btn = UIButton(type: .system)
      btn.backgroundColor = UIColor.green
      btn.setTitle("Write", for: .normal)
      btn.frame = CGRect(x: 0, y: 100 + 20, width: 100, height: 50)
      self.addSubview(btn)
      return btn
   }()
   override init(frame: CGRect) {
      super.init(frame: frame)
   }
   /**
    * Boilerplate
    */
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
