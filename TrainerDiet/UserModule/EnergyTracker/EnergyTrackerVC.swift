//
//  EnergyTrackerVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 18/08/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit
import FSCalendar
import Alamofire

class EnergyTrackerVC: UIViewController {
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var energyTrackBgView: UIView!
    @IBOutlet var questionBgView: UIView!
    @IBOutlet var questionStackView: UIView!
    @IBOutlet var workoutFollow_Lbl: UILabel!

    @IBOutlet var calories_Lbl: UILabel!
    @IBOutlet var img_View: UIImageView!

    @IBOutlet var title_Lbl: UILabel!
    @IBOutlet var calenderView: FSCalendar!

    @IBOutlet weak var previousTapped:UIButton!
    @IBOutlet weak var nextTappedBtn:UIButton!
    
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!
    
    var selectedDate = String()
    var calories = String()

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calenderView.select(Date())
        self.calenderView.scope = .week
        self.calenderView.accessibilityIdentifier = "calendar"
        calenderView.appearance.headerMinimumDissolvedAlpha = 0
        calenderView.bringSubviewToFront(nextTappedBtn)
        calenderView.bringSubviewToFront(previousTapped)
        calenderView.isUserInteractionEnabled = true
        
        self.calenderView.appearance.weekdayTextColor = UIColor.white
        self.calenderView.appearance.titleDefaultColor = UIColor.white

        self.selectedDate = (self.dateFormatter.string(from: Date()))

        headerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 2.0)
        calenderView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.energyTrackerAPICall()
        
    }
    
    @IBAction func yesBtnTapped(_ sender:UIButton) {
        
        //self.energyTrackerAPICall()
        self.calories_Lbl.text = "\(calories)"
        self.energyTrackBgView.isHidden = false
        self.questionBgView.isHidden = true
        self.img_View.isHidden = false
    }
    
    @IBAction func noBtnTapped(_ sender:UIButton) {

        self.calories_Lbl.text = "\(0.0)"

        self.energyTrackBgView.isHidden = false
        self.questionBgView.isHidden = true
        self.img_View.isHidden = false

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
    
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        if let navController = self.navigationController {
            
            navController.popViewController(animated: true)
        }
        
    }
    
    @IBAction func notificationBtnAction(_ sender:UIButton) {
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(objVC, animated: true)

    }
    
    func energyTrackerAPICall() {

        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")

        let subId = UserDefaults.standard.object(forKey: "subId") as? Int

        let params = ["subId":subId!,"bmrCalcDate":self.selectedDate] as [String : Any]
        
        print("Params == >\(params)")
        
        let urlString = "https://beapis.dieatto.com:8090/dao/bmrresults/getBmrResult"
        
        Alamofire.request(urlString, method: .put, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json; charset=utf-8","accept": "application/json"]).responseJSON{ (response) in
            
            Services.sharedInstance.dissMissLoader()

            if let responseData = response.result.value as? NSDictionary {
                
                print("responseData is == \(responseData)")
                if let energyExp = responseData.value(forKey: "energyExp") as? AnyObject {
                    
                    self.calories = "\(energyExp)"
                    //self.calories_Lbl.text = "\(energyExp)"
                    self.questionBgView.isHidden = false
                    self.questionStackView.isHidden = false
                    self.workoutFollow_Lbl.text = "Do you follow workout plan?"
                    self.energyTrackBgView.isHidden = true
                    
                }else{
                    
                    self.questionBgView.isHidden = false
                    self.energyTrackBgView.isHidden = true

                }
            }else{
                
                self.questionBgView.isHidden = false
                self.questionStackView.isHidden = true
                self.energyTrackBgView.isHidden = true
                self.workoutFollow_Lbl.text = "No workout plan assigned on this day"
                
            }
            
        }
    }
    
}

extension EnergyTrackerVC:  FSCalendarDataSource, FSCalendarDelegate , FSCalendarDelegateAppearance{
    
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")

        self.selectedDate = (self.dateFormatter.string(from: date))

        self.energyTrackerAPICall()
        
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if date .compare(Date()) == .orderedDescending {
            return false
        }
        else {
            return true
        }
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
      
//    func minimumDate(for calendar: FSCalendar) -> Date {
//        
//        return Date()
//    }

    func maximumDate(for calendar: FSCalendar) -> Date {
        
        return Date()
    }

//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
//        if arrDates.contains(self.dateFormatter.string(from: date)) {
//            return UIColor.darkGray
//        } else {
//            return UIColor.lightGray
//        }
//    }
}
