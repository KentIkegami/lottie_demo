//
//  AnimationButton.swift
//  lottiedemo
//
//  Created by inf on 2019/07/17.
//  Copyright © 2019 kent ikegami. All rights reserved.
//

import UIKit
import Lottie

class CustomAnimationButton: UIView {
    
    var animationButtonAnime:AnimationView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    init(x: CGFloat,y:CGFloat) {
        
        //animation初期化
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path = documentDirectoryURL.appendingPathComponent( UserDefaults.standard.object(forKey: "filename") as! String)
        let animation = Animation.filepath(path.path)!
        let h:CGFloat = 80
        let w = h * animation.size.width/animation.size.height
        
        super.init(frame: CGRect(x: 0,y: 0,width: w,height: h))
        self.layer.position = CGPoint(x: x, y: y)
        self.backgroundColor = UIColor.hex("595858", alpha: 0.7)
        self.isUserInteractionEnabled = true
        self.layer.anchorPoint = CGPoint(x:0.5, y:0.0)
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 12.0
        self.tag = 0
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 4.0
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(self.tapped(_:)))
        self.addGestureRecognizer(tapGesture)
        
        animationButtonAnime = createAnimation(anime: animation, w: w, h: h)
        animationButtonAnime.layer.position = CGPoint(x: self.frame.width*1/2, y: self.frame.height*1/2)
        self.addSubview(animationButtonAnime)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        
        if animationButtonAnime.isAnimationPlaying{return}
        
        if self.tag==0{//off->on
            self.tag=1
            animationButtonAnime.play()
            UIView.animate(withDuration: animationButtonAnime.animation!.duration, delay: 0, animations: {
                self.backgroundColor = UIColor.hex(COLOR.ACCENT, alpha: 1.0)
            })
        
        }else{
            self.tag=0
            animationButtonAnime.play(fromProgress: 1, toProgress: 0, completion: nil)
            UIView.animate(withDuration: animationButtonAnime.animation!.duration, delay: 0, animations: {
                self.backgroundColor = UIColor.hex("595858", alpha: 0.7)
            })
        }
    }
    
    func createAnimation(anime:Animation,w:CGFloat,h:CGFloat)->AnimationView{
        let animationView = AnimationView(animation: anime)
        animationView.frame = CGRect(x: 0, y: 0, width: w, height: h)
        animationView.loopMode = .playOnce
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        return animationView
    }
    
}
