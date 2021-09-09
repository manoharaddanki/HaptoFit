//
//  TrainerLoginVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 26/06/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

class TrainerLoginVC: UIViewController {
    
    @IBOutlet var signInScrollView: UIScrollView!
    @IBOutlet var userName_Txt: UITextField!
    @IBOutlet var passowrd_Txt: UITextField!
    @IBOutlet var rememberButton: UIButton!
    @IBOutlet var loginBorderLbls: [UILabel]!
    @IBOutlet var psw_Error_Lbl: UILabel!
    @IBOutlet var userName_Error_Lbl: UILabel!
    @IBOutlet var signInButton: UIButton!
    
    var rememberStatus : Bool!
    var subLogInBool : Bool = false
    var maxLen:Int = 10;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.userName_Txt.delegate = self
        for lbl in loginBorderLbls {
            
            lbl.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        }
        self.hideKeyboardWhenTappedAround()
        rememberStatus = rememberButton.isSelected
        psw_Error_Lbl.isHidden = true
        userName_Error_Lbl.isHidden = true
        
        //userName_Txt.delegate = self as! UITextFieldDelegate
        userName_Txt.returnKeyType = .next
        passowrd_Txt.returnKeyType = .next
        
        //self.navigationController?.navigationBar.isHidden = true
        rememberButton.backgroundColor = UIColor.clear
        
        //RememberButton
        if let uname = USER_DEFAULTS.value(forKey: "trainerUserName") {
            
            userName_Txt.text = uname as? String
            passowrd_Txt.text = USER_DEFAULTS.value(forKey: "trainerPassword") as? String
            rememberButton.isSelected = true
            self.signInButton.setBackgroundImage(UIImage(named: "Rectangle -3"), for: .normal)

         }
        
        userName_Txt.addTarget(self, action: #selector(ProfileVC.textFieldDidChange(_:)), for: .editingChanged)
        passowrd_Txt.addTarget(self, action: #selector(ProfileVC.textFieldDidChange(_:)), for: .editingChanged)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
        
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if userName_Txt.text == "" || passowrd_Txt.text! == "" {
            
            self.signInButton.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)

        } else {
            
            self.signInButton.setBackgroundImage(UIImage(named: "Rectangle -3"), for: .normal)
        }
    }
    
    
    @IBAction func passwordShowHideBtn_Action(_ sender: UIButton) {
             
             if(sender.isSelected == true) {
                                      
               sender.isSelected = false
               self.passowrd_Txt.isSecureTextEntry = true
         }
         else
         {
           sender.isSelected = true
           self.passowrd_Txt.isSecureTextEntry = false
         }
             
         }
    
    @IBAction func signUPBtnAction(_ sender: UIButton) {
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    

    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        
        
        if userName_Txt.text == ""
        {
            showToast(message: "Enter your login id")
            return
        }
        else if passowrd_Txt.text == ""
        {
            showToast(message: "Enter your password")
            return
        }
        else{

            self.trainerLoginHandlerMethod()

        }
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
                           replacementString string: String) -> Bool
    {
        let maxLength = 12
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
   
    
    @IBAction func forgotBtnAction(_ sender: UIButton) {
        
    let objVC = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
    objVC.isFrom = "TrainerForgot"

    self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    @IBAction func userBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }

    
    @IBAction func rememberButtonAction(_ sender: UIButton) {
        
        if(sender.isSelected == true) {
            
            sender.isSelected = false
            rememberStatus = false
            
            UserDefaults.standard.removeObject(forKey: "trainerUserName")
            UserDefaults.standard.removeObject(forKey: "trainerPassword")
            UserDefaults.standard.synchronize()

        }
        else
        {
            rememberButton.backgroundColor = UIColor.clear
            sender.isSelected = true
            rememberStatus = true
            
            UserDefaults.standard.set(self.userName_Txt.text, forKey: "trainerUserName")
            UserDefaults.standard.set(self.passowrd_Txt.text, forKey: "trainerPassword")
        }
    }
    
    
    func trainerLoginHandlerMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: " Please wait")

        let urlString = TrinerUrlPath.sharedInstance.getUrlPath("dao/trainerlogin/verify/\(userName_Txt.text!)/\(passowrd_Txt.text!)")
        
        TrinerAPI.sharedInstance.TrinerService_get(paramsDict: ["":""], urlPath:urlString,onCompletion: {
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
                Services.sharedInstance.dissMissLoader()
                return
            }else
            {
                Services.sharedInstance.dissMissLoader()
                
                let dict = dict_responce(dict: response)

                if dict.value(forKey: "loginStatus") as? String == "SUCCESS" {
                
                if dict.value(forKey: "trainerAuthorized") as? Int == 1 {
                    
                    let mobileNum = dict.value(forKey: "mobileNumber") as? String
                    let email = dict.value(forKey: "emailId") as? String
                    let lastName = dict.value(forKey: "trainerLastName") as? String
                    let firstName = dict.value(forKey: "trainerFirstName") as? String
                    let trainerId = dict.value(forKey: "trainerId") as? Int
                    let trainerGymId = dict.value(forKey: "trainerGymId") as? Int
                    let trainerAuthorized = dict.value(forKey: "trainerAuthorized") as? Int

                
                        UserDefaults.standard.set(mobileNum, forKey: "mobile")
                        UserDefaults.standard.set(email, forKey: "emailId")
                        UserDefaults.standard.set(firstName, forKey: "firstName")
                        UserDefaults.standard.set(lastName, forKey: "lastName")
                        UserDefaults.standard.set(trainerId, forKey: "trainerId")
                        UserDefaults.standard.set(trainerGymId, forKey: "trainerGymId")
                        UserDefaults.standard.set(true, forKey: "trainerLogin")
                        UserDefaults.standard.set(true, forKey: "trainerAuthorized")
                    
                       var topic = "/app/community.send/\(trainerGymId!)"
                       UserDefaults.standard.set(topic, forKey: "Channel")

                    //Praveen
                    Defaults.trainerFirstName = firstName
                    Defaults.trainerLastName = lastName
                    Defaults.trainer_GYM_ID = trainerGymId

                    
                        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    else
                    {

                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThanksVC") as! ThanksVC
                vc.isFrom = "UnauthorisedLogin"
                self.navigationController?.pushViewController(vc, animated: true)
                        

                    }
                
                }else if dict.value(forKey: "loginStatus") as? String == "NO ENTRY" {
                    
                                    
            AlertSingletanClass.sharedInstance.validationAlert(title: "Error", message: "User name doesn't exist", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                            
            })
                    
                }else{
                  
                    AlertSingletanClass.sharedInstance.validationAlert(title: "Error", message: "Incorrect password", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                                               
                               })
                    
                }
                }
            }
            )
        }
    
}

///UITextFieldDelegate Methods
extension TrainerLoginVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == userName_Txt){
            let currentText = textField.text! + string
            return currentText.count <= maxLen
        }
        
        return true;
    }
    
}
