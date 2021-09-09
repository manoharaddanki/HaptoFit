//
//  MealPlanVC.swift
//  Dieatto
//
//  Created by M Venkat  Rao on 10/23/19.
//  Copyright © 2019 Developer Dev. All rights reserved.
//

import UIKit
import Alamofire
import FSCalendar

struct Category {
    let name : String
    var items : [[String:Any]]
}

class MealPlanVC: UIViewController {
    
    
    @IBOutlet var name_Lbl: UILabel!

    
    @IBOutlet var segmentStackView: UIView!
    @IBOutlet var nutritionView: UIView!
    @IBOutlet var nutritionIcon: UIImageView!
    @IBOutlet var nutritionName: UILabel!
    
    @IBOutlet var workoutView: UIView!
    @IBOutlet var workoutIcon: UIImageView!
    @IBOutlet var workoutName: UILabel!
    
    @IBOutlet var nutritionTblView: UITableView!
    @IBOutlet var workoutTblView: UITableView!
    
    @IBOutlet weak var headerView:UIView!
    
    @IBOutlet var calenderView: FSCalendar!
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var previousTapped:UIButton!
    @IBOutlet weak var nextTappedBtn:UIButton!
    
    var nutritionSectionIndexArray : NSMutableArray = [0]
    var workoutSectionIndexArray : NSMutableArray = [0]
    
    var workoutListArray = NSArray()
    
    var cardioListArr = [[String:Any]]();
    var strenghtListArr = [[String:Any]]();
    var homeWorkoutListArr = [[String:Any]]();
    
    var sections = [Category]()
    
    var selectedTab:Int = 1
    
    var isSelectedTab: Bool = false
    
    var selectedDate = String()
    
    var isFrom = String()
    
    
    var workoutHeaderImg = [UIImage(named: "cardio"),UIImage(named: "Strenght"),UIImage(named: "homeworkout")]
    
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedDate = (self.dateFormatter.string(from: Date()))
        
        self.calenderView.select(Date())
        self.calenderView.scope = .week
        self.calenderView.accessibilityIdentifier = "calendar"
        calenderView.appearance.headerMinimumDissolvedAlpha = 0
        calenderView.bringSubviewToFront(nextTappedBtn)
        calenderView.bringSubviewToFront(previousTapped)
        self.calenderView.appearance.weekdayTextColor = UIColor.white
        self.calenderView.appearance.titleDefaultColor = UIColor.white
        
        segmentStackView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
        
        headerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 2.0)
        
        calenderView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 10.0)
        
        
        self.workoutTblView.isHidden = false
        workoutView.backgroundColor = UIColor(hexFromString: "BEE4CB")
        
        //        if isFrom == "Home" {
        //
        //            self.workoutTblView.isHidden = false
        //            self.nutritionTblView.isHidden = true
        //            workoutView.backgroundColor = UIColor(hexFromString: "BEE4CB")
        //            nutritionView.backgroundColor = UIColor.white
        //
        //        }else{
        //
        //            self.workoutTblView.isHidden = true
        //            self.nutritionTblView.isHidden = false
        //            nutritionView.backgroundColor = UIColor(hexFromString: "BEE4CB")
        //            workoutView.backgroundColor = UIColor.white
        //
        //        }
        
        self.calenderView.select(Date())
        self.calenderView.scope = .week
        self.calenderView.accessibilityIdentifier = "calendar"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let trainerName = UserDefaults.standard.object(forKey: "firstName") as? String {
            
            self.name_Lbl.text = "Hi, \(trainerName)"
            
        }
        
            
        self.workoutListHandlerMethod()
        
    }
    
    
    @IBAction func notificationTapped(_ sender:UIButton) {
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(objVC, animated: true)
        
        
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
    
    
    @IBAction func segmetTabBtnAction(_ sender: UIButton) {
        
        workoutView.backgroundColor = UIColor(hexFromString: "BEE4CB")
        isSelectedTab = true
        self.workoutTblView.isHidden = false
        self.workoutListHandlerMethod()
        
    }
    
    func workoutListHandlerMethod() {
        
        var subId = Int()
        
        if let Id = UserDefaults.standard.object(forKey: "subId") as? Int {
            
            subId = Id
            
        }else{
            
            subId = 0
        }
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")
        
        let urlString = "https://beapis.dieatto.com:8090/dao/subworkout/find/\(subId)"
        Alamofire.request(urlString, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? NSArray {
                
                print("responseData is ==>\(responseData)")
                Services.sharedInstance.dissMissLoader()
                
                self.cardioListArr.removeAll()
                self.strenghtListArr.removeAll()
                self.homeWorkoutListArr.removeAll()
                
                for i in 0..<responseData.count{
                    
                    self.workoutListArray = responseData
                    let dict = responseData[i] as? NSDictionary
                    
                    if let subWorkoutDate = dict?.value(forKey: "subWorkoutDate") as? String
                    {
                        let dateStr = self.convertDateFormater_New(subWorkoutDate)
                        
                        if self.selectedDate == dateStr {
                            
                            if let subWorkoutType = dict?.value(forKey: "subWorkoutType") as? String
                            {
                                
                                if subWorkoutType == "Cardio_activity"  || subWorkoutType == "Cardio_Activity"{
                                    
                                    self.cardioListArr.append(dict as! [String : Any])
                                    
                                } else if subWorkoutType == "Strength_Training" {
                                    
                                    self.strenghtListArr.append(dict as! [String : Any])
                                }
                                else{
                                    
                                    self.homeWorkoutListArr.append(dict as! [String : Any])
                                }
                                
                            }
                            
                        }
                    }
                }
                Services.sharedInstance.dissMissLoader()
                
                //my array
                self.sections = [
                    Category(name:"Cardio Activity", items:self.cardioListArr),
                    Category(name:"Strength Training", items:self.strenghtListArr),
                    Category(name:"Home Workouts", items:self.homeWorkoutListArr)
                    
                ]
                self.workoutTblView.reloadData()
                
            }else{
                
                Services.sharedInstance.dissMissLoader()
                print("response iss==\(response.result)")
            }
        }
        print("api not calling")
    }
    
    func convertDateFormater_New(_ dateStr: String) -> String
    {
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: dateStr)// create date from string
        
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date!)
        return timeStamp
        
    }
    
    func dateWiseListMethod(selectedStr: String) {
        
        self.cardioListArr.removeAll()
        self.strenghtListArr.removeAll()
        self.homeWorkoutListArr.removeAll()
        
        for i in 0..<workoutListArray.count{
            
            let dict = workoutListArray[i] as? NSDictionary
            
            if let subWorkoutDate = dict?.value(forKey: "subWorkoutDate") as? String
            {
                let dateStr = convertDateFormater_New(subWorkoutDate)
                
                if selectedStr == dateStr {
                    
                    if let subWorkoutType = dict?.value(forKey: "subWorkoutType") as? String
                    {
                        
                        if subWorkoutType == "Cardio_activity"  || subWorkoutType == "Cardio_Activity"{
                            
                            self.cardioListArr.append(dict as! [String : Any])
                            
                        } else if subWorkoutType == "Strength_Training" {
                            
                            self.strenghtListArr.append(dict as! [String : Any])
                        }
                        else{
                            
                            self.homeWorkoutListArr.append(dict as! [String : Any])
                        }
                        
                    }
                    
                }
            }
        }
        
        //my array
        self.sections = [
            Category(name:"Cardio Activity", items:self.cardioListArr),
            Category(name:"Strength Training", items:self.strenghtListArr),
            Category(name:"Home Workouts", items:self.homeWorkoutListArr)
            
        ]
        self.workoutTblView.reloadData()
        print("cardioListArr is ==>\(self.cardioListArr)")
        print("strenghtListArr is ==>\(self.strenghtListArr)")
        print("homeWorkoutListArr is ==>\(self.homeWorkoutListArr)")
        
    }
}

// MARK:  TableView Delegate & DataSource Methods

