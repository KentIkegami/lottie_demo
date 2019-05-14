

import UIKit
import NVActivityIndicatorView

class GetLottieViewContoroller: UIViewController,UITextFieldDelegate,NVActivityIndicatorViewable {
    
    private var lottieURLForm:UITextField!
    private var getButton:UIButton!
    private var textLabel:UILabel!
    private var activeIndicatorView:NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hex(COLOR.BASE, alpha: 1.0)
        
        //タイトル
        title = "Get LottieFile"
        //キャンセルボタン追加
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(self.onTapCancel(sender:)))
        cancelButton.tintColor = UIColor.hex(COLOR.ACCENT, alpha: 1)
        self.navigationItem.setRightBarButton(cancelButton, animated: true)
        
        /*-------------------------------------------------------------------------
         フォーム
         -------------------------------------------------------------------------*/
        //サイズ
        lottieURLForm = UITextField.init(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: UIScreen.main.bounds.size.width*9/10,
                                                    height: 30))
        lottieURLForm.layer.position = CGPoint(x: UIScreen.main.bounds.size.width*1/2,
                                            y: UIScreen.main.bounds.size.height*1.5/10)
        
        lottieURLForm.layer.masksToBounds = true
        lottieURLForm.layer.cornerRadius = 3.0
        //背景関係
        lottieURLForm.backgroundColor = UIColor.hex(COLOR.BASE, alpha: 1)
        lottieURLForm.layer.borderWidth = 3
        lottieURLForm.layer.borderColor = UIColor.hex(COLOR.ACCENT, alpha: 1).cgColor
        
        //パディング
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 5))
        lottieURLForm.leftView = paddingView
        lottieURLForm.leftViewMode = .always
        //クリアボタン
        lottieURLForm.clearButtonMode = UITextField.ViewMode.whileEditing
        //文字関係
        lottieURLForm.font = UIFont.systemFont(ofSize: 18)
        lottieURLForm.textAlignment = .center
        lottieURLForm.placeholder = "input URL (https://~.json)"
        lottieURLForm.delegate = self
        if UserDefaults.standard.object(forKey: "url") != nil {
            lottieURLForm.text = UserDefaults.standard.string(forKey: "url")
        }
        self.view.addSubview(lottieURLForm)
        
        /*-------------------------------------------------------------------------
         GETボタン
         -------------------------------------------------------------------------*/
        //サイズ
        getButton = UIButton.init(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: UIScreen.main.bounds.size.width*9/10,
                                                  height: 30))
        getButton.layer.position = CGPoint(x: UIScreen.main.bounds.size.width*1/2,
                                             y: UIScreen.main.bounds.size.height*2/10)
        
        getButton.isUserInteractionEnabled = true
        getButton.addTarget(self,
                              action: #selector(onTap(sender:)),
                              for: .touchUpInside)
        //アンカーポイントの変更 CGPoint(x:0.5, y:0.5)
        getButton.layer.anchorPoint = CGPoint(x:0.5, y:0.5)
        //複数選択制御
        getButton.isExclusiveTouch = true
        //背景
        getButton.setBackgroundImage(self.createImageFromUIColor(color: UIColor.hex(COLOR.ACCENT, alpha: 1.0)), for: .normal)
        getButton.setBackgroundImage(self.createImageFromUIColor(color: UIColor.hex(COLOR.ACCENT, alpha: 1.0)), for: .highlighted)
        getButton.layer.masksToBounds = true
        getButton.layer.cornerRadius = 3.0
        getButton.showsTouchWhenHighlighted = true
        //タイトル関係
        getButton.setTitle(NSLocalizedString("Get", comment: ""), for: .normal)
        getButton.titleLabel?.font = UIFont(name: "Helvetica", size: 22)
        getButton.setTitleColor(UIColor.hex(COLOR.BASE, alpha: 1.0), for: .normal)
        getButton.setTitle(NSLocalizedString("Get", comment: ""), for: .highlighted)
        getButton.setTitleColor(UIColor.hex(COLOR.BASE, alpha: 1.0), for: .highlighted)
        
        self.view.addSubview(getButton)
        
        /*-------------------------------------------------------------------------
         テキスト
         -------------------------------------------------------------------------*/
        textLabel = UILabel(frame:CGRect(x: 0,
                                          y: 0,
                                          width: CGFloat(UIScreen.main.bounds.size.width)*8/10,
                                          height: 300))
        textLabel.layer.position = CGPoint(x: CGFloat(UIScreen.main.bounds.size.width)/2,
                                            y:  CGFloat(UIScreen.main.bounds.size.height)*4/10)
        textLabel.text =
        """
        You can get animation json file in various ways.
        
        - AirDrop
        - iTunse File Sharing
        - E-mail Attached File
        - Messenger,Slack or LINE
        - URL(This page.)
        """
        textLabel.textAlignment = NSTextAlignment.left
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFont(ofSize: 22)
        textLabel.textColor = UIColor.hex(COLOR.FONT, alpha: 1.0)
        self.view.addSubview(textLabel)
        
        
        //インジケータービュー
        self.activeIndicatorView = NVActivityIndicatorView(frame: self.view.frame,
                                                           type: NVActivityIndicatorType.ballGridBeat,
                                                           color: UIColor.hex(COLOR.ACCENT, alpha: 0.9),
                                                           padding: 350)
        self.activeIndicatorView.backgroundColor = UIColor.hex(COLOR.BASE, alpha: 0.7)
        self.tabBarController?.view.addSubview(self.activeIndicatorView)
        self.view.addSubview(activeIndicatorView)
    }
    
    //戻る
    @objc internal func onTapCancel(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onTap (sender:UIButton){
        UserDefaults.standard.set(lottieURLForm.text, forKey: "url")
        self.getLottie()
    }
    
    private func getLottie(){
        self.activeIndicatorView.startAnimating()
        GetJson.fetch(url: lottieURLForm.text ?? "") { errorOrJson in
            DispatchQueue.main.async {
                self.activeIndicatorView.stopAnimating()
            }
            switch errorOrJson {
            case let .left(error):
                let errorStr = "Message:\(error)"
                DispatchQueue.main.async {
                    self.errorMmessage(message: errorStr)
                    print(errorStr)
                }
            case let .right(response):
                DispatchQueue.main.async {
                self.saveJson(json: response, url: self.lottieURLForm.text!)
                }
                print(response)
            }
        }
    }
    
    private func saveJson(json:String, url: String){
        
        if let dir = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask ).first {
            let filePath = dir.appendingPathComponent( fileName(_str: url)+".json")
            let text: String = json
            do {
                print("filePath: \(filePath)") 
                try text.write(to: filePath, atomically: true, encoding: .utf8)
                UserDefaults.standard.set(fileName(_str: url)+".json", forKey: "filename")
                self.dismiss(animated: true, completion: nil)
                
            } catch {
                print("error")
            }
        }
    }
    
    private func fileName(_str:String)->String{
        var str = _str
        if let range = str.range(of: "http://") {
            str = str.replacingCharacters(in:range, with: "")
        }
        
        if let range = str.range(of: "https://") {
            str = str.replacingCharacters(in:range, with: "")
        }
        
        if let range = str.range(of: ".json") {
            str = str.replacingCharacters(in:range, with: "")
        }
        
        while true {
            if let range = str.range(of: "/") {
                str = str.replacingCharacters(in:range, with: "_")
            } else {
                break
            }
        }
        
        return str
    }
    
    /*-------------------------------------------------------------------------
     other
     -------------------------------------------------------------------------*/
    func errorMmessage(message:String){
        let alert: UIAlertController = UIAlertController(title: "Error", message: message, preferredStyle:  UIAlertController.Style.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "Back", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            
        })
        
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    //どこかをタッチしたら呼び出されるメソッド
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    //改行、または、Returnキーが押されたら呼び出されるメソッド
    func textFieldShouldReturn(_ textField:UITextField) -> Bool{
        self.view.endEditing(true)
        return false
    }
    
    private func createImageFromUIColor(color: UIColor) -> UIImage{
        // 1x1のbitmapを作成
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        // bitmapを塗りつぶし
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        // UIImageに変換
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
}

