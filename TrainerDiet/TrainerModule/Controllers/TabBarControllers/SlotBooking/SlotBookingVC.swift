//
//  SlotBookingVC.swift
//  Dieatto
//
//  Created by Developer Dev on 12/06/20.
//  Copyright © 2020 Developer Dev. All rights reserved.
//

import UIKit
import FSCalendar
import Alamofire

class SlotBookingVC: UIViewController {
    
    @IBOutlet var workoutTblView: UITableView!
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet var calenderView: FSCalendar!
    @IBOutlet weak var previousTapped:UIButton!
    @IBOutlet weak var nextTappedBtn:UIButton!
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var name_Lbl: UILabel!
    
    @IBOutlet var slotBookingStatusView: UIView!
    @IBOutlet var bookingStatusBg_Lbl: UILabel!
    @IBOutlet var bookingStatusTxt_Lbl: UILabel!
    @IBOutlet var bookingStatusTime_Lbl: UILabel!
    
    @IBOutlet weak var bookNowBtn:UIButton!
    
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!
    
    var selectedSectionIndexArray : NSMutableArray = [0]
    var selectedDate = String()
    
    var selectedSlotArray = NSMutableArray()
    var selectedIDsListArray = NSMutableArray()
    
    var sectionTitles = NSMutableArray()
    
    var workoutSectionIndexArray : NSMutableArray = [0]
    
