//
//  MyGoalTabVC.swift
//  Dieatto
//
//  Created by Developer Dev on 11/06/20.
//  Copyright © 2020 Developer Dev. All rights reserved.
//

import UIKit
import Alamofire
import GradientSlider

class MyGoalTabVC: UIViewController {
    
    
    @IBOutlet var adheranceStatusView: UIView!
    
    @IBOutlet weak var sleepProgressView: CustomColorSlider!
    @IBOutlet weak var stessProgressView: CustomColorSlider!
    @IBOutlet weak var wellnesspProgressView: CustomColorSlider!

    
    @IBOutlet var headerView: UIView!
    @IBOutlet var userName_Lbl: UILabel!

    @IBOutlet var myGoalView: UIView!
    @IBOutlet var myGoalSubView: UIView!
    
    @IBOutlet var slepView: UIView!
    @IBOutlet var sleepSubView: UIView!
    
    @IBOutlet var stressView: UIView!
    @IBOutlet var stressSubView: UIView!
    
    @IBOutlet var wellnessView: UIView!
    @IBOutlet var wellnessSubView: UIView!
    
    @IBOutlet weak var workoutPlan_Switch: UISwitch!
    @IBOutlet weak var nutritionPlan_Switch: UISwitch!
    
    @IBOutlet weak var wellnessProgress: UIProgressView!
    @IBOutlet weak var stressProgress: UIProgressView!
    @IBOutlet weak var sleepProgress: UIProgressView!
    
    
    @IBOutlet var slider1: UISlider!
    @IBOutlet weak var slider2: UISlider!
    @IBOutlet weak var slider3: UISlider!
  
    
    @IBOutlet weak var doneBtn: UIButton!
    
    
    @IBOutlet var sleepScore_Lbl: UILabel!
    @IBOutlet var stressScore_Lbl: UILabel!
    @IBOutlet var wellnessScore_Lbl: UILabel!
    
    @IBOutlet var sleepCurrentScore_Lbl: UILabel!
    @IBOutlet var stressCurrentScore_Lbl: UILabel!
    @IBOutlet var wellnessCurrentScore_Lbl: UILabel!
    
    
    var netritionPlanRating = String()
    
    var workoutPlanStatus = "N"
    var nutritionPlanStatus = "N"
    var currentDatePost = String()
    var todaysadherenceDate = String()
    
    var workoutplanRating = Int()
    var totalSleepHours = Int()

    let date = Date()
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "yyyy-MM-dd"
        currentDatePost = formatter.string(from: date)
        
        

        headerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 2.0)

        myGoalView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
        myGoalSubView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
        slepView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
        sleepSubView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
        stressView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
        stressSubView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
        wellnessView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
        wellnessSubView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
        
        
        slider1.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
        slider2.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
        slider3.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.doneBtn.isHidden = true
        self.adheranceStatusView.isHidden = true

        getAderenceGetCall()
        
        let wellness = UserDefaults.standard.object(forKey: "wellnessScore") as? Int ?? 0
        let stress = UserDefaults.standard.object(forKey: "stressScore") as? Int ?? 0
        let sleep = UserDefaults.standard.object(forKey: "sleepScore") as? Int ?? 0
        
        if let userName = UserDefaults.standard.object(forKey: "firstName") as? String {
                   
                   self.userName_Lbl.text = "Hi, \(userName)"
               }else{
                   
                   self.userName_Lbl.text = "Hi"

               }
        
        self.sleepScore_Lbl.text = "\(sleep)"
        self.wellnessScore_Lbl.text = "\(wellness)"
        self.stressScore_Lbl.text = "\(stress)"
        self.sleepCurrentScore_Lbl.text = "\(sleep) /\(100)"
        self.wellnessCurrentScore_Lbl.text = "\(wellness) /\(100)"
        self.stressCurrentScore_Lbl.text = "\(stress) /\(100)"
        
        let wellnessProgressVal = ((Double(wellness) / Double(100)))
        let streeProgressVal = ((Double(stress) / Double(100)))
        let sleepProgressVal = ((Double(sleep) / Double(100)))

        sleepProgressView.defaultValue = CGFloat(sleepProgressVal)
        sleepProgressView.isUserInteractionEnabled = false

        stessProgressView.defaultValue = (1 - CGFloat(streeProgressVal))
        stessProgressView.isUserInteractionEnabled = false

        
        wellnesspProgressView.defaultValue = CGFloat(wellnessProgressVal)
        wellnesspProgressView.isUserInteractionEnabled = false

        
