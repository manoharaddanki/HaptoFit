//
//  Extensions.swift
//  Quiz
//
//  Created by rizenew on 2/1/18.
//  Copyright © 2018 Rize. All rights reserved.
//

import UIKit



extension UIDevice {
    
    var iPhoneX: Bool {
        
        if #available(iOS 11.0, tvOS 11.0, *) {
            
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
            
        } else {
            
            return UIScreen.main.nativeBounds.height == 2436
        }
    }
}

extension UIButton{
    func setCornerRadius(cornerRadius:Int) {
        layer.cornerRadius = CGFloat(cornerRadius/2)
    }
}
extension CALayer {
    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
    
    var shadowUIColor: UIColor {
        set {
            self.shadowColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: self.shadowColor!)
        }
    }
    
}

extension UIView {
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float, cornerRadius : CGFloat)
    {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.cornerRadius = cornerRadius
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}


extension UIViewController {
    // Tost Message Label Programatically Creation With Animations
    func showToast(message : String) {
        //let toastLabel = UILabel(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: 300, height: 40))
        //let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-400, width: 300, height: 40))
        
        let toastLabel = UILabel(frame:
            CGRect(x: self.view.frame.size.width/2 - 150,
                   y: self.view.frame.size.height/2,width: 300,height: 40))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.numberOfLines = 2
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.frame.origin.y = 0
        view.endEditing(true)
        
    }
    
    func displayContentController(_ content:UIViewController,compareString : String)
    {
        //        self.setStatusBar(color: APP_RED_COLOR)
        //        content.view.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: 50)
        //        self.view.addSubview(content.view)
        //
        //        self.view.bringSubviewToFront(content.view)
        //        content.view.isUserInteractionEnabled = true
        //        content.didMove(toParent: self)
    }
    
    // Hide Controller
    func hideContentController(_ content:UIViewController) {
        
        //        content.willMove(toParent: nil)
        //        content.view.removeFromSuperview()
        //        content.view.sendSubviewToBack(self.view)
        //        content.removeFromParent()
    }
    
    func setStatusBar(color: UIColor) {
        let tag = 12321
        if let taggedView = self.view.viewWithTag(tag){
            taggedView.removeFromSuperview()
        }
        let overView = UIView()
        overView.frame = UIApplication.shared.statusBarFrame
        overView.backgroundColor = color
        overView.tag = tag
        self.view.addSubview(overView)
    }
    
    /// pop back to specific viewcontroller
    func popBack<T: UIViewController>(toControllerType: T.Type) {
        if var viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            viewControllers = viewControllers.reversed()
            for currentViewController in viewControllers {
                if currentViewController .isKind(of: toControllerType) {
                    self.navigationController?.popToViewController(currentViewController, animated: true)
                    break
                }
            }
        }
    }
    
    // pop To Tab Root Controller
    
    func popToTabRootController(content : UIViewController, selectedIndex : Int) {
        
        // Do something with index
        
        let rootView = self.tabBarController?.viewControllers![selectedIndex]
        
        if rootView?.isKind(of: UINavigationController.self) ?? false {
            
            let rootView_controller = rootView as! UINavigationController
            
            if selectedIndex == 3 {
                
                rootView_controller.popToRootViewController(animated: false)
                
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "PopToRootViewController"), object: nil)
                
            } else {
                
                rootView_controller.popToRootViewController(animated: false)
            }
            
        }else if rootView?.isKind(of: UIViewController.self) ?? false{
            
            //            let rootView_controller = rootView
            //            rootView_controller.parentViewController(animated: false)
            // self.navigationController?.pushViewController(rootView, animated: true)
        }
    }
    
    
    // MARK:- get Days Hours Mins Secs Between Two Dates
    
    func getDaysHoursMinsSecsBetweenTwoDates(post_server_time : String, current_start_time : String, calComponentType : Calendar.Component) -> Int {
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //"yyyy-MM-dd'T'HH:mm:ss:SSS"
        let server_Date = dateFormatter.date(from: post_server_time) ?? Date()
        let current_Start_Date = dateFormatter.date(from: current_start_time) ?? Date()
        let difference = Calendar.current.dateComponents([calComponentType], from:current_Start_Date, to: server_Date)
        
        if calComponentType == .day {
            
            return difference.day ?? 0
        }
        else if calComponentType == .hour {
            
            return difference.hour ?? 0
        }
        else if calComponentType == .minute {
            
            return difference.minute ?? 0
        }
        else if calComponentType == .second {
            
            return difference.second ?? 0
        }
        
        return 0
    }
    
    
    func getChannelWithGymID() -> String {
        
        let gymID = String(Defaults.trainer_GYM_ID!)
        let channel = WEBSOCKET_CHANNEL + String(gymID)
        return channel
    }
    
    func getWebsocketEndPoint() -> String {
        
        let gymID = String(Defaults.trainer_GYM_ID!)
        let channel = WEBSOCKET_END_POINT + gymID
        return channel
    }
    
    
    func getCurrentDateAndTime() -> String {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"//.SSS" //"yyyy-MM-dd'T'HH:mm:ss.SSS"
        let currentdate = formatter.string(from: date)
        return currentdate
    }
    
}


