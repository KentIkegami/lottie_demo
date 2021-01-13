
import UIKit

class InfoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        //ブラーエフェクト
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        
        
        //icon
        let iconLabel = UIImageView(frame:CGRect(x: 0,
                                              y: 0,
                                              width: 80,
                                              height: 80))
        iconLabel.layer.position = CGPoint(x: self.bounds.size.width*1/2,
                                            y:  self.bounds.size.height*2/11)
        iconLabel.image = UIApplication.shared.icon
        iconLabel.layer.masksToBounds = true
        iconLabel.layer.cornerRadius = 12.0
        self.addSubview(iconLabel)
        
        //tilte
        let titleLabel = UILabel(frame:CGRect(x: 0,
                                          y: 0,
                                          width: self.bounds.size.width,
                                          height: 80))
        titleLabel.layer.position = CGPoint(x: self.bounds.size.width*1/2,
                                            y:  self.bounds.size.height*3/11)
        titleLabel.text = getDisplayName()
        titleLabel.font = UIFont.systemFont(ofSize: 50)
        titleLabel.textColor = UIColor.hex(COLOR.FONT, alpha: 1.0)
        titleLabel.textAlignment = NSTextAlignment.center
        self.addSubview(titleLabel)
        
        //subTitleLabel
        let subTitleLabel = UILabel(frame:CGRect(x: 0,
                                             y: 0,
                                             width: self.bounds.size.width,
                                             height: 30))
        subTitleLabel.layer.position = CGPoint(x: self.bounds.size.width*1/2,
                                            y:  self.bounds.size.height*3.8/11)
        subTitleLabel.text = "Version: \(getVer())"
        subTitleLabel.font = UIFont.systemFont(ofSize: 20)
        subTitleLabel.textColor = UIColor.hex(COLOR.FONT, alpha: 1.0)
        subTitleLabel.textAlignment = NSTextAlignment.center
        self.addSubview(subTitleLabel)
        
        
        //tilte
        let titleLabel1 = UILabel(frame:CGRect(x: 0,
                                              y: 0,
                                              width: self.bounds.size.width,
                                              height: 80))
        titleLabel1.layer.position = CGPoint(x: self.bounds.size.width*1/2,
                                            y:  self.bounds.size.height*5/11)
        titleLabel1.text = "lottie-ios"
        titleLabel1.font = UIFont.systemFont(ofSize: 35)
        titleLabel1.textColor = UIColor.hex(COLOR.FONT, alpha: 1.0)
        titleLabel1.textAlignment = NSTextAlignment.center
        self.addSubview(titleLabel1)
        
        //subTitleLabel
        let subTitleLabel1 = UILabel(frame:CGRect(x: 0,
                                                 y: 0,
                                                 width: self.bounds.size.width,
                                                 height: 30))
        subTitleLabel1.layer.position = CGPoint(x: self.bounds.size.width*1/2,
                                               y:  self.bounds.size.height*5.6/11)
        subTitleLabel1.text = "Version: 3.1.9"
        subTitleLabel1.font = UIFont.systemFont(ofSize: 15)
        subTitleLabel1.textColor = UIColor.hex(COLOR.FONT, alpha: 1.0)
        subTitleLabel1.textAlignment = NSTextAlignment.center
        self.addSubview(subTitleLabel1)
        
        //subTitleLabel
        let sub =
        """
        I hope useful for your job
        and I hope you will go well !
        (●'д')b

        """
        let textLabel = UILabel(frame:CGRect(x: 0,
                                                  y: 0,
                                                  width: self.bounds.size.width,
                                                  height: 200))
        textLabel.layer.position = CGPoint(x: self.bounds.size.width*1/2,
                                                y:  self.bounds.size.height*8/11)
        textLabel.text = sub
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFont(ofSize: 20)
        textLabel.textColor = UIColor.hex(COLOR.FONT, alpha: 1.0)
        textLabel.textAlignment = NSTextAlignment.center
        self.addSubview(textLabel)
        
        
        
        //dissmiss
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector((onTapCancel(sender:))))
        gesture.numberOfTapsRequired = 1
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
        
//        //Xボタン
//        let linkButton = UIButton.init(frame: CGRect(x: 0,
//                                                 y: 0,
//                                                 width: 60,
//                                                 height: 60))
//        linkButton.layer.anchorPoint = CGPoint(x:0.5, y:0.5)
//        linkButton.layer.position = CGPoint(x: self.bounds.size.width - 30,
//                                            y: 50)
//
//        linkButton.isUserInteractionEnabled = true
//        linkButton.addTarget(self,
//                             action: #selector(onTapCancel(sender:)),
//                             for: .touchUpInside)
//        //タイトル関係
//        linkButton.setTitle(NSLocalizedString("×", comment: ""), for: .normal)
//        linkButton.titleLabel?.font = UIFont(name: "Helvetica", size: 60)
//        linkButton.setTitleColor(UIColor.hex(COLOR.ACCENT, alpha: 1.0), for: .normal)
//        linkButton.setTitle(NSLocalizedString("×", comment: ""), for: .highlighted)
//        linkButton.setTitleColor(UIColor.hex(COLOR.ACCENT, alpha: 0.8), for: .highlighted)
//
//        self.addSubview(linkButton)
        
    }
    
    //戻る
    @objc internal func onTapCancel(sender: UIButton){
        UIView.animate(withDuration: 0.50,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {self.alpha = 0.0},
                       completion: { _ in
                        self.removeFromSuperview()})
        
    }
    
    func getDisplayName()->String{
        let DisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") ?? "Lottie Master"
        return DisplayName as! String
    }
    
    //バージョン取得
    func getVer() -> String{
        var version = ""
        version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        return version
    }
}
