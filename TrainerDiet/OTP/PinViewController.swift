//
//  PinViewController.swift
//  SVPinView
//
//  Created by Srinivas Vemuri on 31/10/17.
//  Copyright © 2017 Xornorik. All rights reserved.
//
import UIKit
import SVPinView
import Alamofire

class PinViewController: UIViewController {
    
    @IBOutlet var pinView: SVPinView!
    
    var mobieNum = String()
    
    var isFrom = String()
    
    var registerParams = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePinView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        

        if isFrom == "UserForgot" || isFrom == "TrainerForgot" {
            
            
        }else{
            
            self.sendOTPPostMethod()

        }
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Setup background gradient
        let valenciaColor = UIColor(red: 0/255, green: 68/255, blue: 83/255, alpha: 1)
        let discoColor = UIColor(red: 0/255, green: 33/255, blue: 107/255, alpha: 1)
        setGradientBackground(view: self.view, colorTop: valenciaColor, colorBottom: discoColor)
    }
    
    func configurePinView() {
        
        pinView.pinLength = 6
        pinView.secureCharacter = "\u{25CF}"
        pinView.interSpace = 10
        pinView.textColor = UIColor.white
        pinView.borderLineColor = UIColor.white
        pinView.activeBorderLineColor = UIColor.white
        pinView.borderLineThickness = 1
        pinView.shouldSecureText = true
        pinView.allowsWhitespaces = false
        pinView.style = .none
        pinView.fieldBackgroundColor = UIColor.white.withAlphaComponent(0.3)
        pinView.activeFieldBackgroundColor = UIColor.white.withAlphaComponent(0.5)
        pinView.fieldCornerRadius = 15
        pinView.activeFieldCornerRadius = 15
        pinView.placeholder = "******"
        pinView.becomeFirstResponderAtIndex = 0
        pinView.shouldDismissKeyboardOnEmptyFirstField = false
        
        pinView.font = UIFont.systemFont(ofSize: 15)
        pinView.keyboardType = .phonePad
        pinView.pinInputAccessoryView = { () -> UIView in
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            doneToolbar.barStyle = UIBarStyle.default
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
            
            var items = [UIBarButtonItem]()
            items.append(flexSpace)
            items.append(done)
            
            doneToolbar.items = items
            doneToolbar.sizeToFit()
            return doneToolbar
        }()
        
        pinView.didFinishCallback = didFinishEnteringPin(pin:)
//        pinView.didChangeCallback = { pin in
//            print("The entered pin is \(pin)")
//        }
    }
    
    @objc override func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    @IBAction func backBtn(_ sender: Any) {
           
        self.navigationController?.popViewController(animated: true)
    
    }
   
    @IBAction func resendOTPbtn(_ sender: Any) {
           
        self.sendOTPPostMethod()
    }
    
    func didFinishEnteringPin(pin:String) {
        
        self.VerifyOTPPostMethod(otpStr: pin)
        //showAlert(title: "Success", message: "The Pin entered is \(pin)")
    }
    
    // MARK: Helper Functions
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setGradientBackground(view:UIView, colorTop:UIColor, colorBottom:UIColor) {
        for layer in view.layer.sublayers! {
            if layer.name == "gradientLayer" {
                layer.removeFromSuperlayer()
            }
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        gradientLayer.name = "gradientLayer"
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func sendOTPPostMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: " Please wait")

        let params = ["mobilenumber" :"\(mobieNum)"]
        
        let urlString = "https://beapis.dieatto.com:8090/otpmanager/sendotp"
        
        print("SendOTP Call -->\(urlString)")
        print("SendOTP params -->\(params)")

        TrinerAPI.sharedInstance.TrainerService_put_with_header(paramsDict: params as NSDictionary, urlPath:urlString,onCompletion: {
            (response,error) -> Void in
            
            if let networkError = error {
                
                Services.sharedInstance.dissMissLoader()
                
                if (networkError.code == -1009) {
                    print("No Internet \(String(describing: error))")
                    //Services.sharedInstance.dissMissLoader()
                    AlertSingletanClass.sharedInstance.validationAlert(title: "No Internet", message: "", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                    })
                    
                    return
                }
            }
            
            if response == nil
            {
                Services.sharedInstance.dissMissLoader()
                return
            }else
            {
                let dict = dict_responce(dict: response)
                if status_Check(dict: dict)
                {
                    AlertSingletanClass.sharedInstance.validationAlert(title: "Success", message: "You have successfully register your account. Please login.", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                        
                        print("Register response is ==\(dict)")
                    })
                    
                    
                }else
                {
                    if let err_code = dict.value(forKeyPath: "error") as? String {
                        
                        AlertSingletanClass.sharedInstance.validationAlert(title: "Error", message: err_code, preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                        })
                    }
                }
                Services.sharedInstance.dissMissLoader()
            }
        }
        )
    }
    
    
    func VerifyOTPPostMethod(otpStr: String) {
        
        Services.sharedInstance.customLoader(view: self.view, message: " Please wait")

        let params = ["mobilenumber" :"\(mobieNum)", "otp":"\(otpStr)"]
        
        let  urlString = "https://beapis.dieatto.com:8090/otpmanager/validateotp"
        
        print("ValidateOTP Call -->\(urlString)")
        print("ValidateOTP params -->\(params)")
        
        TrinerAPI.sharedInstance.TrainerService_put_with_header(paramsDict: params as NSDictionary, urlPath:urlString,onCompletion: {
            (response,error) -> Void in
            
            if let networkError = error {
                
                Services.sharedInstance.dissMissLoader()
                
                if (networkError.code == -1009) {
                    print("No Internet \(String(describing: error))")
                    Services.sharedInstance.dissMissLoader()
                    AlertSingletanClass.sharedInstance.validationAlert(title: "No Internet", message: "", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                    })
                    
                    return
                }
            }
            
            Services.sharedInstance.dissMissLoader()

            let statusCode = response?.value(forKey: "status") as? Int

            
            if statusCode == 500 {
                
                self.showToast(message: "Invalide OTP")
                self.pinView.clearPin()
                
            }else{
                
                if self.isFrom == "TrainerForgot" || self.isFrom == "UserForgot"{
                    
                    self.showToast(message: "Invalide OTP")

                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
                    vc.isFormStr = self.isFrom
                    vc.mobileNum = Int(self.mobieNum) ?? 0
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else{
                        
                    self.registerHandlerMethod()
                    
                }
                
            }
            
        }
        )
    }
    
    
    func registerHandlerMethod() {
                
        let urlString = TrinerUrlPath.sharedInstance.getUrlPath("dao/trainer/registration/register")
        
        let params = self.registerParams
        print("params is ==\(params)")
        TrinerAPI.sharedInstance.TrainerService_put_with_header(paramsDict: params as NSDictionary, urlPath:urlString,onCompletion: {
            (response,error) -> Void in
            
            if let networkError = error {
                
                //Services.sharedInstance.dissMissLoader()
                
                if (networkError.code == -1009) {
                    print("No Internet \(String(describing: error))")
                    //Services.sharedInstance.dissMissLoader()
                    AlertSingletanClass.sharedInstance.validationAlert(title: "No Internet", message: "", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                    })
                    
                    return
                }
            }
                        
            if response == nil
            {
//                Services.sharedInstance.dissMissLoader()
                return
            }else
            {
                //let dict = dict_responce(dict: response)
    
                let statusCode = response?.value(forKey: "status") as? Int

                if statusCode == 500 {
                               
                //self.showToast(message: "Invalide OTP")
                
                
                }else  if response?.value(forKey: "trainerExistingStatus") as? String == "Yes" {
                                              
                    AlertSingletanClass.sharedInstance.validationAlert(title: "Error", message: "Trainer already exists this mobile number", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                        
                        self.navigationController?.popViewController(animated: true)

                    })
                               
                    }else{
                    
                    AlertSingletanClass.sharedInstance.validationAlert(title: "Success", message: "You have successfully register your account. Please login.", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                                           
                        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThanksVC") as! ThanksVC
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    })
                }
               
                Services.sharedInstance.dissMissLoader()
            }
        }
        )
    }
    
}