// MARK: - Extension Clasess
extension UITextField
{
    
    /**
     Set The Text Field Left Padding
     
     - parameter image Name
     
     - OutPut: cornerRadius,borderWidth,BorderColor && TextField Left Padding With Image
     */
    func setPreferences(imageName:String) {
        self.layer.cornerRadius = 20.0
        //self.layer.borderColor = UIColor(red: 222/255.0, green: 208/255.0, blue: 223/255.0, alpha: 1).cgColor
        self.layer.borderWidth = 2.0
        
        let paddingView = UIView(frame: CGRect(x:5, y: 0, width: 30, height: self.frame.height))
        let imageView = UIImageView(frame: CGRect(x:5, y:5, width:30, height:30))
        paddingView.addSubview(imageView)
        let image = UIImage(named:imageName)
        imageView.image = image
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
        
    }
    
    func setPreferences1(imageName:String) {
        self.layer.cornerRadius = 20.0
        //self.layer.borderColor = UIColor(red: 222/255.0, green: 208/255.0, blue: 223/255.0, alpha: 1).cgColor
        self.layer.borderWidth = 2.0
        
        let paddingView = UIView(frame: CGRect(x:5, y: 0, width:20, height: self.frame.height))
        let imageView = UIImageView(frame: CGRect(x:5, y:5, width:20, height:30))
        paddingView.addSubview(imageView)
        let image = UIImage(named:imageName)
        imageView.image = image
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
        
    }
    
    /**
     TextField Set The Curser Posison After Filling Text Field The clicking The Return Key Curser Posison Show The Next TextField Automatically
     
     - parameter TextField
     */
    class func connectFields(fields:[UITextField]) -> Void {
        guard let last = fields.last else {
            return
        }
        for i in 0 ..< fields.count - 1 {
            fields[i].returnKeyType = .next
            fields[i].addTarget(fields[i+1], action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
        }
        last.returnKeyType = .done
        last.addTarget(last, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)
    }
    
    class func secondStepconnectFields(fields:[UITextField]) -> Void {
        guard let last = fields.last else {
            return
        }
        for i in 0 ..< fields.count - 1 {
            fields[i].returnKeyType = .next
            fields[i].addTarget(fields[i+1], action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
        }
        last.returnKeyType = .done
        last.addTarget(last, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)
    }
}

extension UITableViewCell{
    
    func customCell(display_name: String) -> UITableViewCell {
        
        self.textLabel?.text = display_name
        self.textLabel?.textAlignment = .center
        self.textLabel?.textColor = UIColor.black
        self.textLabel?.numberOfLines = 2
        self.backgroundColor = UIColor.clear
        //CustomColor.cellColor
        self.selectionStyle = .none
        
        return self
    }
    
