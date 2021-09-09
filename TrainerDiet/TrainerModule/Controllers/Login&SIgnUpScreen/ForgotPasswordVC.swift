//
//  ForgotPasswordVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 25/06/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet var mobile_Txt: UITextField!
    
    var isFrom = String()
    var maxLen:Int = 10;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
           
         if let navController = self.navigationController {
                   
                   navController.popViewController(animated: true)
               }
           
       }
    
    @IBAction func forgotPasswordBtnAction(_ sender: UIButton) {
        
        if self.mobile_Txt.text == "" {
            
            showToast(message: "Please enter registered mobile number")
            
        }else{
            
            sendOTPPostMethod()
        }
        
    }
    
    func sendOTPPostMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: " Please wait")

        let params = ["mobilenumber" :"\(mobile_Txt.text!)"]
        
        let  urlString = "https://beapis.dieatto.com:8090/otpmanager/sendotp"
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
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "PinViewController") as! PinViewController
            
            vc.isFrom = self.isFrom
            vc.mobieNum = self.mobile_Txt.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
                        
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
    
}
///UITextFieldDelegate Methods
extension ForgotPasswordVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == mobile_Txt){
            let currentText = textField.text! + string
            return currentText.count <= maxLen
        }
        
        return true;
    }
    
}
