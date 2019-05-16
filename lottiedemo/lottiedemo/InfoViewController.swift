
import UIKit

class InfoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hex(COLOR.BASE, alpha: 1.0)
        
        //タイトル
        title = "App Info"
        //キャンセルボタン追加
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(self.onTapCancel(sender:)))
        cancelButton.tintColor = UIColor.hex(COLOR.ACCENT, alpha: 1)
        self.navigationItem.setRightBarButton(cancelButton, animated: true)
        
        
    }
    
    //戻る
    @objc internal func onTapCancel(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
}
