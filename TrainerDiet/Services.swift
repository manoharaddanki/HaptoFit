//
//  Services.swift
//  Perfume
//
//  Created by murali krishna on 11/1/17.
//  Copyright © 2017 volivesolutions. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import KRProgressHUD

class Services : NSObject {
    
    
    
    static let sharedInstance = Services()
    
    
  
    //signUp getperamters
    var _name: String!
    var _email: String!
    var _mobileNumber: String!
    var _message: String!

    var errMessage: String!
    let imageV = UIImageView()
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
    var messageLoader: UILabel!
    
    
    
    func loader(view: UIView) -> () {
        
        /*
//        let imageV = UIImageView()
        imageV.frame = CGRect(x: 0,y: 0,width: 100,height: 100)
        imageV.center = view.center
        imageV.image = #imageLiteral(resourceName: "SUV Select")
        indicator.bringSubview(toFront: imageV)
        view.addSubview(imageV)
        */
        
        indicator.frame = CGRect(x: 0,y: 0,width: 75,height: 75)
        indicator.layer.cornerRadius = 8
        indicator.center = view.center
        indicator.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.addSubview(indicator)
        indicator.backgroundColor = UIColor(red: 55/255, green: 60/255, blue: 60/255, alpha: 0.60)
        indicator.bringSubviewToFront(view)
        
        
        messageLoader.frame = CGRect(x: 0,y: 0,width: 80,height: 50)
        messageLoader.center = view.center
        messageLoader.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        messageLoader.text = "Please wait"
        messageLoader.bringSubviewToFront(indicator)
        view.addSubview(messageLoader)
        
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        indicator.startAnimating()

        UIApplication.shared.beginIgnoringInteractionEvents()
    }
   