//        let wellnessGradientImage = UIImage.gradientImage(with: wellnessProgress.frame,
//                                                  colors: [UIColor.red.cgColor, UIColor.orange.cgColor, UIColor.green.cgColor],
//                                                  locations: nil)
//        wellnessProgress.progressImage = wellnessGradientImage!
//        wellnessProgress.setProgress(Float(wellnessProgressVal), animated: true)
//
//        let stressGradientImage = UIImage.gradientImage(with: stressProgress.frame,
//                                                  colors: [UIColor.green.cgColor, UIColor.orange.cgColor, UIColor.red.cgColor],
//                                                  locations: nil)
//       // stressProgress.transform = CGAffineTransform(rotationAngle: CGFloat(DegreesToRadians(d: 180)));
//        stressProgress.progressImage = stressGradientImage!
//        stressProgress.setProgress(Float(streeProgressVal), animated: true)
//
//        let sleepGradientImage = UIImage.gradientImage(with: sleepProgress.frame,
//                                                  colors: [UIColor.red.cgColor, UIColor.orange.cgColor,UIColor.green.cgColor],
//                                                  locations: nil)
//        sleepProgress.progressImage = sleepGradientImage!
//        sleepProgress.setProgress(Float(sleepProgressVal), animated: true)
        
      
    }
    
    @IBAction func slider1BtnAction(_ sender: UISlider) {
        
        let slideVal = Int(slider1.value)
        self.workoutplanRating = slideVal
        //self.doneBtn.isHidden = false
        
    }
    @IBAction func slider2BtnAction(_ sender: UISlider) {
        
        let slideVal = Int(slider2.value)
        
        self.netritionPlanRating = String(slideVal)
        self.doneBtn.isHidden = false
        
    }
    @IBAction func slider3BtnAction(_ sender: UISlider) {
        
        let slideVal = Int(slider3.value)
        self.totalSleepHours = slideVal
        self.doneBtn.isHidden = false
        
    }

    @IBAction func adheranceStatusCloseTapped(_ sender: UIButton) {
        
       
        self.adheranceStatusView.isHidden = true
        
        
    }
    
    @IBAction func workoutPlan_SwitchBtnAction(_ sender: UISwitch) {
        
        if(sender.isSelected == true) {
            
            sender.isSelected = false
            // self.workoutPlan_Switch.isOn = true
            self.workoutPlanStatus = "N"
            self.doneBtn.isHidden = true
            
            
        }else{
            
            sender.isSelected = true
            // self.workoutPlan_Switch.isOn = false
            self.workoutPlanStatus = "Y"
            self.doneBtn.isHidden = false
            
        }
        
    }
    
    
    @IBAction func doneBtnAction(_ sender: UIButton) {
        
        
        if self.workoutPlan_Switch.isOn == false {
            
            self.showToast(message: "Please Enable Workout Plan")
            
        }
        else if self.workoutplanRating == 0 {
            
            self.showToast(message: "Please Give Workout Plan Rating")

        }else if self.totalSleepHours == 0 {
            
            self.showToast(message: "Please Give Total Hours Rating")

        }else{
            
            self.subPostHandlerMethod()

        }
    }
    
    @IBAction func nutritionPlan_SwitchBtnAction(_ sender: UISwitch) {
        
        
        if(sender.isSelected == true) {
            
            sender.isSelected = false
            //self.nutritionPlan_Switch.isOn = true
            self.nutritionPlanStatus = "Y"
            //self.doneBtn.isHidden = false
            
        }else{
            
            sender.isSelected = true
            //self.nutritionPlan_Switch.isOn = false
            self.nutritionPlanStatus = "N"
            
            //self.doneBtn.isHidden = true
            
        }
        
    }
    
    func DegreesToRadians (d: Double) -> Double {
        
        return ((d) * .pi / 180.0)
    }
    
    func adherenceOneDayFlagMethod(){
       
        if todaysadherenceDate != "" {
            
            let start = formatter.date(from: todaysadherenceDate)!
            let end = formatter.date(from: self.currentDatePost)!
            let diff = Date.daysBetween(start: start, end: end)

            if diff == 0 {
                
               self.workoutPlan_Switch.isOn = true
               self.slider1.isUserInteractionEnabled = false
               self.slider3.isUserInteractionEnabled = false
               self.workoutPlan_Switch.isUserInteractionEnabled = false
               self.doneBtn.isHidden = true
                self.slider1.value = Float(self.workoutplanRating)
                self.slider3.value = Float(self.totalSleepHours)
            }else{
                
                self.workoutPlan_Switch.isOn = false
                self.slider1.isUserInteractionEnabled = true
                self.slider3.isUserInteractionEnabled = true
                self.workoutPlan_Switch.isUserInteractionEnabled = true
                self.slider1.value = 0
                self.slider3.value = 0

            }
            
        }else{
            
            self.slider1.value = 0
            self.slider3.value = 0
            self.workoutPlan_Switch.isOn = false
            self.slider1.isUserInteractionEnabled = true
            self.slider3.isUserInteractionEnabled = true
            self.workoutPlan_Switch.isUserInteractionEnabled = true

        }
    }
    func subPostHandlerMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")

        var subID = Int()
        
        if let subId = UserDefaults.standard.object(forKey: "subId") as? Int {
            
            subID = subId
        }else{
            
            subID = 0
            
        }
        
        let params = ["subId": "\(subID)" , "workoutplanFollow": workoutPlanStatus, "workoutplanRating": workoutplanRating, "nutritionplanFollow": nutritionPlanStatus, "nutritionplanRating": netritionPlanRating , "totalSleepHours": totalSleepHours, "dateAdhered": currentDatePost] as [String : Any]
        
        let urlString = "https://beapis.dieatto.com:8090/dao/subadherence/save"
        
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
            
            if response == nil
            {
                Services.sharedInstance.dissMissLoader()
                return
            }else
            {
                
                Services.sharedInstance.dissMissLoader()
             let dict = dict_responce(dict: response)
//                if let dateAdhered = dict.value(forKey: "dateAdhered") as? String{
//
//
//                }
                
                if dict.value(forKey: "status") as? Int == 500 {
                                              
                               
                                              
                }else{
                           

                    //self.showToast(message: "You have successfully update")
                    self.doneBtn.isHidden = true
                    self.adheranceStatusView.isHidden = false
                    
                }
                
                
//                if status_Check(dict: dict)
//                {
//                    AlertSingletanClass.sharedInstance.validationAlert(title: "Success", message: "You have successfully register your account. Please login.", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
//
//                        print("Register response is ==\(dict)")
//                    })
//
//
//                }else
//                {
//                    if let err_code = dict.value(forKeyPath: "error") as? String {
//
//                        AlertSingletanClass.sharedInstance.validationAlert(title: "Error", message: err_code, preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
//                        })
//                    }
//                }
            }
        }
        )
    }
    
    
    func getAderenceGetCall() {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")
        var urlString = String()
        
        var subID = Int()
        if let Id = UserDefaults.standard.object(forKey: "subId") as? Int {
            
            subID = Id
        }
        
        urlString = TrinerUrlPath.sharedInstance.getUrlPath("dao/subadherence/todaysadherence/\(subID)")
        
        print("score Api is ==>\(urlString)")
        
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
                    let dict = dict_responce(dict: response)
            
                    if let dateStr = dict.value(forKey: "dateAdhered") as? String {
                                
                        if dateStr != "" {

                            self.todaysadherenceDate = dateStr
                        }
                                       
                    }else{
                    
                        self.todaysadherenceDate = ""

                    }
            
            if let totalSleepHrs = dict.value(forKey: "totalSleepHours") as? Int {

                self.totalSleepHours = totalSleepHrs
            }
            
            if let workoutPlanRat = dict.value(forKey: "workoutplanRating") as? Int {
                
                self.workoutplanRating = workoutPlanRat

            }
            DispatchQueue.main.async(execute: {

                self.adherenceOneDayFlagMethod()
            })
               
        })
    }
    
}


fileprivate extension UIImage {
    static func gradientImage(with bounds: CGRect,
                              colors: [CGColor],
                              locations: [NSNumber]?) -> UIImage? {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        // This makes it horizontal
        gradientLayer.startPoint = CGPoint(x: 0.0,
                                           y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0,
                                         y: 0.5)
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
}

extension Decimal {
    func rounded(_ roundingMode: NSDecimalNumber.RoundingMode = .bankers) -> Decimal {
        var result = Decimal()
        var number = self
        NSDecimalRound(&result, &number, 0, roundingMode)
        return result
    }
    var whole: Decimal { self < 0 ? rounded(.up) : rounded(.down) }
    var fraction: Decimal { self - whole }
}

extension Date {

    func daysBetween(date: Date) -> Int {
        return Date.daysBetween(start: self, end: date)
    }

    static func daysBetween(start: Date, end: Date) -> Int {
        let calendar = Calendar.current

        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: start)
        let date2 = calendar.startOfDay(for: end)

        let a = calendar.dateComponents([.day], from: date1, to: date2)
        return a.value(for: .day)!
    }
}
