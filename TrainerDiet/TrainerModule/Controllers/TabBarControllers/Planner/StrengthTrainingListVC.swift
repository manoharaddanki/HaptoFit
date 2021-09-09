//
//  StrengthTrainingListVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 30/05/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit
import Alamofire
import FSCalendar

class StrengthTrainingListVC: UIViewController {
    
    @IBOutlet var tablelistView: UITableView!
    @IBOutlet var title_Lbl: UILabel!
    @IBOutlet var calenderView: FSCalendar!
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var previousTapped:UIButton!
    @IBOutlet weak var nextTappedBtn:UIButton!
    
    @IBOutlet var headerView: UIView!
    var typeLevel = String()
    var strenghtTrainArray = NSArray()
    
    var selectedIndexPaths = [IndexPath]()
    var selectedArray = NSMutableArray()
    var selectedIDsListArray = NSMutableArray()
    
    var fromStrengthListArray = NSArray()
    var finalPlanerListArr = NSMutableArray()
    
    var selectedDate = String()
    
    var cacheCardioActivityDateArray = [[String:AnyObject]]()

    var sectionTitles = ["Cardio Activity", "Home Workouts", "Strength Training"]
    
    var summarySectionIndexArray : NSMutableArray = [0]
    var summaryListAray = NSMutableArray()
    var cardioActivityListArray = NSMutableArray()
    var homeWorkoutsListArray = NSMutableArray()
    var strenghtTrainingListArray = NSMutableArray()

    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedDate = (self.dateFormatter.string(from: Date()))
        print("today select date \(self.dateFormatter.string(from: Date()))")
        
        self.calenderView.select(Date())
        self.calenderView.scope = .week
        self.calenderView.accessibilityIdentifier = "calendar"
        calenderView.appearance.headerMinimumDissolvedAlpha = 0
        calenderView.bringSubviewToFront(nextTappedBtn)
        calenderView.bringSubviewToFront(previousTapped)
        self.calenderView.appearance.weekdayTextColor      = UIColor.white
        self.calenderView.appearance.titleDefaultColor      = UIColor.white

        headerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 2.0)
        calenderView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        //self.strenghtTrainingHandlerMethod()
        self.cacheSubActivityTypeBasedOnDate(selectedDate: self.selectedDate)

    }
    
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        
        
        let tempSelectedDict = NSMutableDictionary()
        
        for obj in fromStrengthListArray {
            
            tempSelectedDict["subActivityLevel"] = (obj as AnyObject).value(forKey: "subActivityLevel")
            tempSelectedDict["gender"] = (obj as AnyObject).value(forKey: "gender")
            tempSelectedDict["subActivityType"] = (obj as AnyObject).value(forKey: "subActivityType")
            tempSelectedDict["subWorkoutType"] = (obj as AnyObject).value(forKey: "subWorkoutType")
            tempSelectedDict["subActivityName"] = (obj as AnyObject).value(forKey: "subActivityName")
            tempSelectedDict["subActivityTime"] = (obj as AnyObject).value(forKey: "subActivityTime")
            tempSelectedDict["weights"] = (obj as AnyObject).value(forKey: "weights")
            tempSelectedDict["reps"] = (obj as AnyObject).value(forKey: "reps")
            tempSelectedDict["setsCount"] = (obj as AnyObject).value(forKey: "setsCount")
            tempSelectedDict["restMin"] = (obj as AnyObject).value(forKey: "restMin")
            tempSelectedDict["metValue"] = (obj as AnyObject).value(forKey: "metValue")
            tempSelectedDict["subWorkoutDate"] = (obj as AnyObject).value(forKey: "subWorkoutDate")
            
            //tempSelectedDict["subWorkoutCode"] = (obj as AnyObject).value(forKey: "workoutCode")
            
            self.finalPlanerListArr.add(obj)
            
        }
        
        print("final list ==\(self.finalPlanerListArr)")
        
        self.workOutPostHandlerMethod(workOutsArr: self.finalPlanerListArr)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        if let navController = self.navigationController {
            
            navController.popViewController(animated: true)
        }
        
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
    
    func strenghtTrainingHandlerMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")

        let urlString = TrinerUrlPath.sharedInstance.getUrlPath("dao/workoutdata/find/\(typeLevel)/Strength_Training")
        
        Alamofire.request(urlString, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? NSArray {
                
                self.strenghtTrainArray = responseData
                if let workoutID = responseData.value(forKey: "workoutCode") as? String {
                    
                    self.selectedIDsListArray.add(workoutID)
                }
                
                self.cacheSubActivityTypeBasedOnDate(selectedDate: self.selectedDate)
                self.tablelistView.reloadData()
                print("responseData is ==>\(responseData)")
            }
        }
    }
    
    
    func workOutPostHandlerMethod(workOutsArr: NSArray) {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Submitted")
        
        var trainerID = Int()
        
        if let Id = UserDefaults.standard.object(forKey: "trainerId") as? Int {
            
            trainerID = Id
        }else{
            
            trainerID = 0
        }
        let subId = SubCategory.subID //UserDefaults.standard.object(forKey: "subId") as? Int

        
        var params = [String:Any]()
        var urlString = String()
        
        if SubCategory.isFromPersonal == "Personal" {

        
             params = ["trainerId": trainerID, "subId": subId, "subscriberWorkouts":workOutsArr]
            
             urlString = TrinerUrlPath.sharedInstance.getUrlPath("dao/personalizedworkoutrequest/assignworkout")

        }else{
            
             params = ["trainerId": trainerID, "subscriberWorkouts":workOutsArr]
            
             urlString = TrinerUrlPath.sharedInstance.getUrlPath("dao/subworkoutrequest/assignworkout")
            
        }
        
        print("url is ==> \(urlString)")

        print("params is ==> \(print(params))")

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
                
                AlertSingletanClass.sharedInstance.validationAlert(title: "Success", message: "Workouts assigned Successfully", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                    
                    self.popBack(toControllerType: FitenessLevelVC.self)
                })
                
            }
        }
        )
    }
    
    
    func cacheSubActivityTypeBasedOnDate(selectedDate:String)  {
           
           if self.cacheCardioActivityDateArray.count > 0
           {
               self.cacheCardioActivityDateArray.removeAll()
           }
           
        cardioActivityListArray.removeAllObjects()
        homeWorkoutsListArray.removeAllObjects()
        strenghtTrainingListArray.removeAllObjects()

           for item in self.fromStrengthListArray {
               
               let subWorkoutDate = (item as AnyObject).value(forKey: "subWorkoutDate") as? String
               if subWorkoutDate! == selectedDate
               {
                   self.cacheCardioActivityDateArray.append(item as! [String : AnyObject])
                   
                if let subWorkoutType = (item as AnyObject).value(forKey: "subWorkoutType") as? String {
                    
                    if subWorkoutType == "Cardio_Activity" {
                       
                        self.cardioActivityListArray.add(item)
                    }
                    else if subWorkoutType == "Home_Workout" {
                        
                        self.homeWorkoutsListArray.add(item)
                        
                    }
                    else if subWorkoutType == "Strength_Training" {
                        
                        self.strenghtTrainingListArray.add(item)

                    }
                }
            }
                
            }
                 if self.cardioActivityListArray.count != 0 {
                                   
                    self.summaryListAray.add(self.cardioActivityListArray)
                    }
                               
                    if self.homeWorkoutsListArray.count != 0 {
                                   
                    self.summaryListAray.add(self.homeWorkoutsListArray)
                                   
                    }
                if self.strenghtTrainingListArray.count != 0 {
                                   
                self.summaryListAray.add(self.strenghtTrainingListArray)
                                   
                }
                
                   print("summaryListAray is ===\(summaryListAray)")
               }
}

