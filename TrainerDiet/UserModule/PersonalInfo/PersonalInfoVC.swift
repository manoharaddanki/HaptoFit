//
//  PersonalInfoVC.swift
//  Dieatto
//
//  Created by Developer Dev on 19/10/19.
//  Copyright © 2019 Developer Dev. All rights reserved.
//

import UIKit
import AAPickerView

struct SubPersonalDict {
    
    static var personalDict = NSMutableDictionary()
}

class PersonalInfoVC: UIViewController {

    @IBOutlet var shadowView: UIView!
    @IBOutlet var signInScrollView: UIScrollView!
    
    @IBOutlet weak var weightPicker: AAPickerView!
    @IBOutlet weak var heightPicker: AAPickerView!

    @IBOutlet weak var dob_TxtDatePicker: UITextField!
    @IBOutlet weak var occupation_Txt: UITextField!
    @IBOutlet weak var continue_Btn: UIButton!

    @IBOutlet weak var backBtn: UIButton!

    let datePicker = UIDatePicker()

    var weightStr = String()
    var heightStr = String()
    var dobStr = String()

   var userPersonalInfoStatus = UserDefaults.standard.object(forKey: "personalInfo") as? Bool ?? false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        showDatePicker()
        configPicker()
        // Do any additional setup after loading the view.
       shadowView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
         self.hideKeyboardWhenTappedAround()

    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        self.backBtn.isUserInteractionEnabled = false
        self.backBtn.isHidden = true
        
        let mobileNum = UserDefaults.standard.object(forKey: "subMobile") as? Int
        let firstName = UserDefaults.standard.object(forKey: "firstName") as? String
        let lastName = UserDefaults.standard.object(forKey: "lastName") as? String
        let subId = UserDefaults.standard.object(forKey: "subId") as? Int
        let fitnessLevel = UserDefaults.standard.object(forKey: "subFitnessLevel") as? String
        let plan = UserDefaults.standard.object(forKey: "subSubscriptionPlan") as? String
        let gender = UserDefaults.standard.object(forKey: "gender") as? String
        
        SubPersonalDict.personalDict["subId"] = subId
        SubPersonalDict.personalDict["subLastName"] = lastName
        SubPersonalDict.personalDict["subFirstName"] = firstName
        SubPersonalDict.personalDict["subMobPrimary"] = mobileNum
        SubPersonalDict.personalDict["subMobSecondary"] = mobileNum
        SubPersonalDict.personalDict["subGender"] = gender
        SubPersonalDict.personalDict["subFitnessLevel"] = fitnessLevel
        SubPersonalDict.personalDict["subSubscriptionPlan"] = plan
       
    }
    @IBAction func continueBtnAction(_ sender: UIButton) {
        
        
        if dob_TxtDatePicker.text == "" {
            
            self.showToast(message: "Please select date of birth")
            
        }else if  self.heightStr == "" {
            
            self.showToast(message: "Please select height")
            
        }
        else if  self.weightStr == "" {
            
            self.showToast(message: "Please select weight")

        }else if  self.occupation_Txt.text == "" {
            
            self.showToast(message: "Please enter occupation type")
            
        }
        else if occupation_Txt.text?.count ?? 0 < 4
        {
            showToast(message: "Occupation contains atleast 4 Char")
        }

        else{

            SubPersonalDict.personalDict["subDateOfBirth"] = self.dobStr
            SubPersonalDict.personalDict["subOccupation"] = occupation_Txt.text
            SubPersonalDict.personalDict["subWeight"] = self.weightStr
            SubPersonalDict.personalDict["subHeight"] = self.heightStr
//            SubPersonalDict.personalDict["bmrSubWeight"] = self.weightStr
//            SubPersonalDict.personalDict["bmrSubHeight"] = self.heightStr
//            SubPersonalDict.personalDict["bmrCalcDate"] = result
            
            let objVC = storyboard?.instantiateViewController(withIdentifier: "GoalsVC") as! GoalsVC
            
            self.navigationController?.pushViewController(objVC, animated: true)
            
        }
        
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)

    }
    
    func configPicker() {

        let heightData:[String] = heigthArr

        let weightData:[String] = WeigthArr

        heightPicker.pickerType = .string(data: heightData)
        heightPicker.heightForRow = 40
        heightPicker.pickerRow.font = UIFont(name: "American Typewriter", size: 30)
        
        heightPicker.toolbar.barTintColor = .darkGray
        heightPicker.toolbar.tintColor = .black
        
        heightPicker.valueDidSelected = { (index) in
            
            let heightVal = (heightData[index as! Int])
            self.heightStr = heightVal
            self.heightPicker.text = "\(heightVal) cms"
            print("selectedString ", self.heightStr)
               
            self.continue_Btn.setBackgroundImage(UIImage(named: "Rectangle -3"), for: .normal)

        }

        weightPicker.pickerType = .string(data: weightData)
        weightPicker.heightForRow = 40
        weightPicker.pickerRow.font = UIFont(name: "American Typewriter", size: 30)
        
        weightPicker.toolbar.barTintColor = .darkGray
        weightPicker.toolbar.tintColor = .black
        
        weightPicker.valueDidSelected = { (index) in
            
            self.weightStr = weightData[index as! Int]
            self.weightPicker.text = "\(self.weightStr) kgs"
            print("selectedString ", weightData[index as! Int])
             
            self.continue_Btn.setBackgroundImage(UIImage(named: "Rectangle -3"), for: .normal)

        }

    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        dob_TxtDatePicker.inputAccessoryView = toolbar
        dob_TxtDatePicker.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.dobStr = formatter.string(from: datePicker.date)
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "dd-MM-yyyy"
        
        if #available(iOS 13.4, *) {
            
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        dob_TxtDatePicker.text = formatter1.string(from: datePicker.date)

        self.view.endEditing(true)
        self.continue_Btn.setBackgroundImage(UIImage(named: "Rectangle -3"), for: .normal)

    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }

}

