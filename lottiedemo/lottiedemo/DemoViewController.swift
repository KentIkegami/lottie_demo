
import UIKit
import Lottie
import Malert

class DemoViewController: UIViewController,UIScrollViewDelegate {
    
    var scrollView:UIScrollView!
    var scrollAnimeView:AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "DemoView"
        
        //キャンセルボタン追加
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(self.onTapCancel(sender:)))
        cancelButton.tintColor = UIColor.hex(COLOR.ACCENT, alpha: 1)
        self.navigationItem.setRightBarButton(cancelButton, animated: true)
        //スクロールビュー
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.hex(COLOR.BASE, alpha: 1.0)
        self.view.addSubview(scrollView)
        
        //コンテンツの高さ
        var endpoint:CGFloat = 40
        
        //アニメーションボタン
        let buttonLabel = subtiltleLabel(text: "・Animation Button", height: 27, y: endpoint)
        endpoint += buttonLabel.frame.height
        endpoint += 50
        let animationButton = CustomAnimationButton(x: self.view.frame.width*1/2, y: endpoint)
        endpoint += animationButton.frame.height
        endpoint += 50
        
        //アラート
        let alertLabel = subtiltleLabel(text: "・Animation Alert", height: 27, y: endpoint)
        endpoint += alertLabel.frame.height
        endpoint += 50
        let alertButtton = CustomAlertButton(x: self.view.frame.width*1/2, y: endpoint)
        let tapGestureAlert:UITapGestureRecognizer = UITapGestureRecognizer(target: self,action:#selector(self.alertLabelTapped(_:)))
        alertButtton.addGestureRecognizer(tapGestureAlert)
        endpoint += alertButtton.frame.height
        endpoint += 50
        
        //インジケーター
        let indicatorLabel = subtiltleLabel(text: "・Animation Indicator", height: 27, y: endpoint)
        endpoint += alertLabel.frame.height
        endpoint += 50
        let indicatorButtton = CustomAlertButton(x: self.view.frame.width*1/2, y: endpoint)
        indicatorButtton.text = "Indicator"
        indicatorButtton.font = UIFont(name: "Helvetica", size: 20)
        let tapGestureIndicator:UITapGestureRecognizer = UITapGestureRecognizer(target: self,action:#selector(self.indicatorLabelTapped(_:)))
        indicatorButtton.addGestureRecognizer(tapGestureIndicator)
        endpoint += indicatorButtton.frame.height
        endpoint += 50
        
        //スクロール
        let scrollLabel = subtiltleLabel(text: "・Animation Scroll", height: 27, y: endpoint)
        endpoint += scrollLabel.frame.height
        endpoint += 50
        self.scrollAnimeView = createAnimation()
        self.scrollAnimeView.frame = CGRect(x: self.view.frame.width*1/3 , y: endpoint, width: scrollAnimeView.frame.width, height: scrollAnimeView.frame.height)
        endpoint += scrollAnimeView.frame.height
        endpoint += 50
        
        //autoPlay
        let autoLoopLabel = subtiltleLabel(text: "・Animation AutoLoop", height: 27, y: endpoint)
        endpoint += autoLoopLabel.frame.height
        endpoint += 50
        let autoLoopAnimeView = createAnimation()
        autoLoopAnimeView.loopMode = .loop
        autoLoopAnimeView.frame = CGRect(x: self.view.frame.width*1/3 , y: endpoint, width: scrollAnimeView.frame.width, height: scrollAnimeView.frame.height)
        endpoint += autoLoopAnimeView.frame.height
        endpoint += 50
        
        //auto-reverse
        let autoReverseLabel = subtiltleLabel(text: "・Animation AutoReverse", height: 27, y: endpoint)
        endpoint += autoReverseLabel.frame.height
        endpoint += 50
        let autoReverseAnimeView = createAnimation()
        autoReverseAnimeView.loopMode = .autoReverse
        autoReverseAnimeView.frame = CGRect(x: self.view.frame.width*1/3 , y: endpoint, width: scrollAnimeView.frame.width, height: scrollAnimeView.frame.height)
        endpoint += autoReverseAnimeView.frame.height
        endpoint += 50
        
        scrollView.addSubview(buttonLabel)
        scrollView.addSubview(animationButton)
        scrollView.addSubview(alertLabel)
        scrollView.addSubview(alertButtton)
        scrollView.addSubview(indicatorLabel)
        scrollView.addSubview(indicatorButtton)
        scrollView.addSubview(scrollLabel)
        scrollView.addSubview(scrollAnimeView)
        scrollView.addSubview(autoLoopLabel)
        scrollView.addSubview(autoLoopAnimeView)
        scrollView.addSubview(autoReverseLabel)
        scrollView.addSubview(autoReverseAnimeView)
        
        //スクロールビューのサイズ決定
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: endpoint)
    }
    
    @objc func alertLabelTapped(_ sender: UITapGestureRecognizer) {
        let malert = Malert(customView: createAnimation())
        let action = MalertAction(title: "OK")
        action.tintColor = UIColor(red:0.15, green:0.64, blue:0.85, alpha:1.0)
        malert.addAction(action)
        present(malert, animated: true)
    }
    
    var wall:AnimationView!
    @objc func indicatorLabelTapped(_ sender: UITapGestureRecognizer) {
        wall = createAnimation()
        wall.frame = view.frame
        wall.backgroundColor = UIColor.hex("000000", alpha: 0.4)
        let tapGestureIndicator:UITapGestureRecognizer = UITapGestureRecognizer(target: self,action:#selector(self.wallTapped(_:)))
        wall.addGestureRecognizer(tapGestureIndicator)
        wall.loopMode = .loop
        wall.play()
        navigationController?.view.addSubview(wall)
    }
    @objc func wallTapped(_ sender: UITapGestureRecognizer) {
        wall.removeFromSuperview()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollProgress = (scrollView.contentOffset.y)/(scrollView.contentSize.height-scrollView.frame.height)
        scrollAnimeView.play(fromProgress: CGFloat(scrollProgress), toProgress:CGFloat(scrollProgress) )
    }
    
    func subtiltleLabel(text:String,height:CGFloat,y:CGFloat)->UILabel{
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: self.view.frame.width*8/10, height: height)
        label.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        label.layer.position = CGPoint(x: self.view.frame.width*1/2, y: y)
        label.font = UIFont(name: "Helvetica", size: 25)
        label.text = text
        label.textAlignment = .left
        label.tintColor = .gray
        return label
    }
    
    func createAnimation()->AnimationView{
        //animation初期化
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path = documentDirectoryURL.appendingPathComponent( UserDefaults.standard.object(forKey: "filename") as! String)
        
        let animationView = AnimationView()
        animationView.animation = Animation.filepath(path.path)
        
        let rate = animationView.animation!.size.height/animationView.animation!.size.width
        let w = 150 as CGFloat
        let h = w * rate
        animationView.frame = CGRect(x: 0, y: 0, width: w, height:h)
        animationView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        //animationView.layer.position = CGPoint(x: UIScreen.main.bounds.size.width*1/2,y: view.bounds.width*1/2)
        animationView.loopMode = .playOnce
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        animationView.backgroundColor = .clear
        animationView.play()
        return animationView
    }

    //戻る
    @objc internal func onTapCancel(sender: UIButton){
        UIView.animate(withDuration: 0.6,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {self.view.alpha = 0.0},
                       completion: { _ in
                        let del = UIApplication.shared.delegate as! AppDelegate
                        del.popMain()})
    }
}
