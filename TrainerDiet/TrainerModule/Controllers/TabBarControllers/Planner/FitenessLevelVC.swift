//
//  FitenessLevelVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 28/05/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit
import FSCalendar

class FitenessLevelVC: UIViewController {
    
    @IBOutlet var headerView: UIView!

    @IBOutlet var title_Lbl: UILabel!
    @IBOutlet var calenderView: FSCalendar!
    @IBOutlet var beginnerButton: UIButton!
    @IBOutlet var intermedButton: UIButton!
    @IBOutlet var advancedButton: UIButton!
    
    @IBOutlet var beginnerView: UIView!
    @IBOutlet var intermedView: UIView!
    @IBOutlet var advancedView: UIView!

    @IBOutlet weak var previousTapped:UIButton!
    @IBOutlet weak var nextTappedBtn:UIButton!
    
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!
    
    var levelType = String()
    
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
        calenderView.appearance.headerMinimumDissolvedAlpha = 0
        calenderView.bringSubviewToFront(nextTappedBtn)
        calenderView.bringSubviewToFront(previousTapped)
        calenderView.isUserInteractionEnabled = false
        
        self.calenderView.appearance.weekdayTextColor = UIColor.white
        self.calenderView.appearance.titleDefaultColor = UIColor.white

        
        headerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 2.0)
        calenderView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
        
//        if let trainerName = UserDefaults.standard.object(forKey: "firstName") as? String {
//
//            self.title_Lbl.text = "Hi, \(trainerName)"
//            
//        }else{
//            
//            self.title_Lbl.text = "Hi"
//
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
      self.beginnerButton.setBackgroundImage(UIImage(named: ""), for: .normal)
        self.intermedButton.setBackgroundImage(UIImage(named: ""), for: .normal)
        self.advancedButton.setBackgroundImage(UIImage(named: ""), for: .normal)
        
        beginnerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 25)
        intermedView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 25)
        advancedView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 25)

        self.beginnerButton.setTitleColor(UIColor.init(named: "1D5384"), for: .normal)
        self.intermedButton.setTitleColor(UIColor.init(named: "1D5384"), for: .normal)
        self.advancedButton.setTitleColor(UIColor.init(named: "1D5384"), for: .normal)

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
    
    
    @IBAction func fitnessBtnAction(_ sender: UIButton) {
        
        self.levelType = ""
        
        if sender.tag == 1 {
            
            self.beginnerButton.setBackgroundImage(UIImage(named: "Rectangle -11"), for: .normal)
            
            intermedView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 22.6)
            advancedView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 22.6)
            self.levelType = "Beginner"
            self.beginnerButton.setTitleColor(UIColor.white, for: .normal)

        }else if sender.tag == 2 {
            
            self.intermedButton.setBackgroundImage(UIImage(named: "Rectangle -11"), for: .normal)
          
            beginnerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 22.6)
            advancedView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 22.6)

            self.intermedButton.setTitleColor(UIColor.white, for: .normal)

            self.levelType = "Intermediate"
            
        }else{
            
            beginnerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 22.6)
            intermedView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 22.6)
            self.advancedButton.setBackgroundImage(UIImage(named: "Rectangle -11"), for: .normal)
            self.advancedButton.setTitleColor(UIColor.white, for: .normal)

            self.levelType = "Advanced"
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            let objVC = self.storyboard?.instantiateViewController(withIdentifier: "GenderVC") as! GenderVC
            objVC.activityLevel = self.levelType
            self.navigationController?.pushViewController(objVC, animated: true)
            
        }
        
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        if let navController = self.navigationController {
            
            navController.popViewController(animated: true)
        }
        
    }
    
    
}

extension FitenessLevelVC:  FSCalendarDataSource, FSCalendarDelegate {
    
    
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
