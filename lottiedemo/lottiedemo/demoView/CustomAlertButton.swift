//
//  AnimationButton.swift
//  lottiedemo
//
//  Created by inf on 2019/07/17.
//  Copyright © 2019 kent ikegami. All rights reserved.
//

import UIKit
import Lottie

class CustomAlertButton: UILabel {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(x: CGFloat,y:CGFloat) {
        super.init(frame: CGRect(x: 0,y: 0,width: 100,height: 50))
        self.layer.position = CGPoint(x: x, y: y)
        self.backgroundColor = UIColor.hex(COLOR.ACCENT_AR, alpha: 0.7)
        self.isUserInteractionEnabled = true
        self.layer.anchorPoint = CGPoint(x:0.5, y:0.0)
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 12.0
        self.tag = 0
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 4.0
        self.text = "Alert"
        self.textAlignment = .center
        self.font = UIFont(name: "Helvetica", size: 30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