    func dissMissLoader()  {
        Services.sharedInstance.dismiss()
         indicator.stopAnimating()
        imageV.removeFromSuperview()
        UIApplication.shared.endIgnoringInteractionEvents()
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    func customLoader(view: UIView , message: String)
    {
        KRProgressHUD.show(withMessage: message)
        
        KRProgressHUD.set(style: KRProgressHUDStyle.custom(background: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), text: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), icon: #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)))
        KRProgressHUD.set(maskType: KRProgressHUDMaskType.black)
        KRProgressHUD.set(activityIndicatorViewStyle: .color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
//        KRProgressHUD.set(font:UIFont(name: "Ubuntu", size: 16)! )
       // KRProgressHUDStyle.custom(background: #colorLiteral(red: 0.9607843137, green: 0.7882352941, blue: 0.007843137255, alpha: 1), text: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), icon: #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1))
       // KRProgressHUD.appearance()
    }
    
    func dismiss()
    {
        KRProgressHUD.dismiss()
    }
    
    func showMessage(message: String)
    {
        KRProgressHUD.showMessage(message)
    }
    

    
    var name: String {
        
        if _name == nil {
          _name = "Not available"
        }
        return _name
        
    }
    
    var email: String {
        
        if _email == nil {
            _email = "Not available"
        }
        return _email
        
    }
    
    var mobileNumber: String {
        
        if _mobileNumber == nil {
            _mobileNumber = "Not available"
        }
        return _mobileNumber
        
    }
    
   /*
    func getVendorDetails(postVendorID:[String: AnyObject], completionHandler: @escaping(NSDictionary?, NSError?) -> ()) {
        
        
        let url = "\(BASE_URL)vendorservices"
        print("\(url)")
        print("\(postVendorID)")
        
        Alamofire.request(url, method: .post, parameters: postVendorID, encoding: URLEncoding.default, headers: nil).responseJSON { response in
           // print(response)
            completionHandler(response.result.value as? NSDictionary, response.result.error as NSError?)
            
            #if DEBUG
            //print("response:\(String(describing: response.result.value))")
            
                #endif
        }
        
        
        
    }
    */
    
    /*
    
    func getProductDetails(postProductID:[String: AnyObject], completionHandler: @escaping(NSDictionary?, NSError?) -> ()) {
        
        let url = "\(BASE_URL)product_details"
        
        
        Alamofire.request(url, method: .post, parameters: postProductID, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            completionHandler(response.result.value as? NSDictionary, response.result.error as NSError?)
            
            
            #if DEBUG
                //print("response:\(String(describing: response.result.value))")
                
            #endif
            
        }
        
    }
    
  
    func addPerfumesToCart(postPerfumDetails:[String: AnyObject], completionHandler: @escaping(NSDictionary?, NSError?) -> ()) {
        
        let url = "\(BASE_URL)addToCart"
        
        Alamofire.request(url, method: .post, parameters: postPerfumDetails, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            completionHandler(response.result.value as? NSDictionary, response.result.error as NSError?)
            
            #if DEBUG
                //print("response:\(String(describing: response.result.value))")
                
            #endif
        }
        
        
    }
    
    
    func getCartDetails(postUserIDforCartDetails:[String: AnyObject], completionHandler: @escaping(NSDictionary?, NSError?) -> ()) {
        
        let url = "\(BASE_URL)cartList"
        
        Alamofire.request(url, method: .post, parameters: postUserIDforCartDetails, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            completionHandler(response.result.value as? NSDictionary, response.result.error as NSError?)
            
            
        }
        
    }
    
    
    func getGiftPacks(completionHandler: @escaping(NSDictionary?, NSError?) -> ()) {
        
        
        let url = "\(BASE_URL)bouquets?API-KEY=\(APIKEY)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            completionHandler(response.result.value as? NSDictionary, response.result.error as NSError?)
        }
        
    }
    
    func addBouqetToCart(postBouqeDetails:[String: AnyObject], completionHandler:@escaping(NSDictionary?, NSError?)-> ()) {
        
        let url = "\(BASE_URL)giftaddToCart"
        
        Alamofire.request(url, method: .post, parameters: postBouqeDetails, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            completionHandler(response.result.value as? NSDictionary, response.result.error as NSError?)
            
        }
        
    }
    
    
    func cartUpdateIncrementAndDecrement(postQtyIncAndDecValues:[String: AnyObject], completionHandler:@escaping(NSDictionary?, NSError?) -> ()) {
        
        let url = "\(BASE_URL)update_quantity"
        
        Alamofire.request(url, method: .post, parameters: postQtyIncAndDecValues, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
           
            completionHandler(response.result.value as? NSDictionary, response.result.error as NSError?)
            
            
        }
        
        
    }
    
    func deleteitemFromCart(postCartItemDetail:[String: AnyObject], completionHandler:@escaping(NSDictionary?, NSError?) -> ()) {
        
        let url = "\(BASE_URL)deleteCart"
        
        Alamofire.request(url, method: .post, parameters: postCartItemDetail, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            completionHandler(response.result.value as? NSDictionary, response.result.error as NSError?)
            
            
        }
        
    }
    
    
    func deleteGiftitemFromCart(postCartGiftDetail:[String: AnyObject], completionHandler:@escaping(NSDictionary?, NSError?) -> ()) {
        
        let url = "\(BASE_URL)deleteGiftCart"
        
        Alamofire.request(url, method: .post, parameters: postCartGiftDetail, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            completionHandler(response.result.value as? NSDictionary, response.result.error as NSError?)
            
            
        }
        
    }
    
    func applyCoupon(postCouponDetail:[String: AnyObject], completionHandler:@escaping(NSDictionary?, NSError?) -> ()) {
        
        let url = "\(BASE_URL)apply_coupon"
        
        Alamofire.request(url, method: .post, parameters: postCouponDetail, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            completionHandler(response.result.value as? NSDictionary, response.result.error as NSError?)
            
            
        }
        
    }
    
    
    func saveAdress(postAdressDetails:[String: AnyObject], completionHandler:@escaping(NSDictionary?, NSError?) -> ()) {
        
        let url = "\(BASE_URL)add_uaddress"
        
        Alamofire.request(url, method: .post, parameters: postAdressDetails, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            completionHandler(response.result.value as? NSDictionary, response.result.error as NSError?)
            
            
        }
    }
    
    
    func getUserAdress(postUserID:[String: AnyObject], completionHandler:@escaping(NSDictionary?, NSError?) -> ()) {
       
        let url = "\(BASE_URL)uaddress"
        
        Alamofire.request(url, method: .post, parameters: postUserID, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            completionHandler(response.result.value as? NSDictionary, response.result.error as NSError?)
            
            
        }
        
    }
    
    func shedualDelevery(postDeleveryDetails:[String: AnyObject], completionHandler:@escaping(NSDictionary?, NSError?) -> ()) {
        
        
        let url = "\(BASE_URL)schedule_delivery"
        
        Alamofire.request(url, method: .post, parameters: postDeleveryDetails, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            completionHandler(response.result.value as? NSDictionary, response.result.error as NSError?)
            
        }
        
    }

    
    func vendorChecking(postUserID:[String: AnyObject], completionHandler:@escaping(NSDictionary?, NSError?) -> ()) {
        
        
        let url = "\(BASE_URL)checkvendor"
        
        Alamofire.request(url, method: .post, parameters: postUserID, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            completionHandler(response.result.value as? NSDictionary, response.result.error as NSError?)
            
        }
        
    }
    
    
    
    func removeAllCartItems(postUserIDForRemovingCart:[String: AnyObject], completionHandler:@escaping(NSDictionary?, NSError?) -> ()) {
        
        
        let url = "\(BASE_URL)removeuserCart"
        
        Alamofire.request(url, method: .post, parameters: postUserIDForRemovingCart, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            completionHandler(response.result.value as? NSDictionary, response.result.error as NSError?)
            
        }
        
    }
    
}
*/
func alertToUser( message: String, inViewCtrl:UIViewController) -> ()
{
    let alert = UIAlertController(title: "Alert",
                                  message: message,
                                  preferredStyle: UIAlertController.Style.alert)
    
    let cancelAction = UIAlertAction(title: "OK",
                                     style: .cancel, handler: nil)
    
    alert.view.tintColor = UIColor.lightGray
    alert.addAction(cancelAction)
    inViewCtrl.present(alert, animated: true, completion: nil)
    
}





func noInternetConnectionlabel (inViewCtrl:UIView) {
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .transitionCurlUp, animations: {
       
        let lblNew = UILabel()
        lblNew.frame = CGRect(x: 0, y: 0, width: inViewCtrl.frame.size.width, height: 50)
        lblNew.backgroundColor = UIColor.gray
        lblNew.textAlignment = .center
        lblNew.text = "No Internet Connection"
        lblNew.textColor = UIColor.white
        inViewCtrl.addSubview(lblNew)
        lblNew.font=UIFont.systemFont(ofSize: 18)
        lblNew.alpha = 0.5
        lblNew.transform = .identity
    }, completion: nil)
}
}
extension UIView {
    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}

extension String {
    
    func strstr(needle: String, beforeNeedle: Bool = false) -> String? {
        guard let range = self.range(of: needle) else { return nil }
        
        if beforeNeedle {
            return self.substring(to: range.lowerBound)
        }
        
        return self.substring(from: range.upperBound)
    }
    /*
     NSBundle *path;
     int selectedLanguage;
     
     selectedLanguage = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"currentLanguage"];
     
     if(selectedLanguage==ENGLSIH_LANGUAGE)
     path = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"]];
     
     else if (selectedLanguage==ARABIC_LANGUAGE)
     {
     
     path = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"ar" ofType:@"lproj"]];
     }
     else{
     path = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"]];
     
     }
     
     //NSBundle* languageBundle = [NSBundle bundleWithPath:path];
     NSString *str = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(key, @"LocalizeStrings", path, nil)];
     // NSString* str=[languageBundle localizedStringForKey:key value:@"" table:nil];
     return str;
 */
   
    
}


