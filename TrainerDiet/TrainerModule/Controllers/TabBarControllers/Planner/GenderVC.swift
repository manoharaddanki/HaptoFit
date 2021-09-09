//
//  GenderVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 28/05/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit
import FSCalendar

class GenderVC: UIViewController {
    
    @IBOutlet var title_Lbl: UILabel!
    @IBOutlet var calenderView: FSCalendar!
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var maleButton: UIButton!
    @IBOutlet var feMaleButton: UIButton!
    @IBOutlet var maleView: UIView!
    @IBOutlet var femaleView: UIView!
    
    @IBOutlet weak var previousTapped:UIButton!
    @IBOutlet weak var nextTappedBtn:UIButton!
    @IBOutlet var headerView: UIView!
    
    var activityLevel = String()
    
    var genderType = String()
    var genderTypeVal = Int()
    
    var onBoardingListArray = NSArray()
    
    var userFoundFlag: Bool = false
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calenderView.select(Date())
        self.calenderView.scope = .week
        self.calenderView.accessibilityIdentifier = "calendar"
        calenderView.isUserInteractionEnabled = false
        
        calenderView.appearance.headerMinimumDissolvedAlpha = 0
        calenderView.bringSubviewToFront(nextTappedBtn)
        calenderView.bringSubviewToFront(previousTapped)
        
        self.calenderView.appearance.weekdayTextColor = UIColor.white
        self.calenderView.appearance.titleDefaultColor = UIColor.white
        
        headerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 2.0)
        
        calenderView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        //self.maleButton.setBackgroundImage(UIImage(named: "Rectangle -10"), for: .normal)
        //self.feMaleButton.setBackgroundImage(UIImage(named: "Rectangle -10"), for: .normal)
        maleView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 25)
        femaleView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 25)
        self.maleButton.setBackgroundImage(UIImage(named: ""), for: .normal)
        self.feMaleButton.setBackgroundImage(UIImage(named: ""), for: .normal)
        
        self.maleButton.setTitleColor(UIColor.init(named: "1D5384"), for: .normal)
        self.feMaleButton.setTitleColor(UIColor.init(named: "1D5384"), for: .normal)
        
        self.userFoundFlag = false
        
        getAllUserHandlerMethod()
        
    }
    
    
    @IBAction func infoBtnAction(_ sender: UIButton) {
        
        
    }
    
    @IBAction func nextTapped(_ sender:UIButton) {
        
        calenderView.setCurrentPage(getNextMonth(date: calenderView.currentPage), animated: true)
    }
    
    @IBAction  func previousTapped(_ sender:UIButton) {
        
        calenderView.setCurrentPage(getPreviousMonth(date: calenderView.currentPage), animated: true)
    }
    
    func getNextMonth(date:Date)->Date {
        
        return  Calendar.current.date(byAdding: .weekOfMonth, value: 1, to:date)!
    }
    
    func getPreviousMonth(date:Date)->Date {
        
        return  Calendar.current.date(byAdding: .weekOfMonth, value: -1, to:date)!
    }
    
    
    @IBAction func genderSelctionBtnAction(_ sender: UIButton) {
        
        if sender.tag == 1 {
            
            self.maleButton.setBackgroundImage(UIImage(named: "Rectangle -11"), for: .normal)
            self.maleButton.setTitleColor(UIColor.white, for: .normal)
            
            self.genderType = "Male"
            self.genderTypeVal = 0
            
            
        }else {
            
            self.feMaleButton.setTitleColor(UIColor.white, for: .normal)
            self.feMaleButton.setBackgroundImage(UIImage(named: "Rectangle -11"), for: .normal)
            self.genderType = "Female"
            self.genderTypeVal = 1
            
            
        }
        
        for item in self.onBoardingListArray {
            
            
            let dict = item as! NSDictionary
            
            if self.activityLevel == dict.value(forKey: "subscriberFitnessLevel") as! String {
                
                
                let type = dict.value(forKey: "subscriberGender") as! Int
                
                if self.genderTypeVal == type {
                    
                    self.userFoundFlag = true
                    
                }else{
                                        
                }
                
            }
        }
        
        
        if userFoundFlag == true {
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                
                let objVC = self.storyboard?.instantiateViewController(withIdentifier: "CardioActivityVC") as! CardioActivityVC
                objVC.cardioLevelType = "\(self.activityLevel)/\(self.genderType)"
                objVC.genderTypeStr = self.genderType
                self.navigationController?.pushViewController(objVC, animated: true)
            }
        }else{
            
            self.showToast(message: "User not found")
            self.maleButton.setTitleColor(UIColor.init(named: "1D5384"), for: .normal)
            self.feMaleButton.setTitleColor(UIColor.init(named: "1D5384"), for: .normal)
            self.maleButton.setBackgroundImage(UIImage(named: ""), for: .normal)
            self.feMaleButton.setBackgroundImage(UIImage(named: ""), for: .normal)

        }
        
        
        
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        if let navController = self.navigationController {
            
            navController.popViewController(animated: true)
        }
        
    }
    
    
    
    func getAllUserHandlerMethod() {
        
        //Services.sharedInstance.customLoader(view: self.view, message: "Please wait")
        
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
                Services.sharedInstance.dissMissLoader()
                
                let dict = dict_responce(dict: response)
                
                self.onBoardingListArray = []
                
                if let onBoardingList = dict.value(forKey: "subscriberOnboarding") as? NSArray {
                    
                    self.onBoardingListArray = onBoardingList
                    
                }
                
            }
        })
    }
    
}

extension GenderVC:  FSCalendarDataSource, FSCalendarDelegate {
    
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
}
