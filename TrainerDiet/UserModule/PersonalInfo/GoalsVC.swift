//
//  GoalsVC.swift
//  Dieatto
//
//  Created by Developer Dev on 07/06/20.
//  Copyright © 2020 Developer Dev. All rights reserved.
//

import UIKit

class GoalsVC: UIViewController {
    
    @IBOutlet var shadowView: UIView!
    
    @IBOutlet var weightLoss_Img: UIImageView!
    @IBOutlet var weightGain_Img: UIImageView!
    @IBOutlet var fitness_Img: UIImageView!
    @IBOutlet var muscleBtn_Img: UIImageView!
    
    @IBOutlet var continueBtn: UIButton!
    
    var goalSelectStr = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        shadowView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
    }
    
    @IBAction func goalSelectBtnAction(_ sender: UIButton) {
        
        if sender.tag == 1 {
            
            self.weightLoss_Img.image = UIImage(named: "weightloss-active")
            self.weightGain_Img.image = UIImage(named: "weightgain-inactive")
            self.fitness_Img.image = UIImage(named: "fitness-inactive")
            self.muscleBtn_Img.image = UIImage(named: "musclegrowth-inactive")
            self.goalSelectStr = 1
            
        }else if sender.tag == 2 {
            
            self.weightLoss_Img.image = UIImage(named: "weightloss-inactive")
            self.weightGain_Img.image = UIImage(named: "weightgain-active")
            self.fitness_Img.image = UIImage(named: "fitness-inactive")
            self.muscleBtn_Img.image = UIImage(named: "musclegrowth-inactive")
            self.goalSelectStr = 2
            
        }else if sender.tag == 3 {
            
            self.weightLoss_Img.image = UIImage(named: "weightloss-inactive")
            self.weightGain_Img.image = UIImage(named: "weightgain-inactive")
            self.fitness_Img.image = UIImage(named: "fitness-inactive")
            self.muscleBtn_Img.image = UIImage(named: "musclegrowth-active")
            self.goalSelectStr = 3
        }
        else{
            
            self.weightLoss_Img.image = UIImage(named: "weightloss-inactive")
            self.weightGain_Img.image = UIImage(named: "weightgain-inactive")
            self.fitness_Img.image = UIImage(named: "fitness-active")
            self.muscleBtn_Img.image = UIImage(named: "musclegrowth-inactive")
            self.goalSelectStr = 4
            
        }
        
    }
    
    @IBAction func continueBtnAction(_ sender: UIButton) {
        
        if self.goalSelectStr == 0 {
            
            showToast(message: "Please select your goal")
            
        }
        else if self.goalSelectStr == 3 || self.goalSelectStr == 4 {
                   
            self.postAllPersonalDataHandlerMethod()
            
        }else{
            
            SubPersonalDict.personalDict["subDietProfType"] = self.goalSelectStr
            let objVC = storyboard?.instantiateViewController(withIdentifier: "MyGoalTwoVC") as! MyGoalTwoVC
            objVC.selectGoal = self.goalSelectStr
           self.navigationController?.pushViewController(objVC, animated: true)
        }
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func postAllPersonalDataHandlerMethod() {
        
        let nullVal = NSNull()

        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")

        SubPersonalDict.personalDict["subDietGoal"] = nullVal
        SubPersonalDict.personalDict["subDietDuration"] = nullVal
        SubPersonalDict.personalDict["subDietProfType"] = self.goalSelectStr

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