extension MealPlanVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return  self.sections.count  //self.workoutListArray.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if workoutSectionIndexArray.contains(section) {
            
            let items = self.sections[section].items
            return items.count
            
        } else {
            
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutTVCell", for: indexPath) as? WorkoutTVCell {
            
            cell.selectionStyle = .none
            
            let items = self.sections[indexPath.section].items
            let item = items[indexPath.row]
            
            cell.time_Lbl.text = ""
            if item["subWorkoutType"] as? String == "Cardio_activity"  || item["subWorkoutType"] as? String == "Cardio_Activity"{
                
                cell.workoutType_Lbl.text = item["subActivityType"] as? String
                
               let setsStr = item["setsCount"] as? String ?? ""
               let repsStr = item["reps"] as? String ?? ""
               let weightStr = item["weights"] as? String ?? ""
               let time = item["subActivityTime"] as? Int ?? 0

               cell.time_Lbl.text = setsRepsTimeWeightGetMethod(sets: setsStr, reps: repsStr, weight: weightStr, time: time, from: "Cardio_Activity")
            }
            
            if item["subWorkoutType"] as? String == "Strength_Training"{
                
                let type = item["subActivityType"] as? String
                let name = item["subActivityName"] as? String
                
                let setsStr = item["setsCount"] as? String ?? ""
                let repsStr = item["reps"] as? String ?? ""
                let weightStr = item["weights"] as? String ?? ""
                
                cell.workoutType_Lbl.text = "\(name!) - \(type!)"
                                
                cell.time_Lbl.text = setsRepsTimeWeightGetMethod(sets: setsStr, reps: repsStr, weight: weightStr, time: 0, from: "Strength_Training")
                
            }else  if item["subWorkoutType"] as? String == "Home_Workout"{
                
                cell.workoutType_Lbl.text = item["subActivityType"] as? String
                                
                let setsStr = item["setsCount"] as? String ?? ""
                let repsStr = item["reps"] as? String ?? ""
                let weightStr = item["weights"] as? String ?? ""
                let time = item["subActivityTime"] as? Int ?? 0

                cell.time_Lbl.text = setsRepsTimeWeightGetMethod(sets: setsStr, reps: repsStr, weight: weightStr, time: time, from: "Home_Workout")
                
            }
            
            
            return cell
            
        } else {
            
            return UITableViewCell()
        }
        
    }
    
    func setsRepsTimeWeightGetMethod(sets: String, reps: String, weight: String, time: Int, from: String) -> String {
        
        var repsSetsWeightStr = String()
        
        if sets == "" || sets == "0" {
            
            repsSetsWeightStr = ""
            
        }else{
            
            repsSetsWeightStr = "Sets: \(sets)"
        }
        
        if reps == "" || reps == "0" {
            
            repsSetsWeightStr = "" + repsSetsWeightStr
            
        }else{
            
            repsSetsWeightStr = repsSetsWeightStr + " Reps: \(reps)"
        }
        
        if from == "Strength_Training" {
            
            if weight == "" || weight == "0" {
                
                repsSetsWeightStr = "" + repsSetsWeightStr
                
            }else{
                
                repsSetsWeightStr = repsSetsWeightStr + " Weigth: \(weight)"
            }
        }else{
            
            if time == 0  {
                
                repsSetsWeightStr = "" + repsSetsWeightStr
                
            }else if time == 1 {
                
                repsSetsWeightStr = repsSetsWeightStr + " Time: \(time) Min"
            }else{
                
                repsSetsWeightStr = repsSetsWeightStr + " Time: \(time) Mins"
            }
            
        }
        
        return repsSetsWeightStr
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutHeaderTVCell") as? WorkoutHeaderTVCell {
            
            cell.selectBtn.tag = section
            cell.titleLbl.text = self.sections[section].name
            cell.foodImg.image = workoutHeaderImg[section]
            cell.headerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 10.0)
            cell.selectBtn.addTarget(self, action: #selector(workoutExpandCollapseBtnAction), for: .touchUpInside)
            
            if workoutSectionIndexArray.contains(section) {
                
                cell.dropDownImgView.image = UIImage.init(named: "downArrow")
                
            } else {
                
                cell.dropDownImgView.image = UIImage.init(named: "rightarrow")
            }
            
            return cell
            
        } else {
            
            return nil
        }
        
    }
    
    @objc func workoutExpandCollapseBtnAction(sender : UIButton) {
        
        if workoutSectionIndexArray.contains(sender.tag) {
            
            self.workoutSectionIndexArray.remove(sender.tag)
            
        } else {
            
            self.workoutSectionIndexArray.add(sender.tag)
        }
        
        self.reloadDataSmoothly()
    }
    
    @objc func nutritionExpandCollapseBtnAction(sender : UIButton) {
        
        if nutritionSectionIndexArray.contains(sender.tag) {
            
            self.nutritionSectionIndexArray.remove(sender.tag)
            
        } else {
            
            self.nutritionSectionIndexArray.add(sender.tag)
        }
        
        self.reloadDataSmoothly()
    }
    
    func reloadDataSmoothly() {
        
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.fillMode = CAMediaTimingFillMode.forwards
        transition.duration = 0.2
        self.workoutTblView.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
        // Update your data source here
        
        self.workoutTblView.reloadData()
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
}

extension MealPlanVC:  FSCalendarDataSource, FSCalendarDelegate {
    
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        self.selectedDate = (self.dateFormatter.string(from: date))
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        
        
        self.dateWiseListMethod(selectedStr: self.selectedDate)
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
}