extension StrengthTrainingListVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.sectionTitles.count //1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return cacheCardioActivityDateArray.count
        
        if summarySectionIndexArray.contains(section) {
            
            let items = (self.summaryListAray[section] as AnyObject).count
            return  items!
            
        } else {
            
            return 0
        }

        
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StrengthTrainingListTVCell", for: indexPath) as? StrengthTrainingListTVCell {
            
//            if let tempDict = self.cacheCardioActivityDateArray[indexPath.row] as? NSDictionary {
//
//                cell.setCellData(resp_Dict: tempDict, selectedDateStr: selectedDate)
//
//            }
            

            if let items = (self.summaryListAray[indexPath.section]) as? NSArray {
                
                if let dict = items[indexPath.row] as? NSDictionary {

            cell.setCellData(resp_Dict: dict, selectedDateStr: selectedDate)

              }
            }
            return cell
            
        }else{
            
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SlotBookingHeaderViewCell") as? SlotBookingHeaderViewCell {
            
            cell.selectBtn.tag = section
            cell.titleLbl.text = "\(self.sectionTitles[section] as? String ?? "")"
            cell.headerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 10.0)
            cell.selectBtn.addTarget(self, action: #selector(expandCollapseBtnAction(sender:)), for: .touchUpInside)
            
            if summarySectionIndexArray.contains(section) {
                
                cell.dropDownImgView.image = UIImage.init(named: "downArrow")
                
            } else {
                
                cell.dropDownImgView.image = UIImage.init(named: "rightarrow")
            }
            
            return cell
            
        } else {
            
            return nil
        }
    }
    
    @objc func expandCollapseBtnAction(sender : UIButton) {
        
        if summarySectionIndexArray.contains(sender.tag) {
            
            self.summarySectionIndexArray.remove(sender.tag)
            
        } else {
            
            self.summarySectionIndexArray.add(sender.tag)
        }
        
        self.reloadDataSmoothly()
    }
    
    func reloadDataSmoothly() {
        
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.fillMode = CAMediaTimingFillMode.forwards
        transition.duration = 0.2
        self.tablelistView.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
        // Update your data source here
        self.tablelistView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
}


extension StrengthTrainingListVC:  FSCalendarDataSource, FSCalendarDelegate {
    
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        self.selectedDate = (self.dateFormatter.string(from: date))
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        
        self.cacheSubActivityTypeBasedOnDate(selectedDate: self.selectedDate)
        
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        
        self.tablelistView.reloadData()
    }
        
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
}
