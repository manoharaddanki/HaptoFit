//
//  MyGoalTwoVC.swift
//  Dieatto
//
//  Created by Developer Dev on 07/06/20.
//  Copyright © 2020 Developer Dev. All rights reserved.
//

import UIKit
import AAPickerView

class MyGoalTwoVC: UIViewController {

    @IBOutlet var shadowView: UIView!

    @IBOutlet weak var speedPicker: AAPickerView!
    @IBOutlet weak var timePicker: AAPickerView!

    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var title_Lbl: UILabel!
    
    @IBOutlet weak var continue_Btn: UIButton!

    
    var speedStr = String()
    var timeStr = String()
    var selectGoal: Int!

    let kmData:[String] = ["1","2","3","4","5","6"]

    let minData:[String] = ["2","4","6","8","10","12"]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        configPicker()

        // Do any additional setup after loading the view.
      shadowView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if selectGoal == 1 {
            
            self.title_Lbl.text = "Weight Loss"
            self.imgView.image = UIImage.init(named: "weightloss-icon")
            
        }else if selectGoal == 2 {
            
            self.title_Lbl.text = "Weight Gain"
            self.imgView.image = UIImage.init(named: "weightgain-icon")

            
        }else if selectGoal == 3 {
            
            self.title_Lbl.text = "Muscle Growth"
            self.imgView.image = UIImage.init(named: "muscular-icon")

            
        }else{
            
            self.title_Lbl.text = "Fitness"
            self.imgView.image = UIImage.init(named: "fitness-icon")

        }
        
    }

    @IBAction func continueBtnAction(_ sender: UIButton) {
        
        
        if  self.speedStr == "" {

            self.showToast(message: "Please select Kgs")

        }else if self.timeStr == "" {
            
            self.showToast(message: "Please select No of weeks")

            
        }else{

            
//            SubPersonalDict.personalDict["bmrSubWeightTrainlevel"] = self.speedStr
//            SubPersonalDict.personalDict["bmrSubWeightTrainMin"] = self.timeStr
            SubPersonalDict.personalDict["subDietGoal"] = self.speedStr
            SubPersonalDict.personalDict["subDietDuration"] = self.timeStr

            postAllPersonalDataHandlerMethod()
        }
        
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }

    func configPicker() {
       
        speedPicker.pickerType = .string(data: self.kmData)
        speedPicker.heightForRow = 40
        speedPicker.pickerRow.font = UIFont(name: "American Typewriter", size: 30)
        speedPicker.toolbar.barTintColor = .darkGray
        speedPicker.toolbar.tintColor = .black
        
        speedPicker.valueDidSelected = { (index) in
            
            self.speedStr = (self.kmData[index as! Int])
            self.speedPicker.text = "\(self.speedStr)(kgs)"

        }

        self.timePicker.pickerType = .string(data: minData)
        timePicker.heightForRow = 40
        timePicker.pickerRow.font = UIFont(name: "American Typewriter", size: 30)
        
        timePicker.toolbar.barTintColor = .darkGray
        timePicker.toolbar.tintColor = .black
        
        timePicker.valueDidSelected = { (index) in
            
        self.timeStr = self.minData[index as! Int]
            
            self.timePicker.text = "\(self.timeStr)(weeks)"
        }
        
    }
    
    func postAllPersonalDataHandlerMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")

        let params = SubPersonalDict.personalDict
        
        print("final personal data is===\(params)")
        
        let urlString = "https://beapis.dieatto.com:8090/dao/subprofile/updateSubDietProfile"
        
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
                
                
            }else{
                
                UserDefaults.standard.set(true, forKey: "personalInfo")
                let objVC = self.storyboard?.instantiateViewController(withIdentifier: "UserMainTabVC") as! UserMainTabVC
                self.navigationController?.pushViewController(objVC, animated: true)

            }
        }
        )
    }
}
