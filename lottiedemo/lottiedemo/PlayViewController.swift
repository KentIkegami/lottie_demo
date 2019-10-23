

import UIKit
import Lottie

class PlayViewController: UIViewController {
    
    public var animationView: AnimationView!
    private var speedLabel: UILabel!
    private var backChangeButton: UIButton!
    private var slider1: UISlider!
    private var slider2: UISlider!
    private var startButton: UIButton!
    private var propertyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hex(COLOR.BASE, alpha: 1.0)
        //タイマー
        Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(self.timerUpdate), userInfo: nil, repeats: true)
        
        //追加ボタン追加
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(self.onTap(sender:)))
        addButton.tag = 0
        addButton.tintColor = UIColor.hex(COLOR.ACCENT, alpha: 1)
        self.navigationItem.setRightBarButton(addButton, animated: true)
        
        //情報ボタン追加
        let infoButton = UIButton(type: .infoLight)
        infoButton.tag = 2
        infoButton.tintColor = UIColor.hex(COLOR.ACCENT, alpha: 1)
        infoButton.addTarget(self, action: #selector(self.onTap(sender:)), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        self.navigationItem.setRightBarButtonItems([addButton,infoBarButtonItem], animated: true)

        //リストボタン追加
        let listButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.organize, target: self, action: #selector(self.onTap(sender:)))
        listButton.tag = 1
        listButton.tintColor = UIColor.hex(COLOR.ACCENT, alpha: 1)
        self.navigationItem.setLeftBarButton(listButton, animated: true)
        
        //アニメ
        animationView = AnimationView()
        //animationView.backgroundColor = UIColor.red
        animationView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width)
        animationView.layer.position = CGPoint(x: UIScreen.main.bounds.size.width*1/2,y: view.bounds.width*1/2 + 100)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        view.addSubview(animationView)
        
        //スピード表示
        speedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width*0.95, height: 30))
        speedLabel.layer.position = CGPoint(x: UIScreen.main.bounds.size.width*1/2,y: 100)
        speedLabel.text = "x1.0"
        speedLabel.font = UIFont(name: "Helvetica", size: 20)
        speedLabel.textColor = UIColor.hex(COLOR.ACCENT, alpha: 1)
        speedLabel.textAlignment = .left
        view.addSubview(speedLabel)
        
        //背景ボタン
        backChangeButton = UIButton.init(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: UIScreen.main.bounds.size.width*0.95,
                                                  height: 35))
        backChangeButton.layer.position = CGPoint(x: UIScreen.main.bounds.size.width*1/2,y: 100)
        backChangeButton.isUserInteractionEnabled = true
        backChangeButton.addTarget(self,
                              action: #selector(onTapbackChangeButton(sender:)),
                              for: .touchUpInside)
        backChangeButton.layer.anchorPoint = CGPoint(x:0.5, y:0.5)//アンカーポイントの変更 CGPoint(x:0.5, y:0.5)
        backChangeButton.isExclusiveTouch = true//複数選択制御
        backChangeButton.showsTouchWhenHighlighted = true
        backChangeButton.setTitle(NSLocalizedString("Black", comment: ""), for: .normal)
        backChangeButton.contentHorizontalAlignment = .right
        backChangeButton.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        backChangeButton.setTitleColor(UIColor.hex(COLOR.ACCENT, alpha: 1.0), for: .normal)
        self.view.addSubview(backChangeButton)
        
        //スライダー
        slider1 = UISlider(frame: CGRect(x: 0, y: 0, width: view.bounds.width * 8/10, height: 50))
        slider1.layer.position = CGPoint(x: UIScreen.main.bounds.size.width*1/2,
                                        y: animationView.frame.height + 100 + 25)
        slider1.thumbTintColor = UIColor.hex(COLOR.ACCENT, alpha: 1.0)
        slider1.tintColor = UIColor.hex(COLOR.ACCENT, alpha: 1.0)
        slider1.addTarget(self, action: #selector(sliderDidChangeValue1(_:)), for: .valueChanged)
        view.addSubview(slider1)
        
        //スライダー
        slider2 = UISlider(frame: CGRect(x: 0, y: 0, width: view.bounds.width * 8/10, height: 50))
        slider2.layer.position = CGPoint(x: UIScreen.main.bounds.size.width*1/2,
                                         y: animationView.frame.height + 100 + 75)
        slider2.thumbTintColor = UIColor.hex(COLOR.ACCENT, alpha: 1.0)
        slider2.tintColor = UIColor.hex(COLOR.ACCENT, alpha: 1.0)
        slider2.minimumValue = 0.1
        slider2.maximumValue = 5
        slider2.value = 1
        
        slider2.addTarget(self, action: #selector(sliderDidChangeValue2(_:)), for: .valueChanged)
        view.addSubview(slider2)
        
        func baseButton()->UIButton{
            let baseButton = UIButton.init()
            baseButton.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width*5/20,height: 35)
            baseButton.isUserInteractionEnabled = true
            baseButton.addTarget(self, action: #selector(onTapStartButton(sender:)),for: .touchUpInside)
            baseButton.layer.anchorPoint = CGPoint(x:0.5, y:0.5)
            baseButton.isExclusiveTouch = true
            baseButton.layer.masksToBounds = true
            baseButton.layer.cornerRadius = 5.0
            baseButton.showsTouchWhenHighlighted = true
            baseButton.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
            baseButton.setTitleColor(UIColor.hex(COLOR.BASE, alpha: 1.0), for: .normal)
            return baseButton
        }
        
        //Demoボタン
        let demoButton = baseButton()
        demoButton.layer.position = CGPoint(x: UIScreen.main.bounds.size.width*1/5, y: animationView.frame.height + 100 + 75 + 40)
        demoButton.addTarget(self,action: #selector(onTapDemoButton(sender:)),for: .touchUpInside)
        demoButton.setBackgroundImage(self.createImageFromUIColor(color: UIColor.hex(COLOR.ACCENT_DEMO, alpha: 1.0)), for: .normal)
        demoButton.setBackgroundImage(self.createImageFromUIColor(color: UIColor.hex(COLOR.ACCENT_DEMO, alpha: 1.0)), for: .highlighted)
        demoButton.setTitle(NSLocalizedString("Demo", comment: ""), for: .normal)
        self.view.addSubview(demoButton)
        
        //スタートボタン
        startButton = baseButton()
        startButton.layer.position = CGPoint(x: UIScreen.main.bounds.size.width*2/4, y: animationView.frame.height + 100 + 75 + 40)
        startButton.addTarget(self,action: #selector(onTapStartButton(sender:)),for: .touchUpInside)
        startButton.setBackgroundImage(self.createImageFromUIColor(color: UIColor.hex(COLOR.ACCENT, alpha: 1.0)), for: .normal)
        startButton.setBackgroundImage(self.createImageFromUIColor(color: UIColor.hex(COLOR.ACCENT, alpha: 1.0)), for: .highlighted)
        startButton.setTitle(NSLocalizedString("Pause", comment: ""), for: .normal)
        self.view.addSubview(startButton)
        
        //ARボタン
        let arButton = baseButton()
        arButton.layer.position = CGPoint(x: UIScreen.main.bounds.size.width*4/5, y: animationView.frame.height + 100 + 75 + 40)
        arButton.addTarget(self,action: #selector(onTapArButton(sender:)),for: .touchUpInside)
        arButton.setBackgroundImage(self.createImageFromUIColor(color: UIColor.hex(COLOR.ACCENT_AR, alpha: 1.0)), for: .normal)
        arButton.setBackgroundImage(self.createImageFromUIColor(color: UIColor.hex(COLOR.ACCENT_AR, alpha: 1.0)), for: .highlighted)
        arButton.setTitle(NSLocalizedString("ARView", comment: ""), for: .normal)
        //self.view.addSubview(arButton)
        
        //プロパティ表示
        propertyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width*0.95, height: 60))
        propertyLabel.layer.position = CGPoint(x: UIScreen.main.bounds.size.width*1/2,
                                               y: animationView.frame.height + 100 + 75 + 40 + 60)
        propertyLabel.backgroundColor = .blue
        propertyLabel.text = "x1.0"
        propertyLabel.font = UIFont(name: "Helvetica", size: 12)
        propertyLabel.textColor = UIColor.hex(COLOR.ACCENT, alpha: 1)
        propertyLabel.textAlignment = .left
        propertyLabel.numberOfLines = 0
        propertyLabel.backgroundColor = UIColor.hex(COLOR.ACCENT , alpha: 0.2)

        view.addSubview(propertyLabel)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func reloadView(){
        if UserDefaults.standard.object(forKey: "filename") != nil {
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let path = documentDirectoryURL.appendingPathComponent( UserDefaults.standard.object(forKey: "filename") as! String)
            
            if FileManager.default.fileExists(atPath: path.path) {
                title = UserDefaults.standard.string(forKey: "filename")//タイトル設定
                //アニメーション準備処理
                animationSet()
                
            }else{
                UserDefaults.standard.removeObject(forKey: "filename")//削除
                title = ""
            }
        }
    }
    
    /*-------------------------------------------------------------------------
     アクション
     -------------------------------------------------------------------------*/
    
    //ボタン
    @objc internal func onTapbackChangeButton(sender: UIButton){
        if backChangeButton.titleLabel?.text == "White" {
            self.view.backgroundColor = .white
            backChangeButton.setTitle("Black", for: .normal)
        }else{
            self.view.backgroundColor = .black
            backChangeButton.setTitle("White", for: .normal)
        }
    }
    
    @objc func timerUpdate() {
        slider1.setValue(Float(animationView.realtimeAnimationProgress), animated: true)
    }
    
    @objc func sliderDidChangeValue1(_ sender: UISlider) {
        startButton.setTitle("Play", for: .normal)
        animationView.play(fromProgress: CGFloat(sender.value), toProgress:CGFloat(sender.value) )
        print(sender.value)
    }
    
    @objc func sliderDidChangeValue2(_ sender: UISlider) {
        animationView.animationSpeed = CGFloat(sender.value)
        sender.setValue((round(sender.value*10))*1/10, animated: false)
        self.speedLabel.text = "x\(sender.value)"
        print(sender.value)
        
    }
    
    private func animationSet(){
        //json パス取得
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path = documentDirectoryURL.appendingPathComponent( UserDefaults.standard.object(forKey: "filename") as! String)
        print(path.path)
        
        //アニメ設定
        if let anime = Animation.filepath(path.path){
            animationView.animation = anime
            animationView.play()
        }
        
        //アニメーションプロパティ設定
        var text = ""
        
        if animationView.animation != nil {
            text += "Framerate: \( round((animationView.animation!.framerate ) * 100 )*0.01 )"
            text += "\n"
            text += "Duration: \(round((animationView.animation!.duration ) * 10 )*0.1) s"
            text += "\n"
            text += "MasterSize: \(animationView.animation!.size ) "
        }
        
        propertyLabel.text = text
    }
    
    //画面遷移アクション
    @objc internal func onTap(sender: UIButton){
        if sender.tag == 0 {
            let next = GetLottieViewContoroller()
            next.playViewController = self
            next.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            let nav: UINavigationController = UINavigationController(rootViewController: next)
            self.present(nav, animated: true, completion: nil)
        }else if sender.tag == 1{
            let next = FileListViewController()
            next.playViewController = self
            next.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            let nav: UINavigationController = UINavigationController(rootViewController: next)
            nav.modalPresentationStyle = .pageSheet
            self.present(nav, animated: true, completion: nil)
        }else if sender.tag == 2{
            let infoView = InfoView(frame: self.view.frame)
            navigationController?.view.addSubview(infoView)
        }
    }
    
    //demoボタンTap
    @objc internal func onTapDemoButton(sender: UIButton){
        UIView.animate(withDuration: 0.6,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {self.view.alpha = 0.0},
                       completion: { _ in
                        let del = UIApplication.shared.delegate as! AppDelegate
                        del.popDemo()})
    }
    
    //playボタンTap
    @objc internal func onTapStartButton(sender: UIButton){
        if startButton.titleLabel?.text == "Pause" {
            animationView.pause()
            startButton.setTitle("Play", for: .normal)
        }else{
            animationView.play()
            startButton.setTitle("Pause", for: .normal)
        }
    }
    
    //arボタンTap
    @objc internal func onTapArButton(sender: UIButton){
        print("onTapArButton")
        let next = ARViewController()
        next.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        let nav: UINavigationController = UINavigationController(rootViewController: next)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    /*-------------------------------------------------------------------------
     Other
     -------------------------------------------------------------------------*/
    
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

