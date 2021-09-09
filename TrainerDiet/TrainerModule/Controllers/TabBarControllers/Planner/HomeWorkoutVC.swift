//
//  HomeWorkoutVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 13/06/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit
import Alamofire
import FSCalendar

class HomeWorkoutVC: UIViewController {
    
    @IBOutlet var homeWorkoutTableview: UITableView!
    @IBOutlet var title_Lbl: UILabel!
    
    var typeStr = String()
    var homeWorkoutArray = NSArray()
    
    
    @IBOutlet var calenderView: FSCalendar!
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var previousTapped:UIButton!
    @IBOutlet weak var nextTappedBtn:UIButton!
    
    @IBOutlet var headerView: UIView!
    
    var selectedIndexPaths = [IndexPath]()
    var selectedArray = NSMutableArray()
    var selectedIDsListArray = NSMutableArray()
    
    var selectedHomeWorkListArray = NSMutableArray()
    
    var selectedDate = String()
    
    var cacheCardioActivityDateArray = [[String:AnyObject]]()
    
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
        self.calenderView.appearance.weekdayTextColor = UIColor.white
        self.calenderView.appearance.titleDefaultColor = UIColor.white

        headerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 2.0)
        calenderView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
        
        print("selected Cardio List is ===> \(self.selectedHomeWorkListArray)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        homeWorkoutHandlerMethod()
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
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        
        if homeWorkoutArray.count > 0 {
            
            if homeWorkoutArray.count == 0 {
                
                showToast(message: "Please select at least one home workout")
                
            }else{
                
                for obj in selectedArray {
                    
                    if !self.selectedHomeWorkListArray.contains(obj) {
                                           
                        self.selectedHomeWorkListArray.add(obj)
                                           
                    }
                    
                   // self.selectedHomeWorkListArray.add(obj)
                }
                
                
                let objVC = storyboard?.instantiateViewController(withIdentifier: "StrengthTrainingViewController") as! StrengthTrainingViewController
                objVC.typeStr = typeStr
                objVC.fromCardioListArray = selectedHomeWorkListArray
                self.navigationController?.pushViewController(objVC, animated: true)
                
            }
            
        }else{
            
            let objVC = storyboard?.instantiateViewController(withIdentifier: "StrengthTrainingViewController") as! StrengthTrainingViewController
            objVC.typeStr = typeStr
            objVC.fromCardioListArray = selectedHomeWorkListArray
            self.navigationController?.pushViewController(objVC, animated: true)
            
        }
        
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        if let navController = self.navigationController {
            
            navController.popViewController(animated: true)
        }
        
    }
    
    func homeWorkoutHandlerMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")
        
        let urlString = TrinerUrlPath.sharedInstance.getUrlPath("dao/workoutdata/find/\(typeStr)/Home_Workout")
        
        print("Home Workout Api is ==>\(urlString)")

        Alamofire.request(urlString, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? NSArray {
                Services.sharedInstance.dissMissLoader()
                self.homeWorkoutArray = responseData
                
                if let workoutID = responseData.value(forKey: "workoutCode") as? String {
                    
                    self.selectedIDsListArray.add(workoutID)
                }
                self.homeWorkoutTableview.reloadData()
                print("responseData is ==>\(responseData)")
            }else{
                
                Services.sharedInstance.dissMissLoader()
            }
            Services.sharedInstance.dissMissLoader()

        }
    }
    
    
    
    
}