    func getDateDifferenceTime(postTime: String , curentTime: String, txtLabel: UILabel, isFrom:String)  {
        
        
        var timeDifference:Int?
        var timeStr: String!
        
        let days = self.getDaysHoursMinsSecsBetweenTwoDates(post_server_time: postTime, current_start_time: curentTime, postType: isFrom, calComponentType: .day)
        
        if days == 0{
            
            let hours = self.getDaysHoursMinsSecsBetweenTwoDates(post_server_time: postTime, current_start_time: curentTime, postType: isFrom, calComponentType: .hour)
            
            if hours == 0 {
                
                let mins = self.getDaysHoursMinsSecsBetweenTwoDates(post_server_time: postTime, current_start_time: curentTime, postType: isFrom, calComponentType: .minute)
                
                if mins == 0 {
                    
                    let secs = self.getDaysHoursMinsSecsBetweenTwoDates(post_server_time: postTime, current_start_time: curentTime, postType: isFrom, calComponentType: .second)
                    
                    if secs == 0 {
                        
                        timeDifference = secs
                        timeStr = "sec"
                        //txtLabel.text = "\(secs)"
                        
                    }else{
                        
                        if secs == 1 {
                            
                            timeDifference = secs
                            timeStr = "sec"
                        }else{
                            
                            timeDifference = secs
                            timeStr = "sec"
                        }
                        //txtLabel.text = "\(secs) secs ago"
                        
                    }
                } else {
                    
                    if mins == 1 {
                        
                        timeDifference = mins
                        timeStr = "min ago"
                    }else{
                        
                        timeDifference = mins
                        timeStr = "mins ago"
                    }
                    
                    //txtLabel.text = "\(mins) mins ago"
                }
                
            } else {
                
                if hours == 1 {
                    
                    timeDifference = hours
                    timeStr = "hr ago"
                }else{
                    
                    timeDifference = hours
                    timeStr = "hrs ago"
                }
            }
            
        }else{
            
            if days == 1 {
                
                timeDifference = days
                timeStr = "day ago"
                
                //txtLabel.text = "\(days) day ago"
                
            }else{
                
                timeDifference = days
                timeStr = "days ago"
                
                //txtLabel.text = "\(days) days ago"
            }
        }
        timeDifference = abs(timeDifference!)
        
        if timeStr! == "sec" {
            
            txtLabel.text = "Just now"

        }else{
            
            txtLabel.text = String(timeDifference!) + " \(timeStr!)"
        }
    }
    
    
    // MARK:- get Days Hours Mins Secs Between Two Dates
    
    func getDaysHoursMinsSecsBetweenTwoDates(post_server_time : String, current_start_time : String, postType: String, calComponentType : Calendar.Component) -> Int {
        
        let dateFormatter = DateFormatter.init()
        
        if postType == "normalPost" {
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"//.SSS"

        }else{
         
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"//.SSS"
        }
        
        let server_Date = dateFormatter.date(from: post_server_time) ?? Date()
        let current_Start_Date = dateFormatter.date(from: current_start_time) ?? Date()
        
        let difference = Calendar.current.dateComponents([calComponentType], from: server_Date, to:current_Start_Date)
        
        if calComponentType == .day {
            
            return difference.day ?? 0
            
        }
        else if calComponentType == .hour {
            
            return difference.hour ?? 0
            
        }
        else if calComponentType == .minute {
            
            return difference.minute ?? 0
            
        }
        else if calComponentType == .second {
            
            return difference.second ?? 0
            
        }
        
        return 0
    }
}
extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func layerGradient() {
        let layer : CAGradientLayer = CAGradientLayer()
        layer.frame.size = self.frame.size
        layer.frame.origin = CGPoint(x: 0.0,y: 0.0)
        layer.cornerRadius = CGFloat(frame.width / 20)

        let color0 = UIColor(red:250.0/255, green:250.0/255, blue:250.0/255, alpha:0.5).cgColor
        let color1 = UIColor(red:200.0/255, green:200.0/255, blue: 200.0/255, alpha:0.1).cgColor
        let color2 = UIColor(red:150.0/255, green:150.0/255, blue: 150.0/255, alpha:0.1).cgColor
        let color3 = UIColor(red:100.0/255, green:100.0/255, blue: 100.0/255, alpha:0.1).cgColor
        let color4 = UIColor(red:50.0/255, green:50.0/255, blue:50.0/255, alpha:0.1).cgColor
        let color5 = UIColor(red:0.0/255, green:0.0/255, blue:0.0/255, alpha:0.1).cgColor
        let color6 = UIColor(red:150.0/255, green:150.0/255, blue:150.0/255, alpha:0.1).cgColor

        layer.colors = [color0,color1,color2,color3,color4,color5,color6]
        self.layer.insertSublayer(layer, at: 0)
    }
    
}
class PassThroughView: UIView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews as [UIView] {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
}

/*extension UIViewController {
 func hideNavigationBar(){
 // Hide the navigation bar on the this view controller
 self.navigationController?.setNavigationBarHidden(true, animated: true)
 
 }
 
 func showNavigationBar() {
 // Show the navigation bar on other view controllers
 self.navigationController?.setNavigationBarHidden(false, animated: true)
 }
 
 func hideKeyboardWhenTappedAround() {
 let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
 tap.cancelsTouchesInView = false
 view.addGestureRecognizer(tap)
 }
 
 @objc func dismissKeyboard() {
 view.endEditing(true)
 }
 
 @objc func applyBorder(view: UIView){
 view.layer.cornerRadius = 5
 view.layer.borderWidth = 2
 view.layer.borderColor = UIColor.lightGray.cgColor
 view.layer.shadowColor = UIColor.gray.cgColor
 view.layer.shadowOffset = CGSize(width:1.0, height:1.0)
 //view.layer.shadowOpacity = 1.0;
 //view.layer.shadowRadius = 1.0;
 
 }
 }
 */
/*extension UITextField
 {
 func setPreferences(imageName:String) {
 self.layer.cornerRadius = 15.0
 self.layer.borderColor = UIColor.white.cgColor
 self.layer.borderWidth = 1.0
 
 let paddingView = UIView(frame: CGRect(x: 5, y: 0, width: 30, height: self.frame.height))
 let imageView = UIImageView(frame: CGRect(x: 10, y: 2, width: 20, height: 25))
 paddingView.addSubview(imageView)
 let image = UIImage(named:imageName)
 imageView.image = image
 self.leftView = paddingView
 self.leftViewMode = UITextFieldViewMode.always
 
 }
 }*/

//extension UIView {
//    
//    private static var _addShadow:Bool = false
//    
//    @IBInspectable var addShadow:Bool {
//        get {
//            return UIView._addShadow
//        }
//        set(newValue) { 
//            if(newValue == true){
//                layer.masksToBounds = false
//                layer.shadowColor = UIColor.red.cgColor
//                layer.shadowOpacity = 0.075
//                layer.shadowOffset = CGSize(width: 0, height: -3)
//                layer.shadowRadius = 1
//                
//                layer.shadowPath = UIBezierPath(rect: bounds).cgPath
//                layer.shouldRasterize = true
//                layer.rasterizationScale =  UIScreen.main.scale
//            }
//        }
//    }
//    
//}

extension UIView {
    
