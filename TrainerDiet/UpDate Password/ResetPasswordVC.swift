//
//  ResetPasswordVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 25/06/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController {
    
    @IBOutlet var newPassword_Txt: UITextField!
    @IBOutlet var confirmPassword_Txt: UITextField!
    @IBOutlet var newPasswordBtn: UIButton!
    @IBOutlet var confirmPasswordBtn: UIButton!
    
    var isFormStr = String()
    var mobileNum = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true

    }
    @IBAction func backBtn_Action(_ sender: UIButton) {
        
        
        if let navController = self.navigationController {
            
            navController.popViewController(animated: true)
        }
        
        
    }
    
    @IBAction func newPasswordShowHideBtn_Action(_ sender: UIButton) {
        
        if(sender.isSelected == true) {
                                 
          sender.isSelected = false
          self.newPassword_Txt.isSecureTextEntry = true
    }
    else
    {
      sender.isSelected = true
      self.newPassword_Txt.isSecureTextEntry = false
    }
        
    }
    
    @IBAction func confirmPasswordShowHideBtn_Action(_ sender: UIButton) {
        
        if(sender.isSelected == true) {
                          
           sender.isSelected = false
           self.confirmPassword_Txt.isSecureTextEntry = true
        }
        else
        {
          sender.isSelected = true
          self.confirmPassword_Txt.isSecureTextEntry = false
            
        }
    }
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        
        
        if self.newPassword_Txt.text == "" {
            
            self.showToast(message: "Please enter new password")
            
        }else if self.confirmPassword_Txt.text == "" {
            
            self.showToast(message: "Please enter confirm password")
            
        }else if self.newPassword_Txt.text != self.confirmPassword_Txt.text {
            
            self.showToast(message: "Password do not match")
            
            
        }else{
            
            self.UpDatePasswordHandlerMethod()
        }
        
    }
    
    
    func UpDatePasswordHandlerMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: " Please wait")

        var urlString = String()
        var userMobileNum = Int()
        var trainerMobileNum = String()

        if self.isFormStr == "TrainerForgot" {
            
            urlString = "https://beapis.dieatto.com:8090/dao/trainerlogin/updatePassword/\(mobileNum)/\(self.newPassword_Txt.text!)"

            
        } else if self.isFormStr == "UserForgot"  {
            
            urlString = "https://beapis.dieatto.com:8090/dao/sublogin/updatePassword/\(mobileNum)/\(self.newPassword_Txt.text!)"

        }
        
        else if isFormStr == "Trainer" {
            
            trainerMobileNum = UserDefaults.standard.object(forKey: "mobile") as? String ?? ""
            
            urlString = "https://beapis.dieatto.com:8090/dao/trainerlogin/updatePassword/\(trainerMobileNum)/\(self.newPassword_Txt.text!)"
            
            
        }else{
            
            userMobileNum = UserDefaults.standard.object(forKey: "subMobile") as? Int ?? 0
            
            urlString = "https://beapis.dieatto.com:8090/dao/sublogin/updatePassword/\(userMobileNum)/\(self.newPassword_Txt.text!)"
            
        }
        
        TrinerAPI.sharedInstance.TrinerService_get(paramsDict: ["":""], urlPath:urlString,onCompletion: {
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
                
                //self.showToast(message: "Invalide OTP")
                
            }else{
            
            self.showToast(message: "Password Updated")

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {

            if self.isFormStr == "UserForgot" {
                
                self.navigationController?.popToViewController(ofClass: LoginVC.self)

            }else if self.isFormStr == "TrainerForgot" {
                
                self.navigationController?.popToViewController(ofClass: TrainerLoginVC.self)
                
            }
            else{
                
                            //Mark:- Trainer store vales
                           UserDefaults.standard.removeObject(forKey: "trainerLogin")
                           UserDefaults.standard.removeObject(forKey: "mobile")
                           UserDefaults.standard.removeObject(forKey: "emailId")
                           UserDefaults.standard.removeObject(forKey: "firstName")
                           UserDefaults.standard.removeObject(forKey: "lastName")
                           
                           UserDefaults.standard.removeObject(forKey: "trainerId")
                           UserDefaults.standard.removeObject(forKey: "trainerGymId")
                           UserDefaults.standard.removeObject(forKey: "trainerLogin")
                           
                
                           //Mark:- User store vales
                           UserDefaults.standard.removeObject(forKey: "subMobile")
                           UserDefaults.standard.removeObject(forKey: "subEmailId")
                           UserDefaults.standard.removeObject(forKey: "firstName")
                           UserDefaults.standard.removeObject(forKey: "lastName")
                           UserDefaults.standard.removeObject(forKey: "subtrainerId")
                           
                           UserDefaults.standard.removeObject(forKey: "subId")
                           UserDefaults.standard.removeObject(forKey: "trainerGymId")
                           UserDefaults.standard.removeObject(forKey: "userLogin")
                           UserDefaults.standard.synchronize()
                           
                           let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                           self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
         
            }
        }
        )
    }
    
}
