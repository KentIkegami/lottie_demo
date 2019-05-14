

import UIKit

class PlayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hex(COLOR.BASE, alpha: 1.0)
        
        //追加ボタン追加
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(self.onTap(sender:)))
        addButton.tag = 0
        addButton.tintColor = UIColor.hex(COLOR.ACCENT, alpha: 1)
        self.navigationItem.setRightBarButton(addButton, animated: true)
        
        //リストボタン追加
        let listButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.organize, target: self, action: #selector(self.onTap(sender:)))
        listButton.tag = 1
        listButton.tintColor = UIColor.hex(COLOR.ACCENT, alpha: 1)
        self.navigationItem.setLeftBarButton(listButton, animated: true)
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.object(forKey: "filename") != nil {
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let path = documentDirectoryURL.appendingPathComponent( UserDefaults.standard.object(forKey: "filename") as! String)
            
            print(path.absoluteString)
            if FileManager.default.fileExists(atPath: path.path) {
                title = UserDefaults.standard.string(forKey: "filename")//タイトル設定
                //アニメーション準備処理
                
            }else{
                UserDefaults.standard.removeObject(forKey: "filename")//削除
                title = ""
            }
        }
    }
    
    
    //画面遷移アクション
    @objc internal func onTap(sender: UIButton){
        if sender.tag == 0 {
            let next = GetLottieViewContoroller()
            next.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            let nav: UINavigationController = UINavigationController(rootViewController: next)
            self.present(nav, animated: true, completion: nil)
        }else{
            let next = FileListViewController()
            next.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            let nav: UINavigationController = UINavigationController(rootViewController: next)
            self.present(nav, animated: true, completion: nil)
        }
        
    }
}