    var slotsListAray = NSMutableArray()
    var morningListArray = NSMutableArray()
    var afternoonListArray = NSMutableArray()
    var eveningListArray = NSMutableArray()
    var lateEveningListArray = NSMutableArray()
    
    
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
        slotBookingStatusView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 10.0)
        
        if let trainerName = UserDefaults.standard.object(forKey: "firstName") as? String {
            
            self.name_Lbl.text = "Hi,\(trainerName)"
            
        }else{
            
            self.name_Lbl.text = "Hi"
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
        self.slotBookingStatusView.isHidden = true
        self.bookingStatusBasedOnDate(selectedDate: self.selectedDate)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func notificationTapped(_ sender:UIButton) {
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(objVC, animated: true)
        
        
    }
    
    @IBAction func nextTapped(_ sender:UIButton) {
        
        calenderView.setCurrentPage(getNextMonth(date: calenderView.currentPage), animated: true)
    }
    
    @IBAction func slotSaveBtnTapped(_ sender:UIButton) {
        
        if self.workoutTblView.isHidden == false {
            
            if self.selectedSlotArray.count != 0 {
                
                self.bookingSlotAPIMethod()
                
            }else{
                
                self.showToast(message: "Please select one slot")
                
            }
        }else{
            
            
        }
        
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
    
}

extension SlotBookingVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if workoutSectionIndexArray.contains(section) {
            
            let items = (self.slotsListAray[section] as AnyObject).count
            return  items!
            
        } else {
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SlotBookingTVCell", for: indexPath) as? SlotBookingTVCell {
            
            cell.selectionStyle = .none
            let items = (self.slotsListAray[indexPath.section]) as? NSArray
            let dict = items?[indexPath.row] as? NSDictionary
            
            if let slotCategory = dict?.value(forKey: "slotCategory") as? String {
                
                if let startTimeHours = dict?.value(forKey: "startTimeHours") as? Int {
                    
                    if let startTimeMinutes = dict?.value(forKey: "startTimeMinutes") as? Int {
                        
                        if let endTimeHours = dict?.value(forKey: "endTimeHours") as? Int {
                            
                            if let endTimeMinutes = dict?.value(forKey: "endTimeMinutes") as? Int {
                                
                                var stratMinStr = "\(startTimeMinutes)"
                                var stratHoursStr = "\(startTimeHours)"
                                var endMinStr = "\(endTimeMinutes)"
                                var endHoursStr = "\(endTimeHours)"
                                
                                if (startTimeMinutes < 10) { stratMinStr = "0\(startTimeMinutes)" }
                                if (startTimeHours < 10) { stratHoursStr = "0\(startTimeHours)" }
                                if (endTimeMinutes < 10) { endMinStr = "0\(endTimeMinutes)" }
                                if (endTimeHours < 10) { endHoursStr = "0\(endTimeHours)" }
                                
                                if slotCategory == "morning" {
                                    
                                    cell.timeLbl.text = "\(stratHoursStr):\(stratMinStr)AM - \(endHoursStr):\(endMinStr)AM"
                                    
                                }else{
                                    
                                    cell.timeLbl.text = "\(stratHoursStr):\(stratMinStr)PM - \(endHoursStr):\(endMinStr)PM"
                                    
                                }
                            }
                        }
                    }
                }
            }
            
            if let slotCapacity = dict?.value(forKey: "remainingCapacity") as? Int {
                
                cell.countLbl.text = "\(slotCapacity)"
                cell.checkBoxBtn.isUserInteractionEnabled = false
                
            }else{
                
                cell.checkBoxBtn.isUserInteractionEnabled = true
                cell.checkBoxBtn.tag = indexPath.row
                cell.checkBoxBtn.accessibilityIdentifier = "\(indexPath.section)"
                cell.checkBoxBtn.addTarget(self, action: #selector(check_Btn_Action(sender:)), for: .touchUpInside)

            }
            
            if let id = dict?.value(forKey: "id") as? Int {
                
                if selectedIDsListArray.contains(id) {
                    
                    cell.checkBoxBtn.setImage(UIImage(named: "checkbox-active"), for: .normal)
                    cell.selectionStyle = .default
                    
                }else{
                    
                    cell.checkBoxBtn.setImage(UIImage(named: "checkbox-4"), for: .normal)
                    
                }
            }
            else {
                
                cell.checkBoxBtn.setImage(UIImage(named: "checkbox-4"), for: .normal)
            }
            
            return cell
            
        } else {
            
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SlotBookingHeaderViewCell") as? SlotBookingHeaderViewCell {
            
            cell.selectBtn.tag = section
            cell.titleLbl.text = "\((self.sectionTitles[section] as? String ?? "").capitalized + " Slots")"
            cell.headerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 10.0)
            cell.selectBtn.addTarget(self, action: #selector(expandCollapseBtnAction(sender:)), for: .touchUpInside)
            
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
    
    @objc func expandCollapseBtnAction(sender : UIButton) {
        
        if workoutSectionIndexArray.contains(sender.tag) {
            
            self.workoutSectionIndexArray.remove(sender.tag)
            
        } else {
            
            self.workoutSectionIndexArray.add(sender.tag)
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
    
    
    @objc func check_Btn_Action(sender: UIButton) {
        
        self.selectedSlotArray.removeAllObjects()
        self.selectedIDsListArray.removeAllObjects()
        
        let subId = UserDefaults.standard.object(forKey: "subId") as? Int
        let section = Int(sender.accessibilityIdentifier!)
        let dict = self.slotsListAray[section!] as! NSArray
        let tempDict = dict[sender.tag] as? NSDictionary
        
        let tempSelectedDict = NSMutableDictionary()
        tempSelectedDict["subId"] = subId!
        tempSelectedDict["gymId"] = tempDict?.value(forKey: "gymId") as? Int
        tempSelectedDict["slotDate"] = tempDict?.value(forKey: "slotDate") as? String
        tempSelectedDict["slotCategory"] = tempDict?.value(forKey: "slotCategory") as? String
        tempSelectedDict["gender"] = tempDict?.value(forKey: "gender") as? Int
        tempSelectedDict["startTimeHours"] = tempDict?.value(forKey: "startTimeHours") as? Int
        tempSelectedDict["startTimeMinutes"] = tempDict?.value(forKey: "startTimeMinutes") as? Int
        tempSelectedDict["endTimeHours"] = tempDict?.value(forKey: "endTimeHours") as? Int
        tempSelectedDict["endTimeMinutes"] = tempDict?.value(forKey: "endTimeMinutes") as? Int
        
        selectedSlotArray.add(tempSelectedDict)
        selectedIDsListArray.add(tempDict?.value(forKey: "id") as? Int ?? 0)
        print("selectedSlotArray is == \(selectedSlotArray)")
        self.workoutTblView.reloadData()
    }
}



extension SlotBookingVC:  FSCalendarDataSource, FSCalendarDelegate {
    
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        self.selectedDate = (self.dateFormatter.string(from: date))
        
        bookingStatusBasedOnDate(selectedDate: self.selectedDate)
        
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    
    func bookingStatusBasedOnDate(selectedDate:String)  {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")
        
        let subId = UserDefaults.standard.object(forKey: "subId") as? Int
        
        let params = ["subId":subId!,"slotDate" :selectedDate] as [String : Any]
        
        print("Params == >\(params)")
        
        let urlString = "https://beapis.dieatto.com:8090/dao/subscriber/slotBooking/getBookedSlot"
        
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
            let dict = dict_responce(dict: response)
            
            if dict.value(forKey: "bookingStatus") as? String == "BOOKED" {
                
                if let slotCategory = dict.value(forKey: "slotCategory") as? String {
                    
                    if let startTimeHours = dict.value(forKey: "startTimeHours") as? Int {
                        
                        if let startTimeMinutes = dict.value(forKey: "startTimeMinutes") as? Int {
                            
                            if let endTimeHours = dict.value(forKey: "endTimeHours") as? Int {
                                
                                if let endTimeMinutes = dict.value(forKey: "endTimeMinutes") as? Int {
                                    
                                    var startMinStr = "\(startTimeMinutes)"
                                    var startHoursStr = "\(startTimeHours)"
                                    var endMinStr = "\(endTimeMinutes)"
                                    var endHoursStr = "\(endTimeHours)"
                                    
                                    if (startTimeMinutes < 10) { startMinStr = "0\(startTimeMinutes)" }
                                    if (startTimeHours < 10) { startHoursStr = "0\(startTimeHours)" }
                                    if (endTimeMinutes < 10) { endMinStr = "0\(endTimeMinutes)" }
                                    if (endTimeHours < 10) { endHoursStr = "0\(endTimeHours)" }
                                    
                                    if slotCategory == "morning" {
                                        
                                        self.bookingStatusTime_Lbl.text = "\((slotCategory).capitalized + " Slot:")  \(startHoursStr):\(startMinStr)AM - \(endHoursStr):\(endMinStr)AM"
                                        
                                    }else{
                                        
                                        self.bookingStatusTime_Lbl.text = "\((slotCategory).capitalized + " Slot:")  \(startHoursStr):\(startMinStr)PM - \(endHoursStr):\(endMinStr)PM"
                                        
                                    }                                }
                            }
                        }
                    }
                    
                }
                
                // self.showToast(message: "Booking status successfully")
                self.workoutTblView.isHidden = true
                self.slotBookingStatusView.isHidden = false
                self.bookNowBtn.isHidden = true
                self.bookingStatusBg_Lbl.text = "✓"
                self.bookingStatusBg_Lbl.backgroundColor = UIColor.systemGreen
                self.bookingStatusTxt_Lbl.text = "Your booking has been confirmed!!"
                
            }else{
                
                self.workoutTblView.isHidden = false
                self.slotBookingStatusView.isHidden = true
                self.bookNowBtn.isHidden = false
                self.getSlotsBasedOnDate(selectedDate: selectedDate)
            }
            
        }
        )
    }
    
    func getSlotsBasedOnDate(selectedDate:String)  {
        
        var gender = Int()
        let gymID = UserDefaults.standard.object(forKey: "trainerGymId") as? Int
        let genderType = UserDefaults.standard.object(forKey: "gender") as? String
        
        if genderType == "Female" {
            
            gender = 1
            
        }else{
            
            gender = 0
            
        }
        
        let params = ["gymId":gymID!,"gender":gender,"slotStartDate":selectedDate,"slotEndDate":selectedDate] as [String : Any]
        
        print("Params == >\(params)")
        
        let urlString = "https://beapis.dieatto.com:8090/dao/gym/slotPublishment/getSlots"
        
        Alamofire.request(urlString, method: .put, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json; charset=utf-8","accept": "application/json"]).responseJSON{ (response) in
            
            
            self.sectionTitles.removeAllObjects()
            self.morningListArray.removeAllObjects()
            self.afternoonListArray.removeAllObjects()
            self.eveningListArray.removeAllObjects()
            self.lateEveningListArray.removeAllObjects()
            self.slotsListAray.removeAllObjects()
            
            if let responseData = response.result.value as? NSArray {
                
                print("responseData == >\(responseData)")

                for i in 0..<responseData.count {
                    
                    let dict = responseData[i] as? NSDictionary
                    
                    if let slotCategory = dict?.value(forKey: "slotCategory") as? String {
                        
                        if !self.sectionTitles.contains(slotCategory) {
                            
                            self.sectionTitles.add(slotCategory)
                            
                        }
                        
                        if slotCategory == "morning" || slotCategory == "Morning"{
                            
                            self.morningListArray.add(dict!)
                            
                        }else if slotCategory == "afternoon" || slotCategory == "Afternoon" {
                            
                            self.afternoonListArray.add(dict!)
                            
                        }else if slotCategory == "evening" || slotCategory == "Evening"{
                            
                            self.eveningListArray.add(dict!)
                            
                        }else if slotCategory == "late-evening" || slotCategory == "Late-Evening"{
                            
                            self.lateEveningListArray.add(dict!)
                            
                        }
                    }
                }
                
                
                if self.morningListArray.count != 0 {
                    
                    self.slotsListAray.add(self.morningListArray)
                }
                
                if self.afternoonListArray.count != 0 {
                    
                    self.slotsListAray.add(self.afternoonListArray)
                    
                }
                if self.eveningListArray.count != 0 {
                    
                    self.slotsListAray.add(self.eveningListArray)
                    
                }
                if self.lateEveningListArray.count != 0 {
                    
                    self.slotsListAray.add(self.lateEveningListArray)
                    
                }
                
                if self.slotsListAray.count != 0 {
                    
                    self.workoutTblView.isHidden = false
                    self.slotBookingStatusView.isHidden = true
                    self.bookNowBtn.isHidden = false
                    self.workoutTblView.reloadData()
                    
                }else{
                    
                    self.slotBookingStatusView.isHidden = false
                    self.workoutTblView.isHidden = true
                    self.bookNowBtn.isHidden = true
                    self.bookingStatusBg_Lbl.text = "x"
                    self.bookingStatusBg_Lbl.backgroundColor = UIColor.systemRed
                    self.bookingStatusTxt_Lbl.text = "No slots available"
                    self.bookingStatusTime_Lbl.text = ""
                    
                    
                }
                
            }else{
                
                self.slotBookingStatusView.isHidden = false
                self.workoutTblView.isHidden = true
                self.bookNowBtn.isHidden = true
                
                self.bookingStatusBg_Lbl.text = "x"
                self.bookingStatusBg_Lbl.backgroundColor = UIColor.systemRed
                self.bookingStatusTxt_Lbl.text = "No slots available"
                self.bookingStatusTime_Lbl.text = ""
                
            }
            
        }
    }
    
    
    func bookingSlotAPIMethod()  {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")
        
        let params = self.selectedSlotArray[0]
        print("Params == >\(params)")
        
        let urlString = "https://beapis.dieatto.com:8090/dao/subscriber/slotBooking/book"
        
        TrinerAPI.sharedInstance.TrainerService_put_with_header(paramsDict: params as! NSDictionary, urlPath:urlString,onCompletion: {
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
            
            if dict.value(forKey: "bookingStatus") as? String == "BOOKED" {
                
                if let slotCategory = dict.value(forKey: "slotCategory") as? String {
                    
                    if let startTimeHours = dict.value(forKey: "startTimeHours") as? Int {
                        
                        if let startTimeMinutes = dict.value(forKey: "startTimeMinutes") as? Int {
                            
                            if let endTimeHours = dict.value(forKey: "endTimeHours") as? Int {
                                
                                if let endTimeMinutes = dict.value(forKey: "endTimeMinutes") as? Int {
                                    
                                    var startMinStr = "\(startTimeMinutes)"
                                    var startHoursStr = "\(startTimeHours)"
                                    var endMinStr = "\(endTimeMinutes)"
                                    var endHoursStr = "\(endTimeHours)"
                                    
                                    if (startTimeMinutes < 10) { startMinStr = "0\(startTimeMinutes)" }
                                    if (startTimeHours < 10) { startHoursStr = "0\(startTimeHours)" }
                                    if (endTimeMinutes < 10) { endMinStr = "0\(endTimeMinutes)" }
                                    if (endTimeHours < 10) { endHoursStr = "0\(endTimeHours)" }
                                    
                                    if slotCategory == "morning" {
                                        
                                        self.bookingStatusTime_Lbl.text = "\((slotCategory).capitalized + " Slot:")  \(startHoursStr):\(startMinStr)AM - \(endHoursStr):\(endMinStr)AM"
                                        
                                    }else{
                                        
                                        self.bookingStatusTime_Lbl.text = "\((slotCategory).capitalized + " Slot:")  \(startHoursStr):\(startMinStr)PM - \(endHoursStr):\(endMinStr)PM"

                                    }
                                }
                            }
                        }
                    }
                    
                }
                
                self.showToast(message: "Booked Successfully")
                self.workoutTblView.isHidden = true
                self.slotBookingStatusView.isHidden = false
                self.bookingStatusBg_Lbl.text = "✓"
                self.bookingStatusBg_Lbl.backgroundColor = UIColor.systemGreen//UIColor.init(hexFromString: "009051")//UIColor(hexFromString: "#009051")
                self.bookingStatusTxt_Lbl.text = "Your booking has been confirmed!!"
                self.bookNowBtn.isHidden = true
                
            }else{
                
                self.workoutTblView.isHidden = false
                self.slotBookingStatusView.isHidden = true
                self.bookNowBtn.isHidden = false
                
            }
            
        }
        )
    }
    
}
