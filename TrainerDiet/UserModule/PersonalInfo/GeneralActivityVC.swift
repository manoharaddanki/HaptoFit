//
//  GeneralActivityVC.swift
//  Dieatto
//
//  Created by Developer Dev on 19/10/19.
//  Copyright © 2019 Developer Dev. All rights reserved.
//

import UIKit
import AAPickerView

class GeneralActivityVC: UIViewController {

    @IBOutlet var shadowView: UIView!

    @IBOutlet weak var treadMillSpeedPicker: AAPickerView!
    @IBOutlet weak var treadMillTimePicker: AAPickerView!

    @IBOutlet weak var ellipticalSpeedPicker: AAPickerView!
    @IBOutlet weak var ellipticalTimePicker: AAPickerView!
    
    @IBOutlet weak var cyclingSpeedPicker: AAPickerView!
    @IBOutlet weak var cyclingTimePicker: AAPickerView!
    
    @IBOutlet weak var swimmingSpeedPicker: AAPickerView!
    @IBOutlet weak var swimmingTimePicker: AAPickerView!
    
    @IBOutlet weak var treammill_Btn: UIButton!
    @IBOutlet weak var elliptical_Btn: UIButton!
    @IBOutlet weak var cycling_Btn: UIButton!
    @IBOutlet weak var swimmiing_Btn: UIButton!
    
    @IBOutlet weak var continue_Btn: UIButton!

    
    var treadmillSpeedStr = String()
    var treadmillTimeStr = String()
    
    var cyclingSpeedStr = String()
    var cyclingTimeStr = String()
    
    var ellipaticalSpeedStr = String()
    var ellipaticalTimeStr = String()
    
    var swimmingSpeedStr = String()
    var swimmingTimeStr = String()
    
    var treadmillSlectStatus : Bool = false
    var ellipaticalSelectStatus : Bool = false
    var cyclingSelectStatus : Bool = false
    var swimmingSelectStatus : Bool = false


    let kmData:[String] = ["01","02","03","04","05","06","07","08","09","10"]

    let minData:[String] = ["10","20","30","40","50","60","70","80","90","100"]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        configPicker()