    func takeScreenshot() -> UIImage {
        
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}

extension UILabel {
    
    func setGradientBorderColor(colorsArray : [UIColor]) {
        
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.colors = colorsArray
        
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = UIBezierPath(rect: self.bounds).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        self.layer.addSublayer(gradient)
    }
        func UILableTextShadow(color: UIColor){
          self.textColor = color
          self.layer.masksToBounds = false
          self.layer.shadowOffset = CGSize(width: 1, height: 1)
          self.layer.rasterizationScale = UIScreen.main.scale
          self.layer.shadowRadius = 2.0
          self.layer.shadowOpacity = 0.5
       }
}

extension UIColor {
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

extension UINavigationController {
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
            popToViewController(vc, animated: animated)
        }
    }
    
    func popViewControllers(viewsToPop: Int, animated: Bool = true) {
        if viewControllers.count > viewsToPop {
            let vc = viewControllers[viewControllers.count - viewsToPop - 1]
            popToViewController(vc, animated: animated)
        }
    }
    
}
extension Date {
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
}


extension String {
    
    func UTCToLocal(incomingFormat: String, outGoingFormat: String) -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = incomingFormat
      dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

      let dt = dateFormatter.date(from: self)
      dateFormatter.timeZone = TimeZone.current
      dateFormatter.dateFormat = outGoingFormat

      return dateFormatter.string(from: dt ?? Date())
    }
}

extension NSAttributedString {

    /// Returns a new instance of NSAttributedString with same contents and attributes with strike through added.
     /// - Parameter style: value for style you wish to assign to the text.
     /// - Returns: a new instance of NSAttributedString with given strike through.
     func withStrikeThrough(_ style: Int = 1) -> NSAttributedString {
         let attributedString = NSMutableAttributedString(attributedString: self)
         attributedString.addAttribute(.strikethroughStyle,
                                       value: style,
                                       range: NSRange(location: 0, length: string.count))
         return NSAttributedString(attributedString: attributedString)
     }
}
