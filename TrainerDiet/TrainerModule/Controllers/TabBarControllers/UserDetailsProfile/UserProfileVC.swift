//
//  UserProfileVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 28/05/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

class UserProfileVC: UIViewController {
    
    @IBOutlet var signInScrollView: UIScrollView!
    @IBOutlet var title_Lbl: UILabel!
    @IBOutlet var userName_Txt: UITextField!
    @IBOutlet var userLastName_Txt: UITextField!
    
    @IBOutlet var mobile_Txt: UITextField!
    @IBOutlet var email_Txt: UITextField!
    @IBOutlet var user_Img: UIImageView!
    @IBOutlet var gender_Txt: UITextField!
    
    @IBOutlet var femaleButton: UIButton!
    @IBOutlet var maleButton: UIButton!
    
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var beginnerButton: UIButton!
    @IBOutlet var intermedButton: UIButton!
    @IBOutlet var advancedButton: UIButton!
    
    @IBOutlet var firstButton: UIButton!
    @IBOutlet var secondButton: UIButton!
    @IBOutlet var thirdButton: UIButton!
    
    @IBOutlet var backButton: UIButton!

    var fitnesssType = "Beginner"
    var subscriptionType = "Upper body"
    var genderType = String()
    
    var isFrom = String()
    
    var detailsDict = [SearchAllClientListModel]() //NSDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.mobile_Txt.addTarget(self, action: #selector(ProfileVC.textFieldDidChange(_:)), for: .editingChanged)
        self.email_Txt.addTarget(self, action: #selector(ProfileVC.textFieldDidChange(_:)), for: .editingChanged)
        // self.gender_Txt.addTarget(self, action: #selector(ProfileVC.textFieldDidChange(_:)), for: .editingChanged)
        self.userName_Txt.addTarget(self, action: #selector(ProfileVC.textFieldDidChange(_:)), for: .editingChanged)
        //self.mobile_Txt.delegate = self as? UITextFieldDelegate
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
       
        if isFrom == "AllUser" {
            
            self.userName_Txt.isUserInteractionEnabled = false
            self.userLastName_Txt.isUserInteractionEnabled = false
            self.email_Txt.isUserInteractionEnabled = false
            self.mobile_Txt.isUserInteractionEnabled = false
            self.maleButton.isUserInteractionEnabled = true
            self.femaleButton.isUserInteractionEnabled = true
            self.backButton.isHidden = false
            self.saveButton.setTitle("Save Changes", for: .normal)
            self.userName_Txt.text = detailsDict.first?.subscriberFirstName
            self.userLastName_Txt.text = detailsDict.first?.subscriberLastName
            self.email_Txt.text = detailsDict.first?.subscriberEmail
            let mobileNum = detailsDict.first?.subscriberPrimaryMob
            self.mobile_Txt.text = "\(mobileNum!)"
            let gender = detailsDict.first?.subscriberGender
            let fitnessLevel = detailsDict.first?.subscriberFitnessLevel
            let subscriptionPlan = detailsDict.first?.subscriberSubscriptionPlan
            
            if let subID = detailsDict.first?.id {
                downloadingImageFromServer(id: "\(subID)")
            }else{
                self.user_Img.image = UIImage(named: "icon-addNewUser")
            }
            
            if gender == 0 {
                
                self.femaleButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
                self.maleButton.setBackgroundImage(UIImage.init(named: "Rectangle -8"), for: .normal)
                self.maleButton.setTitleColor(UIColor.white, for: .normal)
                self.genderType = "Male"

            }else{
                
                self.maleButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
                self.femaleButton.setBackgroundImage(UIImage.init(named: "Rectangle -8"), for: .normal)
                self.femaleButton.setTitleColor(UIColor.white, for: .normal)
                self.genderType = "Female"

            }
            
            if fitnessLevel == "Beginner" {
                
                self.beginnerButton.setBackgroundImage(UIImage.init(named: "Rectangle -8"), for: .normal)
                self.intermedButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
                self.advancedButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
                self.beginnerButton.setTitleColor(UIColor.white, for: .normal)

                
            } else if fitnessLevel == "Intermediate" {
                
                
                self.beginnerButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
                self.intermedButton.setBackgroundImage(UIImage.init(named: "Rectangle -8"), for: .normal)
                self.advancedButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
                self.intermedButton.setTitleColor(UIColor.white, for: .normal)

                
            }else{
                
                self.beginnerButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
                self.intermedButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
                self.advancedButton.setBackgroundImage(UIImage.init(named: "Rectangle -8"), for: .normal)
                self.advancedButton.setTitleColor(UIColor.white, for: .normal)

            }
            
            if subscriptionPlan == "3M" || subscriptionPlan == "Upper body" {
                
                self.firstButton.setBackgroundImage(UIImage.init(named: "Rectangle -8"), for: .normal)
                self.secondButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
                self.thirdButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
                self.firstButton.setTitleColor(UIColor.white, for: .normal)

                
            }else if subscriptionPlan == "6M" || subscriptionPlan == "Abs"{
                
                self.firstButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
                self.secondButton.setBackgroundImage(UIImage.init(named: "Rectangle -8"), for: .normal)
                self.thirdButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
                self.secondButton.setTitleColor(UIColor.white, for: .normal)

            }else{
                
                self.firstButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
                self.secondButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
                self.thirdButton.setBackgroundImage(UIImage.init(named: "Rectangle -8"), for: .normal)
                self.thirdButton.setTitleColor(UIColor.white, for: .normal)

            }
            
        }else{
            
            self.userName_Txt.isUserInteractionEnabled = true
            self.userLastName_Txt.isUserInteractionEnabled = true
            self.email_Txt.isUserInteractionEnabled = true
            self.mobile_Txt.isUserInteractionEnabled = true
            self.maleButton.isUserInteractionEnabled = true
            self.femaleButton.isUserInteractionEnabled = true
            self.backButton.isHidden = true

            self.email_Txt.text = ""
            self.userName_Txt.text = ""
            self.userLastName_Txt.text = ""
            self.mobile_Txt.text = ""
            self.firstButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
            self.firstButton.setTitleColor(UIColor.init(hexFromString: "1D5384"), for: .normal)

            self.secondButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
            self.secondButton.setTitleColor(UIColor.init(hexFromString: "1D5384"), for: .normal)

            self.thirdButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
            self.thirdButton.setTitleColor(UIColor.init(hexFromString: "1D5384"), for: .normal)

            self.maleButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
            self.maleButton.setTitleColor(UIColor.init(hexFromString: "1D5384"), for: .normal)

            self.femaleButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
            self.femaleButton.setTitleColor(UIColor.init(hexFromString: "1D5384"), for: .normal)

            self.beginnerButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
            self.beginnerButton.setTitleColor(UIColor.init(hexFromString: "1D5384"), for: .normal)

            self.intermedButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
            self.intermedButton.setTitleColor(UIColor.init(hexFromString: "1D5384"), for: .normal)

            self.advancedButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
            self.advancedButton.setTitleColor(UIColor.init(hexFromString: "1D5384"), for: .normal)

            self.saveButton.setTitle("Add User", for: .normal)
            
        }
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if email_Txt.text == "" || mobile_Txt.text!.count > 10 || self.userName_Txt.text == "" ||  self.userLastName_Txt.text == "" {
            
            self.saveButton.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.saveButton.isUserInteractionEnabled = false
            
        } else {
            
            self.saveButton.setBackgroundImage(UIImage(named: "Rectangle -3"), for: .normal)
            self.saveButton.isUserInteractionEnabled = true
            
        }
    }
    
    
    @IBAction func saveChangesBtnAction(_ sender: UIButton) {
        
        
        if isFrom == "AllUser" {
            
            self.userDetailsUpdateHandlerMethod()
            
        }else{
            
            self.addUserHandlerMethod()
            
        }
        
    }
    
    @IBAction func fitnessBtnAction(_ sender: UIButton) {
        
        self.saveButton.setBackgroundImage(UIImage(named: "Rectangle -3"), for: .normal)
        
        if sender.tag == 1 {
            
            self.beginnerButton.setTitleColor(UIColor.white, for: .normal)
            self.intermedButton.setTitleColor(UIColor.init(hexFromString: "1D5384"), for: .normal)
            self.advancedButton.setTitleColor(UIColor.init(hexFromString: "1D5384"), for: .normal)
            
            self.beginnerButton.setBackgroundImage(UIImage.init(named: "Rectangle -8"), for: .normal)
            self.intermedButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
            self.advancedButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
            
            self.fitnesssType = "Beginner"
            
        }else if sender.tag == 2 {
            
            self.fitnesssType = "Intermediate"
            self.intermedButton.setTitleColor(UIColor.white, for: .normal)
            self.beginnerButton.setTitleColor(UIColor.init(hexFromString: "1D5384"), for: .normal)
            self.advancedButton.setTitleColor(UIColor.init(hexFromString: "1D5384"), for: .normal)
            
            self.beginnerButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
            self.intermedButton.setBackgroundImage(UIImage.init(named: "Rectangle -8"), for: .normal)
            self.advancedButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
            
        }else{
            self.advancedButton.setTitleColor(UIColor.white, for: .normal)
            self.beginnerButton.setTitleColor(UIColor.init(hexFromString: "1D5384"), for: .normal)
            self.intermedButton.setTitleColor(UIColor.init(hexFromString: "1D5384"), for: .normal)
            
            self.beginnerButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
            self.intermedButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
            self.advancedButton.setBackgroundImage(UIImage.init(named: "Rectangle -8"), for: .normal)
            
            self.fitnesssType = "Advanced"
            
        }
        
    }
    
    @IBAction func genderBtnAction(_ sender: UIButton) {
        
        self.saveButton.setBackgroundImage(UIImage(named: "Rectangle -3"), for: .normal)

        if sender.tag == 1 {
            
            self.maleButton.setBackgroundImage(UIImage.init(named: "Rectangle -8"), for: .normal)
            self.femaleButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
            self.maleButton.setTitleColor(UIColor.white, for: .normal)
            self.femaleButton.setTitleColor(UIColor.init(hexFromString: "1D5384"), for: .normal)
            self.genderType = "Male"
            
        }else  {
            
            self.femaleButton.setTitleColor(UIColor.white, for: .normal)
            self.maleButton.setTitleColor(UIColor.init(hexFromString: "1D5384"), for: .normal)
            self.maleButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
            self.femaleButton.setBackgroundImage(UIImage.init(named: "Rectangle -8"), for: .normal)
            
            self.genderType = "Female"
            
        }
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        //if let navController = self.navigationController {
            
        self.navigationController?.popViewController(animated: true)

        //}
        
    }
    
    @IBAction func subscriptionBtnAction(_ sender: UIButton) {
        
        self.saveButton.setBackgroundImage(UIImage(named: "Rectangle -3"), for: .normal)
        
        if sender.tag == 4 {
            
            self.firstButton.setTitleColor(UIColor.white, for: .normal)
            self.secondButton.setTitleColor(UIColor.init(hexFromString: "1D5384"), for: .normal)
            self.thirdButton.setTitleColor(UIColor.init(hexFromString: "1D5384"), for: .normal)
            
            self.firstButton.setBackgroundImage(UIImage.init(named: "Rectangle -8"), for: .normal)
            self.secondButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
            self.thirdButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
            self.subscriptionType = "Upper body"
            
        }else if sender.tag == 5 {
            
            self.secondButton.setTitleColor(UIColor.white, for: .normal)
            self.firstButton.setTitleColor(UIColor.init(hexFromString: "1D5384"), for: .normal)
            self.thirdButton.setTitleColor(UIColor.init(hexFromString: "1D5384"), for: .normal)
            
            self.secondButton.setBackgroundImage(UIImage.init(named: "Rectangle -8"), for: .normal)
            self.firstButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
            self.thirdButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
            self.subscriptionType = "Abs"
            
        }else{
            
            self.thirdButton.setTitleColor(UIColor.white, for: .normal)
            self.firstButton.setTitleColor(UIColor.init(hexFromString: "1D5384"), for: .normal)
            self.secondButton.setTitleColor(UIColor.init(hexFromString: "1D5384"), for: .normal)
            
            self.firstButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
            self.secondButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
            self.thirdButton.setBackgroundImage(UIImage.init(named: "Rectangle -8"), for: .normal)
            self.subscriptionType = "Lower body"
            
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
    
    
    func addUserHandlerMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: " Please wait")

        let trainerID = UserDefaults.standard.object(forKey: "trainerId") as! Int
        
        let params = ["subscriberFirstName" :"\(userName_Txt.text!)","subscriberLastName":"\(self.userLastName_Txt.text!)","subscriberPrimaryMob":"\(self.mobile_Txt.text!)","subscriberEmail":"\(self.email_Txt.text!)","trainerId":"\(trainerID)", "subscriberGender": self.genderType, "subscriberFitnessLevel":"\(self.fitnesssType)", "subscriberSubscriptionPlan":"\(self.subscriptionType)"] as [String : Any]
       
            
           let urlString = TrinerUrlPath.sharedInstance.getUrlPath("dao/onboarding/register")
            
        print(" register url string ==\(urlString)")
        print(" register params ==\(params)")
        
        TrinerAPI.sharedInstance.TrinerService_post_with_header(paramsDict: params as NSDictionary, urlPath:urlString,onCompletion: {
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
            
//            if response == nil
//            {
//                Services.sharedInstance.dissMissLoader()
//                return
//            }else
//            {
                Services.sharedInstance.dissMissLoader()

                let dict = dict_responce(dict: response)
                
                if dict.value(forKey: "status") as? Int == 500 {
                    
                    
                }else{
                    
                    
                    AlertSingletanClass.sharedInstance.validationAlert(title: "Success", message: "Client added successfully.", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                        
                        self.email_Txt.text = ""
                        self.userName_Txt.text = ""
                        self.userLastName_Txt.text = ""
                        self.mobile_Txt.text = ""
                        
                        self.firstButton.setTitleColor(UIColor.init(named: "1D5384"), for: .normal)
                        self.secondButton.setTitleColor(UIColor.init(named: "1D5384"), for: .normal)
                        self.thirdButton.setTitleColor(UIColor.init(named: "1D5384"), for: .normal)
                        self.maleButton.setTitleColor(UIColor.init(named: "1D5384"), for: .normal)
                        self.femaleButton.setTitleColor(UIColor.init(named: "1D5384"), for: .normal)
                        self.beginnerButton.setTitleColor(UIColor.init(named: "1D5384"), for: .normal)
                        self.intermedButton.setTitleColor(UIColor.init(named: "1D5384"), for: .normal)
                        self.advancedButton.setTitleColor(UIColor.init(named: "1D5384"), for: .normal)

                        self.firstButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
                        self.secondButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
                        self.thirdButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
                        self.maleButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
                        self.femaleButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
                        self.beginnerButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
                        self.intermedButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
                        self.advancedButton.setBackgroundImage(UIImage.init(named: "Rectangle -10"), for: .normal)
                    })
                
                }
        }
        )
    }
    
    
    
    func trainerSendCredentialsHandlerMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: " Please wait")
        
        let params = ["name" :"\(userName_Txt.text!)","mobileNumber":"\(self.mobile_Txt.text!)","emailId":"\(self.email_Txt.text!)","subject":"Welcome"]
        
        
        let urlString = TrinerUrlPath.sharedInstance.getUrlPath("subemail/sendcredentials")
        print("sendcredentials url ==\(urlString)")
        TrinerAPI.sharedInstance.TrinerService_post_with_header(paramsDict: params as NSDictionary, urlPath:urlString,onCompletion: {
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
                
                //self.saveButton.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
                
                if dict.value(forKey: "status") as? String == "true"
                {
                    
                    DispatchQueue.main.async {
                        self.addUserHandlerMethod()
                    }
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

    
    func userDetailsUpdateHandlerMethod() {
            
        Services.sharedInstance.customLoader(view: self.view, message: " Please wait")

            let trainerID = UserDefaults.standard.object(forKey: "trainerId") as! Int
            
            let params = ["subscriberFirstName" :"\(userName_Txt.text!)","subscriberLastName":"\(self.userLastName_Txt.text!)","subscriberPrimaryMob":"\(self.mobile_Txt.text!)","subscriberEmail":"\(self.email_Txt.text!)","trainerId":"\(trainerID)", "subscriberGender": self.genderType, "subscriberFitnessLevel":"\(self.fitnesssType)", "subscriberSubscriptionPlan":"\(self.subscriptionType)"] as [String : Any]
                
        let urlString = TrinerUrlPath.sharedInstance.getUrlPath("dao/onboarding/update")
                
            print(" update url string ==\(urlString)")
            print(" update params ==\(params)")
            
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
                
    //            if response == nil
    //            {
    //                Services.sharedInstance.dissMissLoader()
    //                return
    //            }else
    //            {
                    Services.sharedInstance.dissMissLoader()

                    let dict = dict_responce(dict: response)
                    
                    if dict.value(forKey: "status") as? Int == 500 {
                        
                        
                    }else{
                        
                      //  self.showToast(message: "You have successfully update your user details.")
                        
                        AlertSingletanClass.sharedInstance.validationAlert(title: "Success", message: "You have successfully update your user details.", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                            
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
            }
            )
        }
 
    
    func downloadingImageFromServer(id:String){
        
        if let url = URL(string: "https://beapis.dieatto.com:8090/profilepic/download/SUB/\(id)") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread
                    
                    // It is the best way to manage nil issue.
                    if data.count > 0 {
                        self.user_Img.image = UIImage(data: data)
                        //self.userShortName_Lbl.isHidden = true
                    }else{
                        self.user_Img.image = UIImage(named: "icon-addNewUser")
                    }
                }
            }
            
            task.resume()
        }
    }
}
