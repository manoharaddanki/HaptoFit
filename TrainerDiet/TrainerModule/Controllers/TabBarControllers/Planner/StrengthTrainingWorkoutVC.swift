//
//  StrengthTrainingWorkoutVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 27/06/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit
import FSCalendar

class StrengthTrainingWorkoutVC: UIViewController {
    
    @IBOutlet var workoutTblView: UITableView!
    @IBOutlet var calenderView: FSCalendar!
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var previousTapped:UIButton!
    @IBOutlet weak var nextTappedBtn:UIButton!
    
    @IBOutlet var headerView: UIView!
    var selectedSectionIndexArray : NSMutableArray = [0]
    var fromStrenghtOneListArray = NSMutableArray()
    var typeLevel = String()
    
    
    var titless = [String]()
    let workoutSubTitles = [["06:00 AM TO 07:00 AM","07:00 AM TO 08:00 AM","08:00 AM TO 09:00 AM"],["12:00 PM TO 01:00 PM","01:00 PM TO 02:00 PM","02:00 PM TO 03:00 PM"],["06:00 PM TO 07:00 PM","07:00 PM TO 08:00 PM","08:00 PM TO 09:00 PM"]]
    
    var workoutSubTitlesList = [[String:Any]]()
    var selectedDate = String()
    
    var strenthListArray = NSMutableArray()
    
    var selectedArray = NSMutableArray()
    var selectedIDsListArray = NSMutableArray()

    
    var filterWorkoutList = [[String:Any]]()
    var strenghtTwoListArray = [[String:Any]]()
    
    var selectedActiviyTypeDict = NSMutableDictionary()
    
    var selectedDateDictionary = NSMutableDictionary()

    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("SelectedTypsArr: \(strenthListArray)")
        
//        self.selectedDateDictionary.removeAllObjects()
//
//        for i in 0..<titless.count {
//
//            if let dicts = selectedActiviyTypeDict.value(forKey: titless[i]) {
//
//                selectedDateDictionary.setValue(dicts, forKey: titless[i])
//
//            }
//
//        }
//
//        print(selectedDateDictionary.count)
        
        
        self.selectedDate = (self.dateFormatter.string(from: Date()))
        print("today select date \(self.dateFormatter.string(from: Date()))")
        
        self.loadAllDates()
        
        self.calenderView.select(Date())
        self.calenderView.scope = .week
        self.calenderView.accessibilityIdentifier = "calendar"
        calenderView.appearance.headerMinimumDissolvedAlpha = 0
        calenderView.bringSubviewToFront(nextTappedBtn)
        calenderView.bringSubviewToFront(previousTapped)

        self.calenderView.appearance.weekdayTextColor = UIColor.white
        self.calenderView.appearance.titleDefaultColor     = UIColor.white

        headerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 2.0)
        calenderView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)

        workoutTblView.reloadData()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.workoutListMethod()
        
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        if let navController = self.navigationController {
            
            navController.popViewController(animated: true)
        }
        
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        
        for obj in selectedArray {
            
            if !self.fromStrenghtOneListArray.contains(obj) {
                                                      
                self.fromStrenghtOneListArray.add(obj)
                                                      
                }
            
        //self.fromStrenghtOneListArray.add(obj)
        }
        
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "StrengthTrainingListVC") as! StrengthTrainingListVC
        objVC.fromStrengthListArray = fromStrenghtOneListArray
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
    
    func workoutListMethod() {
        
        
        for i in 0..<workoutSubTitlesList.count {
            
            let dict = workoutSubTitlesList[i] as? NSDictionary
            
            if let name = dict?.value(forKey: "activityType") as? String {
                
                for nameStr in titless {
                    
                    if name == nameStr {
                        
                        self.filterWorkoutList.append(dict as! [String : Any])
                        
                    }else{
                        
                        //print("not called")
                    }
                    
                }
                                
            }
        }
        
       for i in 0..<filterWorkoutList.count {
        
        let dict = filterWorkoutList[i] as? NSDictionary
                           
                for nameStr in titless {
                    
                    if let name = dict?.value(forKey: "activityType") as? String {
                        
                        if nameStr.contains(name){
                            
                            if nameStr == name {

                                let tempdict = dict as? NSDictionary

                                self.strenghtTwoListArray.append(tempdict as! [String : Any])
                                
                            }
                                                        
                        }
                        
                    }

            }
        
            }
        
        print("filterWorkoutList is == >\(self.strenghtTwoListArray)")
    }
    
}

extension StrengthTrainingWorkoutVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return titless.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if selectedSectionIndexArray.contains(section) {
            
            let str = titless[section]
            
            if let arry = selectedDateDictionary.value(forKey: str) as? NSArray {
                
                print(arry.count)
                
                 return arry.count
            }
            else {
                
                return 0
            }
           
            
        } else {
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StrengthTrainingWorkoutTVCell", for: indexPath) as? StrengthTrainingWorkoutTVCell {
            
             let title = titless[indexPath.section]
            
            if let arry = selectedDateDictionary.value(forKey: title) as? NSArray
            {

                let tempdict = arry[indexPath.row]
                          
                let actName = (tempdict as AnyObject).value(forKey: "activityName") as? String
                
               // if let actArray = (tempdict as AnyObject).value(forKey: "activityNameSelectedDate") as? NSArray {
                    if let workoutCode = (tempdict as AnyObject).value(forKey: "workoutCode") as? String {

                    if selectedIDsListArray.contains(workoutCode) {

                    //if actArray.contains(self.selectedDate) {
                        
                        cell.checkBoxBtn.setImage(UIImage(named: "checkbox-active"), for: .normal)
                        cell.selectionStyle = .default
                        
//                    } else {
//
//                        cell.checkBoxBtn.setImage(UIImage(named: "checkbox-4"), for: .normal)
//                    }
                    }else{
                        
                        cell.checkBoxBtn.setImage(UIImage(named: "checkbox-4"), for: .normal)

                    }
                    }
                //}
                else {
                    
                     cell.checkBoxBtn.setImage(UIImage(named: "checkbox-4"), for: .normal)
                }
                
                
                           
                cell.nameTitle_Lbl.text = actName
                cell.checkBoxBtn.tag = indexPath.row
                cell.checkBoxBtn.accessibilityIdentifier = "\(indexPath.section)"
                cell.checkBoxBtn.addTarget(self, action: #selector(checkBtnClicked(sender:)), for: .touchUpInside)
                
                cell.selectionStyle = .none
                
                return cell
                       
            }
            else {
                
                return UITableViewCell()
            }
           
            
//            let name = (tempdict as AnyObject).value(forKey: "activityType") as? String
//
//            if title == name {
//
//                let dateArr = (tempdict as AnyObject).value(forKey: "activityTypeSelectedDate") as? NSArray
//
//                for obj in dateArr! {
//
//                    if selectedDate == "\(obj)" {
//
//                        let actName = (tempdict as AnyObject).value(forKey: "activityName") as? String
//
//                        cell.nameTitle_Lbl.text = actName
//                    }
//
//                }
                                                
//            }
            
            //let data =
            
        
            
        }
        
        return UITableViewCell()
    }
    
    @objc func checkBtnClicked(sender: UIButton) {
       
        let section = Int(sender.accessibilityIdentifier!)
        
        let row = sender.tag
         
        let title = titless[section!]
        
        var subTitle = ""
        
        var mutableArray = NSMutableArray()
        
        if let arry = selectedDateDictionary.value(forKey: title) as? NSArray
        {
            let mutArray = NSMutableArray()
            
            let arrObj = arry[row] as! NSDictionary
            
            mutableArray.addObjects(from: arry as! [Any])
            
            var muteDict = NSMutableDictionary(dictionary: arrObj)
            
//            muteDict = arrObj.mutableCopy() as! NSMutableDictionary
            
            if let workoutCode = (arrObj as AnyObject).value(forKey: "workoutCode") as? String {

                let subName = (arrObj as AnyObject).value(forKey: "activityName") as? String
                           
                subTitle = subName!
            
            if selectedIDsListArray.contains(workoutCode) {
                        
            if let actName = (arrObj as AnyObject).value(forKey: "activityNameSelectedDate") as? NSArray {
                
                mutArray.addObjects(from: actName as! [Any])
                
                if mutArray.contains(self.selectedDate){
                    
                    mutArray.remove(self.selectedDate)
                    self.selectedArray.remove(muteDict)
                    selectedIDsListArray.remove(workoutCode)

                }
                else {
                    
                    mutArray.add(self.selectedDate)
                    selectedIDsListArray.remove(workoutCode)
                    self.selectedArray.remove(muteDict)
                }
                
                
            }
            else {
                if mutArray.contains(self.selectedDate){
                    
                    mutArray.remove(self.selectedDate)
                    
                }
                else {
                    
                    mutArray.add(self.selectedDate)
                }
                
            }
            
                self.selectedArray.remove(muteDict)
                selectedIDsListArray.remove(workoutCode)
                
            }else {
            
             if let actName = (arrObj as AnyObject).value(forKey: "activityNameSelectedDate") as? NSArray {
                
            mutArray.addObjects(from: actName as! [Any])
                
            muteDict.setValue(mutArray, forKey: "activityNameSelectedDate")
            
            mutableArray.replaceObject(at: row, with: muteDict)
            
            for i in 0..<strenthListArray.count {

                if let dict = strenthListArray[i] as? NSDictionary {

                    let actName = dict.value(forKey: "activityName") as! String

                    let actType = dict.value(forKey: "activityType") as! String
                    let workoutCode = dict.value(forKey: "workoutCode") as! String

                if actName == subTitle && actType == title {

                    strenthListArray[i] = muteDict
                    var tempSelectedDict = NSMutableDictionary()
                    
                    tempSelectedDict["subActivityLevel"] = dict.value(forKey: "activityLevel")
                    tempSelectedDict["gender"] = dict.value(forKey: "gender")
                    tempSelectedDict["subActivityType"] = dict.value(forKey: "activityName")
                    tempSelectedDict["subWorkoutType"] = dict.value(forKey: "workoutType")
                    tempSelectedDict["subActivityName"] = dict.value(forKey: "activityType")
                    tempSelectedDict["subActivityTime"] = dict.value(forKey: "activityTime")
                    tempSelectedDict["weights"] = dict.value(forKey: "weights")
                    tempSelectedDict["reps"] = dict.value(forKey: "reps")
                    tempSelectedDict["setsCount"] = dict.value(forKey: "setsCount")
                    tempSelectedDict["restMin"] = dict.value(forKey: "restMin")
                    tempSelectedDict["metValue"] = dict.value(forKey: "metValue")
                    tempSelectedDict["subWorkoutDate"] = selectedDate
                    tempSelectedDict["subWorkoutCode"] = dict.value(forKey: "workoutCode")
                    
                    self.selectedArray.add(tempSelectedDict)
                    selectedIDsListArray.add(workoutCode)

                    break

                }

                }
            }
            }
         }
        }
        }
        
        selectedDateDictionary.setValue(mutableArray, forKey: title)
        
        print("selectedArray ==\(selectedArray)")
        print("selectedIDsListArray ==\(selectedIDsListArray)")

        workoutTblView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StrengthTrainWorkHeadTVCell") as? StrengthTrainWorkHeadTVCell {
            
            cell.selectBtn.tag = section
            cell.titleLbl.text = self.titless[section]
            cell.headerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 10.0)
            cell.selectBtn.addTarget(self, action: #selector(expandCollapseBtnAction(sender:)), for: .touchUpInside)
            
            if selectedSectionIndexArray.contains(section) {
                
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
        
        if selectedSectionIndexArray.contains(sender.tag) {
            
            self.selectedSectionIndexArray.remove(sender.tag)
            
        } else {
            
            self.selectedSectionIndexArray.add(sender.tag)
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
    
    func loadAllDates(){
        
        self.selectedDateDictionary.removeAllObjects()
        
               self.titless.removeAll()
               
               for i in 0..<strenthListArray.count {
                                                 
                   let dict = strenthListArray[i] as? NSDictionary
                   
                   if let datesArray = dict?.value(forKey: "activityTypeSelectedDate") as? NSArray {
                       
                       
                       if datesArray.contains(self.selectedDate){
                           
                           let typeName = dict?.value(forKey: "activityType") as? String
                           
                           var selectTypsArray = NSMutableArray()
                             
                           if let arry = selectedDateDictionary.value(forKey: typeName!) as? NSArray {
                                 
                                 selectTypsArray = NSMutableArray(array: arry)
                                 
                                 selectTypsArray.add(dict!)
                             }
                             else {
                                 
                                 selectTypsArray.add(dict!)
                                 
                             }
                           
                             selectedDateDictionary.setValue(selectTypsArray, forKey: typeName!)
                           
                           if !self.titless.contains(typeName!) {
                               
                               self.titless.append(typeName!)
                           }
                           
                       }
                       
                       
                   }
                   
               }
               
               self.workoutTblView.reloadData()
    }
    
}


extension StrengthTrainingWorkoutVC:  FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        self.selectedDate = (self.dateFormatter.string(from: date))
                
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        
        self.selectedSectionIndexArray.add(0)
        
        self.loadAllDates()
       
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }

    
}
