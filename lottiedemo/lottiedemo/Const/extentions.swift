import Foundation
import UIKit

extension UIColor{
    class func rgb(r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    class func hex ( _ hexStr : String, alpha : CGFloat) -> UIColor{
        var hexStr = hexStr.replacingOccurrences(of: "#", with: "")
        
        if hexStr.count == 3{
            var newHexStr = ""
            for c in hexStr{
                newHexStr += "\(c)\(c)"
            }
            hexStr = newHexStr
        }
        
        let scanner = Scanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color){
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        }else{
            print("invalid hex string")
            return UIColor.white
        }
    }
}

extension UIApplication {
    var icon: UIImage? {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? NSDictionary,
            let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? NSDictionary,
            let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? NSArray,
            // First will be smallest for the device class, last will be the largest for device class
            let lastIcon = iconFiles.lastObject as? String,
            let icon = UIImage(named: lastIcon) else {
                return nil
        }
        return icon
    }
}



extension UIColor {
    static var randomColor: UIColor {
        let r = CGFloat.random(in: 0 ... 255) / 255.0
        let g = CGFloat.random(in: 0 ... 255) / 255.0
        let b = CGFloat.random(in: 0 ... 255) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}

extension UILabel {
    func setBackgroundColor(_ color: UIColor, duration: TimeInterval = 0, option: UIView.AnimationOptions = [], completion:(()->())? = nil) {
        var setting: UIView.AnimationOptions = option
        setting.insert(UIView.AnimationOptions.transitionCrossDissolve)
        UIView.transition(with: self, duration: duration, options: setting, animations: {
            self.backgroundColor = color
        }) { (finish) in
            if finish { completion?() }
        }
    }
    
    func setTextColor(_ color: UIColor, duration: TimeInterval = 0, option: UIView.AnimationOptions = [], completion:(()->())? = nil) {
        var setting: UIView.AnimationOptions = option
        setting.insert(UIView.AnimationOptions.transitionCrossDissolve)
        UIView.transition(with: self, duration: duration, options: setting, animations: {
            self.textColor = color
        }) { (finish) in
            if finish { completion?() }
        }
    }
}