extension HomeWorkoutVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return homeWorkoutArray.count
    }
    
    func handleSelectionBy(tempDict: NSDictionary, cell: HomeWorkoutTVCell, workout_id: String) {
        
        if selectedIDsListArray.contains(workout_id) {
            
            cell.checkBox.setImage(UIImage(named: "checkbox-active"), for: .normal)
            
        } else {
            
            cell.checkBox.setImage(UIImage(named: "checkbox-4"), for: .normal)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeWorkoutTVCell", for: indexPath) as? HomeWorkoutTVCell {
            
            cell.selectionStyle = .none
            
            if let tempDict = homeWorkoutArray[indexPath.row] as? NSDictionary {
                
                cell.setCellData(resp_Dict: tempDict)
                cell.checkBox.isSelected = false
                
                let workoutCode = tempDict.value(forKey: "workoutCode") as? String
                
                if self.cacheCardioActivityDateArray.count > 0
                {
                    
                    for item in self.cacheCardioActivityDateArray
                    {
                        let subWorkoutCode =  (item as AnyObject).value(forKey: "subWorkoutCode") as? String
                        if subWorkoutCode == workoutCode {
                            cell.checkBox.isSelected = true
                        }
                    }
                    
                }
                else
                {
                    cell.checkBox.isSelected = false
                }
                
                if !cell.checkBox.isSelected
                {
                    cell.checkBox.isSelected = false
                }
                
                cell.checkBox.tag = indexPath.row
                cell.checkBox.addTarget(self, action: #selector(checkBox_BtnAction(sender:)), for: .touchUpInside)
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
        
//        if let tempDict = homeWorkoutArray[indexPath.row] as? NSDictionary {
//
//            if let workoutCode = tempDict.value(forKey: "workoutCode") as? String {
//
//                if selectedIDsListArray.contains(workoutCode) {
//
//                    var tempPlyrDict = NSDictionary()
//
//                    for obj in selectedArray {
//
//                        if let objDict = obj as? NSDictionary {
//
//                            if let workout_Code_ID = objDict.value(forKey: "workoutCode") as? String {
//
//                                if workoutCode == workout_Code_ID {
//
//                                    tempPlyrDict = objDict
//
//                                    selectedArray.remove(tempPlyrDict)
//
//                                    break
//                                }
//                            }
//                        }
//                    }
//
//                    selectedIDsListArray.remove(workoutCode)
//
//                } else {
//
//                    let tempSelectedDict = NSMutableDictionary()
//
//                    tempSelectedDict["subActivityLevel"] = tempDict.value(forKey: "activityLevel")
//                    tempSelectedDict["gender"] = tempDict.value(forKey: "gender")
//                    tempSelectedDict["subActivityType"] = tempDict.value(forKey: "activityType")
//                    tempSelectedDict["subWorkoutType"] = tempDict.value(forKey: "workoutType")
//                    tempSelectedDict["subActivityName"] = tempDict.value(forKey: "activityName")
//                    tempSelectedDict["subActivityTime"] = tempDict.value(forKey: "activityTime")
//                    tempSelectedDict["weights"] = tempDict.value(forKey: "weights")
//                    tempSelectedDict["reps"] = tempDict.value(forKey: "reps")
//                    tempSelectedDict["setsCount"] = tempDict.value(forKey: "setsCount")
//                    tempSelectedDict["restMin"] = tempDict.value(forKey: "restMin")
//                    tempSelectedDict["metValue"] = tempDict.value(forKey: "metValue")
//                    tempSelectedDict["subWorkoutDate"] = selectedDate
//                    tempSelectedDict["subWorkoutCode"] = tempDict.value(forKey: "workoutCode")
//                    selectedArray.add(tempSelectedDict)
//                    selectedIDsListArray.add(workoutCode)
//                }
//            }
//
//            print("selected array is =-==>\(selectedArray)")
//            print("selected work out ID is =-==>\(selectedIDsListArray)")
//
//
//        }
//
//        self.homeWorkoutTableview.reloadData()
        
    }
    
    @objc func checkBox_BtnAction(sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if let tempDict = homeWorkoutArray[sender.tag] as? NSDictionary {
            
            if let workoutCode = tempDict.value(forKey: "workoutCode") as? String {
                
                if selectedIDsListArray.contains(workoutCode) {
                    
                    var tempPlyrDict = NSDictionary()
                    
                    for obj in selectedArray {
                        
                        if let objDict = obj as? NSDictionary {
                            
                            if let workout_Code_ID = objDict.value(forKey: "workoutCode") as? String {
                                
                                if workoutCode == workout_Code_ID {
                                    
                                    tempPlyrDict = objDict
                                    
                                    selectedArray.remove(tempPlyrDict)
                                    
                                    break
                                }
                            }
                        }
                    }
                    
                    selectedIDsListArray.remove(workoutCode)
                    
                } else {
                    
                    let tempSelectedDict = NSMutableDictionary()
                    tempSelectedDict["subActivityLevel"] = tempDict.value(forKey: "activityLevel")
                    tempSelectedDict["gender"] = tempDict.value(forKey: "gender")
                    tempSelectedDict["subActivityType"] = tempDict.value(forKey: "activityType")
                    tempSelectedDict["subWorkoutType"] = tempDict.value(forKey: "workoutType")
                    tempSelectedDict["subActivityName"] = tempDict.value(forKey: "activityName")
                    tempSelectedDict["subActivityTime"] = tempDict.value(forKey: "activityTime")
                    tempSelectedDict["weights"] = tempDict.value(forKey: "weights")
                    tempSelectedDict["reps"] = tempDict.value(forKey: "reps")
                    tempSelectedDict["setsCount"] = tempDict.value(forKey: "setsCount")
                    tempSelectedDict["restMin"] = tempDict.value(forKey: "restMin")
                    tempSelectedDict["metValue"] = tempDict.value(forKey: "metValue")
                    tempSelectedDict["subWorkoutDate"] = selectedDate
                    tempSelectedDict["subWorkoutCode"] = tempDict.value(forKey: "workoutCode")
                    selectedArray.add(tempSelectedDict)
                    selectedIDsListArray.add(workoutCode)
                }
            }
        }
        
        cacheSubActivityTypeBasedOnDate(selectedDate: self.selectedDate)
    }
    
}

extension HomeWorkoutVC:  FSCalendarDataSource, FSCalendarDelegate {
    
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        print("did select date \(self.dateFormatter.string(from: date))")
        self.selectedDate = (self.dateFormatter.string(from: date))

        cacheSubActivityTypeBasedOnDate(selectedDate: self.selectedDate)

        self.homeWorkoutTableview.reloadData()
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    
    func cacheSubActivityTypeBasedOnDate(selectedDate:String)  {
        
        if self.cacheCardioActivityDateArray.count > 0
        {
            self.cacheCardioActivityDateArray.removeAll()
        }
        
        for item in self.selectedArray {
            let subWorkoutDate =  (item as AnyObject).value(forKey: "subWorkoutDate") as? String
            if subWorkoutDate! == selectedDate
            {
                self.cacheCardioActivityDateArray.append(item as! [String : AnyObject])
                //let subWorkoutCode =  (item as AnyObject).value(forKey: "subWorkoutCode") as? String
            }
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
}

