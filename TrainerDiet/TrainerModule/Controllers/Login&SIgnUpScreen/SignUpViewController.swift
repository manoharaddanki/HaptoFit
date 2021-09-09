
//
//  SignUpViewController.swift
//  TrainerDiet
//
//  Created by RadhaKrishna on 29/05/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var gymNameField: UITextField!
    @IBOutlet weak var gymLocationField: UITextField!
    @IBOutlet weak var gymCityFiled: UITextField!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordFiled: UITextField!
    @IBOutlet weak var stateCodeFiled: UITextField!
    @IBOutlet weak var pincodeField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet var mapBgView: UIView!
    
    @IBOutlet weak var selectCodePicker: UIPickerView!
    
    var stateCodeListArray = [String]()
    var maxLen:Int = 10;
    let screenSize: CGRect = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //getCountryCodeList()
        hideKeyboardWhenTappedAround()
        mobileField.delegate = self
        //        self.selectCodePicker.isHidden = true
        
        firstNameField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        lastNameField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        gymNameField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        gymCityFiled.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        gymLocationField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        mobileField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordFiled.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)


    }
    
    @IBAction func stateCodeBtn_Action(_ sender: Any) {
        
        //self.selectCodePicker.isHidden = false
        
    }
    @IBAction func registerBtnAction(_ sender: Any) {
        
        if firstNameField.text == ""
        {
            //self.view.makeToast("Enter Your First Name")
            showToast(message: "Please Specify First Name")
            
            return
        }
        else if lastNameField.text == ""
        {
            showToast(message: "Please Specify Last Name")
            return
        }
        else if gymNameField.text == ""
        {
            showToast(message: "Please Specify Gym Name")
            return
        }
        else if gymCityFiled.text == ""
        {
            showToast(message: "Please Specify Gym City")
            return
        }
        else if gymLocationField.text == ""
        {
            showToast(message: "Please Specify Location")
            return
        }
        else if mobileField.text == ""
        {
            showToast(message: "Please Specify Mobile Number")
            return
        }
        else if !isValidPhone(phone: self.mobileField.text!)
        {
            showToast(message: "Please Specify Mobile Number")
                return
        }
        else if passwordFiled.text?.count ?? 0 < 4
        {
            showToast(message: "Password contains atleast 4 digits")
            return
        }
        else if emailField.text == ""
        {
            showToast(message: "Please Specify Email Address")
            return
        }
            
        else if isValidEmail(testStr: emailField.text!){
            
             let params = ["trainerFirstName" :"\(firstNameField.text!)","trainerLastName":"\(self.lastNameField.text!)","trainerGymLocation":"\(self.gymLocationField.text!)","trainerGymName":"\(self.gymNameField.text!)","trainerCity":"\(self.gymCityFiled.text!)","trainerEmail":"\(self.emailField.text!)","trainerPrimaryMob":"\(self.mobileField.text!)","trainerGymState": "null","trainerGymPincode":"null","trainerShift": "null","password":"\(self.passwordFiled.text!)","loginId":"\(self.mobileField.text!)"]
            
            let objVC = self.storyboard?.instantiateViewController(withIdentifier: "PinViewController") as! PinViewController
            objVC.mobieNum = self.mobileField.text!
            objVC.registerParams = params
            self.navigationController?.pushViewController(objVC, animated: true)
            
        }
        else {
            
            showToast(message: "Please Specify Valid Email Address")
            return
        }
    }
    
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }

        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.registerBtn.isEnabled = false
            showToast(message: "White spaces is not allowed")

            return
        }else if text == "Null" || text == "null" {
            
            self.registerBtn.isEnabled = false
            showToast(message: "null text is not allowed")
            self.registerBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)

        }else{
            
            self.registerBtn.isEnabled = true
            self.registerBtn.setBackgroundImage(UIImage(named: "Rectangle -3"), for: .normal)

        }
    }
    
    @IBAction func locationBtnAction(_ sender: Any) {
        
        mapBgView.frame = CGRect.init(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        //        mapBgView.backgroundColor = UIColor.black     //give color to the view
        mapBgView.center = self.view.center
        self.view.addSubview(mapBgView)
    }
    
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    @IBAction func getLocationAction(_ sender: Any) {
        
        mapBgView.removeFromSuperview()
    }
    
    /// Get Country Code Form Api Call
    func getCountryCodeList(){
        
        
        let urlString = "https://restcountries.eu/rest/v1/all"
        let url = URL.init(string: urlString)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            guard error == nil else {
                print(error)
                return
            }
            do {
                let Data = try JSONSerialization.jsonObject(with: data!) as! NSArray
                
                for i in 0..<Data.count{
                    
                    let dict = Data[i] as? NSDictionary
                    
                    if let countryCode = dict?.value(forKey: "alpha2Code") as? String
                    {
                        self.stateCodeListArray.append(countryCode)
                        
                    }
                    
                }
                
            } catch let error as NSError {
                print(error)
            }
        }.resume()
    }
    func registerHandlerMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: " Please wait")

        let params = ["trainerFirstName" :"\(firstNameField.text!)","trainerLastName":"\(self.lastNameField.text!)","trainerGymLocation":"\(self.gymLocationField.text!)","trainerGymName":"\(self.gymNameField.text!)","trainerCity":"\(self.gymCityFiled.text!)","trainerEmail":"\(self.emailField.text!)","trainerPrimaryMob":"\(self.mobileField.text!)","trainerGymState": "null","trainerGymPincode":"null","trainerShift": "null","password":"\(self.passwordFiled.text!)","loginId":"\(self.mobileField.text!)"]
        
        let urlString = TrinerUrlPath.sharedInstance.getUrlPath("dao/trainer/registration/register")
        
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
                Services.sharedInstance.dissMissLoader()
                return
            }else
            {
                let dict = dict_responce(dict: response)
            let statusCode = response?.value(forKey: "status") as? Int

                if statusCode == 500 {
                               
                               
                }else{
                    
                    //UserDefaults.standard.set(self.gymNameField.text!, forKey: "gymName")
                    let objVC = self.storyboard?.instantiateViewController(withIdentifier: "PinViewController") as! PinViewController
                                   
                    objVC.mobieNum = self.mobileField.text!
                    self.navigationController?.pushViewController(objVC, animated: true)
                }                
                Services.sharedInstance.dissMissLoader()
            }
        }
        )
    }
    
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^(?:[+0]9)?[0-9]{10}$" //"^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    /// Email Validation Method
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        
        let emailRegEx =  "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"

        //let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
                
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}

///UITextFieldDelegate Methods
extension SignUpViewController : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == mobileField){
            let currentText = textField.text! + string
            return currentText.count <= maxLen
        }
        
        return true;
    }
    
}
/// UIPickerView DataSource & Delegate Methods
extension SignUpViewController :UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return stateCodeListArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stateCodeListArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        let selectedCode = stateCodeListArray[row] as String
        self.stateCodeFiled.text = selectedCode
        print("selected code is ==\(selectedCode)")
        self.view.endEditing(true)
        self.selectCodePicker.isHidden = true
    }
    
}
