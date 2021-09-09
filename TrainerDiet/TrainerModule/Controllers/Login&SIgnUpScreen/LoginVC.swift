//
//  ViewController.swift
//  Dieatto
//
//  Created by Developer Dev on 27/09/19.
//  Copyright © 2019 Developer Dev. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
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
        
        userName_Txt.returnKeyType = .next
        passowrd_Txt.returnKeyType = .next
        
        //self.navigationController?.navigationBar.isHidden = true
        rememberButton.backgroundColor = UIColor.clear
        
        //RememberButton
        if let uname = USER_DEFAULTS.value(forKey: USER_NAME_KEY) {
            
            userName_Txt.text = uname as? String
            passowrd_Txt.text = USER_DEFAULTS.value(forKey: PASSWORD_KEY) as? String
            rememberButton.isSelected = true
            self.signInButton.setBackgroundImage(UIImage(named: "Rectangle -3"), for: .normal)

        }
        
        userName_Txt.addTarget(self, action: #selector(ProfileVC.textFieldDidChange(_:)), for: .editingChanged)
        passowrd_Txt.addTarget(self, action: #selector(ProfileVC.textFieldDidChange(_:)), for: .editingChanged)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        self.addDoneButtonOnKeyboard()
    }
    
    
    func addDoneButtonOnKeyboard(){
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        //txtMobileNumber.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        
        //txtMobileNumber.resignFirstResponder()
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
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        
        //        let objVC = storyboard?.instantiateViewController(withIdentifier: "UserGenderVC") as! UserGenderVC
        //
        //        self.navigationController?.pushViewController(objVC, animated: true)
        
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
            
            self.userLoginHandlerMethod()
            
        }
        
    }
    
    @IBAction func trainerLoginBtnAction(_ sender: UIButton) {
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "TrainerLoginVC") as! TrainerLoginVC
        
        self.navigationController?.pushViewController(objVC, animated: true)
        
        
    }
    
    
    @IBAction func forgotBtnAction(_ sender: UIButton) {
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        objVC.isFrom = "UserForgot"
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    @IBAction func rememberButtonAction(_ sender: UIButton) {
        
        if(sender.isSelected == true) {
            
            sender.isSelected = false
            rememberStatus = false
            
            UserDefaults.standard.removeObject(forKey: "userName")
            UserDefaults.standard.removeObject(forKey: "password")
            UserDefaults.standard.synchronize()

        }
        else
        {
            rememberButton.backgroundColor = UIColor.clear
            sender.isSelected = true
            rememberStatus = true
            
            UserDefaults.standard.set(self.userName_Txt.text, forKey: "userName")
            UserDefaults.standard.set(self.passowrd_Txt.text, forKey: "password")
        }
    }
    
    
    func userLoginHandlerMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: " Please wait")

        let urlString = TrinerUrlPath.sharedInstance.getUrlPath("dao/sublogin/verify/\(userName_Txt.text!)/\(passowrd_Txt.text!)")
        
        TrinerAPI.sharedInstance.TrinerService_get(paramsDict: ["":""], urlPath:urlString,onCompletion: {
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
                
                Services.sharedInstance.dissMissLoader()

                if dict.value(forKey: "loginStatus") as? String == "SUCCESS" {
                    
                    let mobileNum = dict.value(forKey: "mobileNumber") as? Int
                    let email = dict.value(forKey: "emailId") as? String
                    let firstName = dict.value(forKey: "subFirstName") as? String
                    let lastName = dict.value(forKey: "subLastName") as? String
                    let trainerId = dict.value(forKey: "trainerId") as? Int
                    let subId = dict.value(forKey: "subId") as? Int
                    let fitnessLevel = dict.value(forKey: "subFitnessLevel") as? String
                    let plan = dict.value(forKey: "subSubscriptionPlan") as? String
                    let gender = dict.value(forKey: "gender") as? String
                    let gymId = dict.value(forKey: "gymId") as? Int
                    
                    UserDefaults.standard.set(mobileNum, forKey: "subMobile")
                    UserDefaults.standard.set(email, forKey: "subEmailId")
                    UserDefaults.standard.set(firstName, forKey: "firstName")
                    UserDefaults.standard.set(lastName, forKey: "lastName")
                    UserDefaults.standard.set(trainerId, forKey: "subtrainerId")
                    UserDefaults.standard.set(subId, forKey: "subId")
                    UserDefaults.standard.set(gymId, forKey: "trainerGymId")
                    UserDefaults.standard.set(gender, forKey: "gender")
                    UserDefaults.standard.set(plan, forKey: "subSubscriptionPlan")
                    UserDefaults.standard.set(fitnessLevel, forKey: "subFitnessLevel")

                    UserDefaults.standard.set(true, forKey: "userLogin")

                    var topic = "/app/community.send/\(gymId!)"

                    UserDefaults.standard.set(topic, forKey: "Channel")
                    
                    Defaults.trainerFirstName = firstName
                    Defaults.trainerLastName = lastName
                    Defaults.trainer_GYM_ID = gymId

                    
                    if  dict.value(forKey: "detailsStatuFlag") as? String == "Y" || dict.value(forKey: "detailsStatuFlag") as? String == "y" {
                        
                        
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "UserMainTabVC") as! UserMainTabVC
                        self.navigationController?.pushViewController(newViewController, animated: true)
                        
                    }else{
                        
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "PersonalInfoVC") as! PersonalInfoVC
                        self.navigationController?.pushViewController(newViewController, animated: true)
                    }
                                                        
                    //                        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserGenderVC") as! UserGenderVC
                    //                        self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                else if dict.value(forKey: "loginStatus") as? String == "NO ENTRY" {
                        
                                        
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
extension LoginVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == userName_Txt){
            let currentText = textField.text! + string
            return currentText.count <= maxLen
        }
        
        return true;
    }
    
}