        // Do any additional setup after loading the view.
      shadowView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
        
    }
    
    
    
    @IBAction func treadmillBtnAction(_ sender: UIButton) {
        
        if(sender.isSelected == true) {
            
            //check_btn.backgroundColor = UIColor.green
            sender.isSelected = false
            self.treadmillSlectStatus = false
        }
        else
        {
            treammill_Btn.backgroundColor = UIColor.clear
            sender.isSelected = true
            treadmillSlectStatus = true

        }
    }
    
    @IBAction func ellipticalBtnAction(_ sender: UIButton) {
        
        if(sender.isSelected == true) {
            
            //check_btn.backgroundColor = UIColor.green
            sender.isSelected = false
            ellipaticalSelectStatus = false

        }
        else
        {
            elliptical_Btn.backgroundColor = UIColor.clear
            sender.isSelected = true
            ellipaticalSelectStatus = true

        }
    }
    
    @IBAction func cyclingBtnAction(_ sender: UIButton) {
        
        if(sender.isSelected == true) {
            
            //check_btn.backgroundColor = UIColor.green
            sender.isSelected = false
            cyclingSelectStatus = false

        }
        else
        {
            cycling_Btn.backgroundColor = UIColor.clear
            sender.isSelected = true
            cyclingSelectStatus = true

        }
    }
    
    @IBAction func swimmingBtnAction(_ sender: UIButton) {
        
        if(sender.isSelected == true) {
            
            //check_btn.backgroundColor = UIColor.green
            sender.isSelected = false
            swimmingSelectStatus = false

        }
        else
        {
            swimmiing_Btn.backgroundColor = UIColor.clear
            sender.isSelected = true
            swimmingSelectStatus = true

        }
    }

    @IBAction func continueBtnAction(_ sender: UIButton) {
        
        
//        if (self.treadmillSlectStatus == false && self.treadmillTimeStr == "" && self.treadmillSpeedStr == "" ) || (self.ellipaticalSelectStatus == false && self.ellipaticalTimeStr == "" && self.ellipaticalSpeedStr == "" ) || (self.cyclingSelectStatus == false && self.cyclingTimeStr == "" && self.cyclingSpeedStr == "" ) || (self.swimmingSelectStatus == false && self.swimmingTimeStr == "" && self.swimmingSpeedStr == "" ) {
//
//            self.showToast(message: "Please select at least one")
//
//        }else{
            
            SubPersonalDict.personalDict["bmrSubCyclingSpeed"] = self.cyclingSpeedStr
            SubPersonalDict.personalDict["bmrSubCyclingMin"] = self.cyclingTimeStr

            SubPersonalDict.personalDict["bmrSubSwimMin"] = self.swimmingTimeStr
            SubPersonalDict.personalDict["bmrSubSwimLevel"] = self.swimmingSpeedStr

            SubPersonalDict.personalDict["bmrSubEclipticSpeed"] = self.ellipaticalTimeStr
            SubPersonalDict.personalDict["bmrSubEclipticMin"] = self.ellipaticalSpeedStr

            SubPersonalDict.personalDict["bmrSubTredMillSpeed"] = self.treadmillSpeedStr
            SubPersonalDict.personalDict["bmrSubTredMillMin"] = self.treadmillTimeStr

            
            let objVC = storyboard?.instantiateViewController(withIdentifier: "PhysicalActivityVC") as! PhysicalActivityVC
            
            self.navigationController?.pushViewController(objVC, animated: true)
       // }
        
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }

    func configPicker() {
       
        treadMillSpeedPicker.pickerType = .string(data: self.kmData)
        treadMillSpeedPicker.heightForRow = 40
        treadMillSpeedPicker.pickerRow.font = UIFont(name: "American Typewriter", size: 30)
        treadMillSpeedPicker.toolbar.barTintColor = .darkGray
        treadMillSpeedPicker.toolbar.tintColor = .black
        
        treadMillSpeedPicker.valueDidSelected = { (index) in
            
            let kmVal = (self.kmData[index as! Int])
            self.treadmillSpeedStr = kmVal
                        
        }

        self.treadMillTimePicker.pickerType = .string(data: minData)
        treadMillTimePicker.heightForRow = 40
        treadMillTimePicker.pickerRow.font = UIFont(name: "American Typewriter", size: 30)
        
        treadMillTimePicker.toolbar.barTintColor = .darkGray
        treadMillTimePicker.toolbar.tintColor = .black
        
        treadMillTimePicker.valueDidSelected = { (index) in
            
        self.treadmillTimeStr = self.minData[index as! Int]
        }
        
        self.ellipticalSpeedPicker.pickerType = .string(data: self.kmData)
        ellipticalSpeedPicker.heightForRow = 40
        ellipticalSpeedPicker.pickerRow.font = UIFont(name: "American Typewriter", size: 30)
        ellipticalSpeedPicker.toolbar.barTintColor = .darkGray
        ellipticalSpeedPicker.toolbar.tintColor = .black
        
        ellipticalSpeedPicker.valueDidSelected = { (index) in
            
            let kmVal = (self.kmData[index as! Int])
            self.ellipaticalSpeedStr = kmVal
                        
        }

        self.ellipticalTimePicker.pickerType = .string(data: minData)
        ellipticalTimePicker.heightForRow = 40
        ellipticalTimePicker.pickerRow.font = UIFont(name: "American Typewriter", size: 30)
        
        ellipticalTimePicker.toolbar.barTintColor = .darkGray
        ellipticalTimePicker.toolbar.tintColor = .black
        
        ellipticalTimePicker.valueDidSelected = { (index) in
            
        self.ellipaticalTimeStr = self.minData[index as! Int]
        }

        self.cyclingSpeedPicker.pickerType = .string(data: self.kmData)
        cyclingSpeedPicker.heightForRow = 40
        cyclingSpeedPicker.pickerRow.font = UIFont(name: "American Typewriter", size: 30)
        cyclingSpeedPicker.toolbar.barTintColor = .darkGray
        cyclingSpeedPicker.toolbar.tintColor = .black
        
        cyclingSpeedPicker.valueDidSelected = { (index) in
            
            let kmVal = (self.kmData[index as! Int])
            self.cyclingSpeedStr = kmVal
                        
        }

        self.cyclingTimePicker.pickerType = .string(data: minData)
        cyclingTimePicker.heightForRow = 40
        cyclingTimePicker.pickerRow.font = UIFont(name: "American Typewriter", size: 30)
        
        cyclingTimePicker.toolbar.barTintColor = .darkGray
        cyclingTimePicker.toolbar.tintColor = .black
        
        cyclingTimePicker.valueDidSelected = { (index) in
            
        self.cyclingTimeStr = self.minData[index as! Int]
        }

        self.swimmingSpeedPicker.pickerType = .string(data: self.kmData)
        swimmingSpeedPicker.heightForRow = 40
        swimmingSpeedPicker.pickerRow.font = UIFont(name: "American Typewriter", size: 30)
        swimmingSpeedPicker.toolbar.barTintColor = .darkGray
        swimmingSpeedPicker.toolbar.tintColor = .black
        
        swimmingSpeedPicker.valueDidSelected = { (index) in
            
            let kmVal = (self.kmData[index as! Int])
            self.swimmingSpeedStr = kmVal
                        
        }

        self.swimmingTimePicker.pickerType = .string(data: minData)
        swimmingTimePicker.heightForRow = 40
        swimmingTimePicker.pickerRow.font = UIFont(name: "American Typewriter", size: 30)
        
        swimmingTimePicker.toolbar.barTintColor = .darkGray
        swimmingTimePicker.toolbar.tintColor = .black
        
        swimmingTimePicker.valueDidSelected = { (index) in
            
        self.swimmingTimeStr = self.minData[index as! Int]
        }


    }
}
