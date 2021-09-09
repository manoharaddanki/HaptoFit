//
//  TrainerHomeVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 18/06/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

class TrainerHomeVC: UIViewController {
    
    @IBOutlet var clientCount_View: UIView!
    
    @IBOutlet var community_View: UIView!
    @IBOutlet var liveStatus_View: UIView!
    @IBOutlet var liveStatus_Txt: UITextField!

    @IBOutlet var feedback_View: UIView!
    @IBOutlet var personalPlan_View: UIView!
    @IBOutlet var slotBooking_View: UIView!
    @IBOutlet var trainerName_Lbl: UILabel!
    @IBOutlet var myClientCount_Lbl: UILabel!
    
    var ripple:MTRipple!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        community_View.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 10.0)
        liveStatus_View.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 10.0)

        feedback_View.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 10.0)
        personalPlan_View.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 10.0)
        slotBooking_View.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 10.0)
        
        self.addDoneButtonOnKeyboard()
        //ripple = MTRipple.init(frame:CGRect(x: 0.0, y: 0.0, width: self.clientCount_View.frame.size.width, height: self.clientCount_View.frame.size.height)).startViewAniamtion(animationTime: 5.0, animateView: self.clientCount_View) as? MTRipple
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.getMyClientCountMethod()
        
        self.tabBarController?.tabBar.isHidden = false
        if let trainerName = UserDefaults.standard.object(forKey: "firstName") as? String {
            
            self.trainerName_Lbl.text = "Hi, \(trainerName)"
        }else{
            
            self.trainerName_Lbl.text = "Hi"
            
        }
        
    }
    
    @IBAction func communityBtnAction(_ sender: UIButton) {
        
        if TrainerIntroduce.proceed == true {
            
            let nextViewController = storyboard?.instantiateViewController(withIdentifier: "HomeStremmingViewController") as! HomeStremmingViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }else{
            
            let nextViewController = storyboard?.instantiateViewController(withIdentifier: "TrainerCommunityIntroduceVC") as! TrainerCommunityIntroduceVC
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
        
    }
    
    @IBAction func feedbackBtnAction(_ sender: UIButton) {
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "AllUsersVC") as! AllUsersVC
        objVC.isFrom = "Feedback"
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    @IBAction func plannerBtnAction(_ sender: UIButton) {
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "AllUsersVC") as! AllUsersVC
        objVC.isFrom = "PersonalPlanner"
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    @IBAction func slotBookingBtnAction(_ sender: UIButton) {
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "UserSlotBookingVC") as! UserSlotBookingVC
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    @IBAction func notificationBtnAction(_ sender: UIButton) {
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        //objVC.isFrom = "PersonalPlanner"
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.liveStatus_Txt.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        
        self.liveStatus_Txt.resignFirstResponder()
        self.postLiveGymStatusMethod()
    }
    
    func getMyClientCountMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: " Please wait")
        
        let trainerID = UserDefaults.standard.object(forKey: "trainerId") as! Int
        
        let urlString = TrinerUrlPath.sharedInstance.getUrlPath("dao/trainer/id/\(trainerID)")
        
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
            
            if response == nil
            {
                Services.sharedInstance.dissMissLoader()
                return
            }else
            {
                let dict = dict_responce(dict: response)
                
                if let gymName = dict.value(forKey: "trainerGymName") as? String {
                    
                    UserDefaults.standard.set(gymName, forKey: "gymName")
                    
                }
                
                if let onBoardingList = dict.value(forKey: "subscriberOnboarding") as? NSArray {
                    
                    if onBoardingList.count > 0 {
                        
                        self.myClientCount_Lbl.text = "\(onBoardingList.count)"
                    }else{
                        
                        self.myClientCount_Lbl.text = "0"
                        
                    }
                    
                }
                Services.sharedInstance.dissMissLoader()
                
            }
        })
    }
    
    func postLiveGymStatusMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: " Please wait")
        
        var gymID = Int()
        
        if let id = UserDefaults.standard.object(forKey: "trainerGymId") as? Int {
            
            gymID = id
            
        }else{
            
            gymID = 0

        }
        
        let params = ["gymId": gymID, "clientsCount" : self.liveStatus_Txt.text!] as [String : Any]
        
        let urlString = TrinerUrlPath.sharedInstance.getUrlPath("dao/livegymstatus/update")
                
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
                let dict = dict_responce(dict: response)
                
                let statusCode = response?.value(forKey: "status") as? Int

                if statusCode == 200 {
                    
                    AlertSingletanClass.sharedInstance.validationAlert(title: "Success", message: "Successfully update live gym status", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                        
                    })
                    
                }else{
                    
                    
                }
                
                Services.sharedInstance.dissMissLoader()
                
            }
        })
    }
}
