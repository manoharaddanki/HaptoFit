//
//  UserSlotBookingVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 17/07/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit
import FSCalendar
import Alamofire
import AAPickerView

class UserSlotBookingVC: UIViewController {
    
    @IBOutlet var workoutTblView: UITableView!
    @IBOutlet var viewBookingListTblView: UITableView!
    @IBOutlet var viewBookingListView: UIView!
    
    @IBOutlet var calenderView: FSCalendar!
    @IBOutlet weak var previousTapped:UIButton!
    @IBOutlet weak var nextTappedBtn:UIButton!
    
    @IBOutlet weak var saveSlotTappedBtn:UIButton!
    @IBOutlet weak var copyPreviousDaysSlotTappedBtn:UIButton!

    @IBOutlet weak var datePickerView:UIDatePicker!
    @IBOutlet var timePickerBgView: UIView!
    @IBOutlet var slotCountPickerBgView: UIView!
    @IBOutlet var slotCountPickerView: UIPickerView!
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var name_Lbl: UILabel!
    
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!
    
    var selectedSectionIndexArray : NSMutableArray = [0]
    var selectedDate = String()
    
    var morningSlotsRows = 0
    var afternoonSlotsRows = 0
    var eveningSlotsRows = 0
    var lateEveningSlotsRows = 0
    var numberOfSlots = 0
    
    var sections = 0
    var rows = 0
    
    var slotsListAray = NSMutableArray()
    var morningListArray = NSMutableArray()
    var afternoonListArray = NSMutableArray()
    var eveningListArray = NSMutableArray()
    var lateEveningListArray = NSMutableArray()
    var viewBookingSlotsList = NSMutableArray()
    var sectionTitleArr = NSMutableArray()
    var isPublished: Bool = false
    
    var copySlotsListAray = NSMutableArray()
    var copyMorningListArray = NSMutableArray()
    var copyAfternoonListArray = NSMutableArray()
    var copyEveningListArray = NSMutableArray()
    var copyLateEveningListArray = NSMutableArray()
    var copyDate: Bool = false
    
    var copyFromPreviousDateList = NSMutableArray()

    var isTimeStrFrom = ""
    
    let sectionTitleArr1 = ["Morning Slots", "Afternoon Slots", "Evening Slots" , "Late Evening Slots"]
    
    var slotsCapacityArray = ["10", "15", "20", "25", "30", "35","40","45","50","55","60","65","70"]
    var tempDict = ["gender":0,"startTimeHours":06,"startTimeMinutes":00,"endTimeHours":07,"endTimeMinutes":00,"slotCapacity":10,"remainingCapacity":10] as [String : Any]
    
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    let timePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedDate = (self.dateFormatter.string(from: Date()))
        print("today select date \(self.dateFormatter.string(from: Date()))")
        
        //tempDict.updateValue(self.selectedDate, forKey: "slotDate")
        
        self.viewBookingListTblView.delegate = self
        self.viewBookingListTblView.dataSource = self
        
        
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
        
        self.copyPreviousDaysSlotTappedBtn.setTitleColor(UIColor.init(hexFromString: "2B4964"), for: .normal)
        
        if let trainerName = UserDefaults.standard.object(forKey: "firstName") as? String {
            
            self.name_Lbl.text = "Hi,\(trainerName)"
            
        }else{
            
            self.name_Lbl.text = "Hi"
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
        self.viewBookingListView.isHidden = true
        self.timePickerBgView.isHidden = true
        self.slotCountPickerBgView.isHidden = true
        self.copyPreviousDaysSlotTappedBtn.isHidden = true

        self.getSlotsBasedOnDate(selectedDate: self.selectedDate)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        //self.popBack(toControllerType: HomeVC.self)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonAction(_ sender: UIButton!) {
        print("Button tapped")
    }
    
    
    @IBAction func copyPreviousDaySlotsBtnTapped(_ sender: UIButton) {
           
           
        if self.copyDate == true {
        
            self.morningListArray = self.copyMorningListArray
            self.afternoonListArray = self.copyAfternoonListArray
            self.eveningListArray = self.copyEveningListArray
            self.lateEveningListArray = self.copyLateEveningListArray

            self.slotsListAray.add(self.morningListArray)
            self.slotsListAray.add(self.afternoonListArray)
            self.slotsListAray.add(self.eveningListArray)
            self.slotsListAray.add(self.lateEveningListArray)

            self.workoutTblView.reloadData()
        }else{
            
            //self.showToast(message: "Please Select date")
        }
       }
    
    @IBAction func notificationTapped(_ sender:UIButton) {
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    @IBAction func booknowTapped(_ sender:UIButton) {
        
        let publishedSlotDetailsArray = NSMutableArray()
        let publishedSlotDict = NSMutableDictionary()
        let slotCategoryDetailsyArray = NSMutableArray()
        
        if  self.slotsListAray.count != 0 {
            
            if let tempMorningArr = self.slotsListAray[0] as? NSArray {
                
                if tempMorningArr.count != 0 {
                    let slotCategoryDict = NSMutableDictionary()
                    slotCategoryDict.setValue("morning", forKeyPath: "slotCategory")
                    slotCategoryDict.setValue(tempMorningArr, forKeyPath: "slotDetails")
                    slotCategoryDetailsyArray.add(slotCategoryDict)
                }
            }
            
            
            if let tempAfternoonArr = self.slotsListAray[1] as? NSArray {
                
                if tempAfternoonArr.count != 0 {
                    let slotCategoryDict1 = NSMutableDictionary()
                    slotCategoryDict1.setValue("afternoon", forKeyPath: "slotCategory")
                    slotCategoryDict1.setValue(tempAfternoonArr, forKeyPath: "slotDetails")
                    slotCategoryDetailsyArray.add(slotCategoryDict1)
                }
                
            }
            
            if let tempEveningArr = self.slotsListAray[2] as? NSArray {
                
                if tempEveningArr.count != 0 {
                    let slotCategoryDict2 = NSMutableDictionary()
                    slotCategoryDict2.setValue("evening", forKeyPath: "slotCategory")
                    slotCategoryDict2.setValue(tempEveningArr, forKeyPath: "slotDetails")
                    slotCategoryDetailsyArray.add(slotCategoryDict2)
                    
                }
            }
            
            
            if let tempLateEveningArr = self.slotsListAray[3] as? NSArray {
                
                if tempLateEveningArr.count != 0 {
                    let slotCategoryDict3 = NSMutableDictionary()
                    slotCategoryDict3.setValue("late-evening", forKeyPath: "slotCategory")
                    slotCategoryDict3.setValue(tempLateEveningArr, forKeyPath: "slotDetails")
                    slotCategoryDetailsyArray.add(slotCategoryDict3)
                    
                }
            }
            publishedSlotDict.setValue(slotCategoryDetailsyArray, forKeyPath: "slotCategoryDetails")
            publishedSlotDict.setValue(self.selectedDate, forKeyPath: "slotDate")
            publishedSlotDetailsArray.add(publishedSlotDict)
            
            print("publishedSlotDetailsArray is ==>\(publishedSlotDetailsArray)")
            
            slotPublishmentAPICall(slotArr: publishedSlotDetailsArray)
            
        }else{
            
            self.showToast(message: "Please select at least one slot")
        }
        
    }
    
    @IBAction func viewBookingCloseTapped(_ sender:UIButton) {
        
        self.viewBookingListView.isHidden = true
        // self.workoutTblView.isHidden = false
        
    }
    
    @IBAction func pickerViewTapped(sender: AnyObject){
        
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = "HH:MM a"
        //        let index = IndexPath(row: rows , section: sections)
        //        let cell: UserSlotBookingTVCell = self.workoutTblView.cellForRow(at: index) as! UserSlotBookingTVCell
        //
        //
        //        let calendar = Calendar.current
        //        var minDateComponent = calendar.dateComponents([.hour,.minute], from: Date())
        //         minDateComponent.minute = 00
        //        minDateComponent.hour = 01
        //
        //         let minDate = calendar.date(from: minDateComponent)
        //         print(" min minutes : \(minDate)")
        //
        //        var maxDateComponent = calendar.dateComponents([.hour,.minute], from: Date())
        //        maxDateComponent.hour = 12
        //         maxDateComponent.minute = 60
        //
        //         let maxDate = calendar.date(from: maxDateComponent)
        //         print("max minutes : \(maxDate)")
        //
        //         self.datePickerView.minimumDate = minDate! as Date
        //         self.datePickerView.maximumDate =  maxDate! as Date
        //
        //        cell.endTimeLbl.text = formatter.string(from: datePickerView.date)
        //        self.datePickerView.isHidden = true
    }
    
    
    @IBAction func pickerCancelBtnAction(_ sender: UIButton) {
        
        self.timePickerBgView.isHidden = true
        
    }
    
    @IBAction func slotsPickerCloseBtnAction(_ sender: UIButton) {
        
        self.slotCountPickerBgView.isHidden = true
        
    }
    
    
    
    @IBAction func pickerDoneBtnAction(_ sender: UIButton) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let index = IndexPath(row: rows , section: sections)
        let cell: UserSlotBookingTVCell = self.workoutTblView.cellForRow(at: index) as! UserSlotBookingTVCell
        let dict = self.slotsListAray[sections] as! NSArray
        var tempDict = dict[rows] as? NSDictionary
        
        var tempDict1 = NSMutableDictionary()
        tempDict1 = tempDict?.mutableCopy() as! NSMutableDictionary
        
        /* let calendar = Calendar.current
         var minDateComponent = calendar.dateComponents([.hour,.minute], from: Date())
         var maxDateComponent = calendar.dateComponents([.hour,.minute], from: Date())
         
         if sections == 0 {
         
         minDateComponent.hour = 01
         minDateComponent.minute = 00
         maxDateComponent.hour = 12
         maxDateComponent.minute = 00
         
         }else if sections == 1 {
         
         minDateComponent.hour = 12
         minDateComponent.minute = 00
         maxDateComponent.hour = 16
         maxDateComponent.minute = 00
         
         }else if sections == 2 {
         
         minDateComponent.hour = 16
         minDateComponent.minute = 00
         maxDateComponent.hour = 19
         maxDateComponent.minute = 00
         
         }else{
         
         minDateComponent.hour = 19
         minDateComponent.minute = 00
         maxDateComponent.hour = 22
         maxDateComponent.minute = 00
         }
         
         let minDate = calendar.date(from: minDateComponent)
         let maxDate = calendar.date(from: maxDateComponent)
         
         self.datePickerView.minimumDate = minDate! as Date
         self.datePickerView.maximumDate =  maxDate! as Date
         */
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "HH"
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "mm"
        
        let hours = Int(formatter1.string(from: datePickerView.date))
        let minutes = Int(formatter2.string(from: datePickerView.date))
        
        
        print("hours & minutes is == \(hours) \(minutes)")
        if isTimeStrFrom == "StartTime" {
            
            tempDict1["startTimeHours"] = hours
            tempDict1["startTimeMinutes"] = minutes
            
            //cell.startTimeLbl.text = formatter.string(from: datePickerView.date)
            
        }else{
            
            tempDict1["endTimeHours"] = hours
            tempDict1["endTimeMinutes"] = minutes
            
            //cell.endTimeLbl.text = formatter.string(from: datePickerView.date)
            
        }
        
        if sections == 0 {
            
            self.morningListArray[rows] = tempDict1
            // self.slotsListAray.removeObject(at: 0)
            self.slotsListAray[0] = self.morningListArray
            
        }
        else if sections == 1 {
            
            self.afternoonListArray[rows] = tempDict1
            //self.slotsListAray.removeObject(at: 0)
            self.slotsListAray[1] = self.afternoonListArray
            
        }else if sections == 2 {
            
            self.eveningListArray[rows] = tempDict1
            //self.slotsListAray.removeObject(at: 0)
            self.slotsListAray[2] = self.eveningListArray
            
        }else{
            
            self.lateEveningListArray[rows] = tempDict1
            //self.slotsListAray.removeObject(at: 0)
            self.slotsListAray[3] = self.lateEveningListArray
        }
        self.workoutTblView.reloadData()
        self.timePickerBgView.isHidden = true
        
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
    
}

extension UserSlotBookingVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == workoutTblView {
            
            return numberOfSlots
            
        }else{
            
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == workoutTblView {
            
            if selectedSectionIndexArray.contains(section) {
                
                
                if self.slotsListAray.count != 0 {
                    
                    if let rowCount = self.slotsListAray[section] as? NSArray {
                        
                        return rowCount.count
                        
                    }else{
                        
                        return 0
                    }
                }else{
                    
                    return 0
                }
                
                
                
                /*  if section == 0 {
                 
                 return morningListArray.count
                 
                 }else if section == 1 {
                 
                 return afternoonListArray.count
                 
                 }else if section == 2 {
                 
                 return eveningListArray.count
                 
                 }else{
                 
                 return lateEveningListArray.count
                 
                 }*/
                
            } else {
                
                return 0
            }
            
        }else {
            
            if self.viewBookingSlotsList.count != 0 {
                
                return self.viewBookingSlotsList.count
                
            }else{
                
                return 1
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == workoutTblView {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "UserSlotBookingTVCell", for: indexPath) as? UserSlotBookingTVCell {
                
                cell.selectionStyle = .none
                
                if self.slotsListAray.count > 0 {
                    
                    let items = (self.slotsListAray[indexPath.section]) as? NSArray
                    let dict = items?[indexPath.row] as? NSDictionary
                    let slotCategory = dict?.value(forKey: "slotCategory") as? String
                    let genderId = dict?.value(forKey: "gender") as? Int
                    let startTimeHours = dict?.value(forKey: "startTimeHours") as? Int
                    let startTimeMinutes = dict?.value(forKey: "startTimeMinutes") as? Int
                    let endTimeHours = dict?.value(forKey: "endTimeHours") as? Int
                    let endTimeMinutes = dict?.value(forKey: "endTimeMinutes") as? Int
                    let slotCapacity = dict?.value(forKey: "slotCapacity") as? Int
                    
                    cell.countTxtField.text = "\(slotCapacity ?? 0)"
                    
                    var startMinutesStr = "\(startTimeMinutes ?? 0)"
                    var stratHoursStr = "\(startTimeHours ?? 0)"
                    var endMinutesStr = "\(endTimeMinutes ?? 0)"
                    var endHoursStr = "\(endTimeHours ?? 0)"
                    
                    if (startTimeMinutes ?? 0 < 10) { startMinutesStr = "0\(startTimeMinutes ?? 0)" }
                    if (startTimeHours ?? 0 < 10) { stratHoursStr = "0\(startTimeHours ?? 0)" }
                    if (endTimeMinutes ?? 0 < 10) { endMinutesStr = "0\(endTimeMinutes ?? 0)" }
                    if (endTimeHours ?? 0 < 10) { endHoursStr = "0\(endTimeHours ?? 0)" }
                    
                    if startTimeHours ?? 0 < 12 && endTimeHours ?? 0 < 12 {
                        
                        cell.startTimeLbl.text = "\(stratHoursStr):\(startMinutesStr)AM"
                        cell.endTimeLbl.text = "\(endHoursStr):\(endMinutesStr)AM"
                        
                    }else{
                        
                        cell.startTimeLbl.text = "\(stratHoursStr):\(startMinutesStr)PM"
                        cell.endTimeLbl.text = "\(endHoursStr):\(endMinutesStr)PM"
                        
                    }
                    
                    if genderId == 0 {
                        
                        cell.maleBtn.setImage(UIImage(named: "checkbox-active"), for: .normal)
                        cell.femaleBtn.setImage(UIImage(named: "checkbox"), for: .normal)
                        cell.maleFemaleBtn.setImage(UIImage(named: "checkbox"), for: .normal)
                        
                        
                    }else if genderId == 1 {
                        
                        cell.maleBtn.setImage(UIImage(named: "checkbox"), for: .normal)
                        cell.femaleBtn.setImage(UIImage(named: "checkbox-active"), for: .normal)
                        cell.maleFemaleBtn.setImage(UIImage(named: "checkbox"), for: .normal)
                        
                    }
                    else if genderId == 3 {
                        
                        cell.maleBtn.setImage(UIImage(named: "checkbox"), for: .normal)
                        cell.femaleBtn.setImage(UIImage(named: "checkbox"), for: .normal)
                        cell.maleFemaleBtn.setImage(UIImage(named: "checkbox-active"), for: .normal)
                        
                    }else{
                        
                        cell.maleBtn.setImage(UIImage(named: "checkbox"), for: .normal)
                        cell.femaleBtn.setImage(UIImage(named: "checkbox"), for: .normal)
                        cell.maleFemaleBtn.setImage(UIImage(named: "checkbox"), for: .normal)
                    }
                    
                    if self.isPublished == true {
                        
                        cell.closeBtn.isHidden = true
                        cell.viewBookingsBtn.isHidden = false
                        cell.viewBookingsBtn.tag = indexPath.row
                        cell.viewBookingsBtn.accessibilityIdentifier = "\(indexPath.section)"
                        cell.viewBookingsBtn.addTarget(self, action: #selector(viewAllBookingSlots_Btn_Action(sender:)), for: .touchUpInside)
                        cell.startTimeBtn.isUserInteractionEnabled = false
                        cell.endTimeBtn.isUserInteractionEnabled = false
                        cell.maleBtn.isUserInteractionEnabled = false
                        cell.femaleBtn.isUserInteractionEnabled = false
                        cell.maleFemaleBtn.isUserInteractionEnabled = false
                        cell.countTxtField.isUserInteractionEnabled = false

                    }else{
                        
                        cell.startTimeBtn.isUserInteractionEnabled = true
                        cell.endTimeBtn.isUserInteractionEnabled = true
                        cell.maleBtn.isUserInteractionEnabled = true
                        cell.femaleBtn.isUserInteractionEnabled = true
                        cell.maleFemaleBtn.isUserInteractionEnabled = true
                        cell.countTxtField.isUserInteractionEnabled = true
                        
                        cell.closeBtn.isHidden = false
                        cell.viewBookingsBtn.isHidden = true
                        cell.endTimeBtn.tag = indexPath.row
                        cell.endTimeBtn.accessibilityIdentifier = "\(indexPath.section)"
                        cell.endTimeBtn.addTarget(self, action: #selector(endTime_Btn_Action(sender:)), for: .touchUpInside)
                        cell.startTimeBtn.tag = indexPath.row
                        cell.startTimeBtn.accessibilityIdentifier = "\(indexPath.section)"
                        cell.startTimeBtn.addTarget(self, action: #selector(startTime_Btn_Action(sender:)), for: .touchUpInside)
                        
                        cell.maleBtn.tag = indexPath.row
                        cell.maleBtn.accessibilityIdentifier = "\(indexPath.section)"
                        cell.maleBtn.addTarget(self, action: #selector(male_Btn_Action(sender:)), for: .touchUpInside)
                        
                        cell.femaleBtn.tag = indexPath.row
                        cell.femaleBtn.accessibilityIdentifier = "\(indexPath.section)"
                        cell.femaleBtn.addTarget(self, action: #selector(female_Btn_Action(sender:)), for: .touchUpInside)
                        
                        cell.maleFemaleBtn.tag = indexPath.row
                        cell.maleFemaleBtn.accessibilityIdentifier = "\(indexPath.section)"
                        cell.maleFemaleBtn.addTarget(self, action: #selector(maleAndFemale_Btn_Action(sender:)), for: .touchUpInside)
                        
                        cell.capacityCountBtn.tag = indexPath.row
                        cell.capacityCountBtn.accessibilityIdentifier = "\(indexPath.section)"
                        cell.capacityCountBtn.addTarget(self, action: #selector(slotsCountConfigPicker(sender:)), for: .touchUpInside)
                        
                        cell.closeBtn.tag = indexPath.row
                        cell.closeBtn.accessibilityIdentifier = "\(indexPath.section)"
                        cell.closeBtn.addTarget(self, action: #selector(close_Btn_Action(sender:)), for: .touchUpInside)
                    }
                }else{
                    
                }
                return cell
                
            }
            //return cell
            
        }else if tableView == viewBookingListTblView {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ViewAllBookingSlotsTVCell", for: indexPath) as? ViewAllBookingSlotsTVCell {
                
                if self.viewBookingSlotsList.count != 0 {
                    
                    let dict = self.viewBookingSlotsList[indexPath.row] as? NSDictionary
                    
                    if let firstName = dict?.value(forKey: "subFirstName") as? String {
                        
                        if let lastName = dict?.value(forKey: "subLastName") as? String {
                            
                            cell.name_Lbl?.text = "\((firstName).capitalized + " " + (lastName).capitalized)"
                            
                        }else{
                            
                            cell.name_Lbl?.text = (firstName).capitalized
                            
                        }
                        
                    }else{
                        
                        if let lastName = dict?.value(forKey: "subLastName") as? String {
                            
                            cell.name_Lbl?.text = (lastName).capitalized
                            
                        }
                    }
                    
                }else{
                    
                    cell.name_Lbl?.text = "No Bookings Found"
                    
                }
                return cell
                
            }else{
                
            }
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == workoutTblView {
            
            return 110
            
        }
        else if tableView == viewBookingListTblView {
            
            return 40
            
        }else{
            
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == workoutTblView{
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "UserSlotBookingHeaderTVCell") as? UserSlotBookingHeaderTVCell {
                
                cell.selectBtn.tag = section
                if isPublished == true {
                    
                    cell.titleLbl.text = (sectionTitleArr[section] as? String)?.capitalized
                    
                }else{
                    
                    cell.titleLbl.text = sectionTitleArr1[section]
                }
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
        }else{
            
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if tableView == workoutTblView {
            
            if isPublished == true {
                
                return 0
                
            }else{
                
                return 50
            }
            
        }else{
            
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView(frame: CGRect(x: self.workoutTblView.frame.origin.x - 250, y: 0, width: 60, height: 60))
        
        let myButton = UIButton(type: .custom)
        myButton.setImage(UIImage.init(named: "pluseNew"), for: .normal)
        
        if section == 0 { // Can remove if want button for all sections
            
            myButton.addTarget(self, action: #selector(morningSectionPlusBtnAction(_:)), for: .touchUpInside)
            
        }else if section == 1{
            
            myButton.addTarget(self, action: #selector(afternoonSectionPlusBtnAction(_:)), for: .touchUpInside)
            
        }else if section == 2 {
            
            myButton.addTarget(self, action: #selector(eveningSectionPlusBtnAction(_:)), for: .touchUpInside)
            
        }else if section == 3{
            
            myButton.addTarget(self, action: #selector(lateEveningSectionPlusBtnAction(_:)), for: .touchUpInside)
            
        }
        myButton.setTitleColor(UIColor.black, for: .normal) //set the color this is may be different for iOS 7
        myButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40) //set some large width to ur title
        footerView.addSubview(myButton)
        
        return footerView;
        
    }
    
    
    @objc func morningSectionPlusBtnAction(_ sender: UIButton) {
        
        self.tempDict["startTimeHours"] = 06
        self.tempDict["endTimeHours"] = 07
        
        self.selectedSectionIndexArray.add(0)
        self.morningListArray.add(self.tempDict)
        
        //        self.morningListArray = NSMutableArray(array:self.morningListArray.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
        
        self.slotsListAray[0] = (self.morningListArray)
        self.slotsListAray[1] = (self.afternoonListArray)
        self.slotsListAray[2] = (self.eveningListArray)
        self.slotsListAray[3] = (self.lateEveningListArray)
        
        self.workoutTblView.reloadData()
    }
    @objc func afternoonSectionPlusBtnAction(_ sender : UIButton) {
        
        self.tempDict["startTimeHours"] = 12
        self.tempDict["endTimeHours"] = 13

        self.afternoonListArray.add(tempDict)
        self.slotsListAray[0] = (self.morningListArray)
        self.slotsListAray[1] = (self.afternoonListArray)
        self.slotsListAray[2] = (self.eveningListArray)
        self.slotsListAray[3] = (self.lateEveningListArray)
        self.selectedSectionIndexArray.add(1)
        self.workoutTblView.reloadData()
    }
    @objc func eveningSectionPlusBtnAction(_ sender : UIButton) {
        
        self.tempDict["startTimeHours"] = 16
        self.tempDict["endTimeHours"] = 17
        self.eveningListArray.add(tempDict)
        self.slotsListAray[0] = (self.morningListArray)
        self.slotsListAray[1] = (self.afternoonListArray)
        self.slotsListAray[2] = (self.eveningListArray)
        self.slotsListAray[3] = (self.lateEveningListArray)
        self.selectedSectionIndexArray.add(2)
        self.workoutTblView.reloadData()
    }
    @objc func lateEveningSectionPlusBtnAction(_ sender : UIButton) {
        
        self.tempDict["startTimeHours"] = 20
        self.tempDict["endTimeHours"] = 21
        self.lateEveningListArray.add(tempDict)
        self.slotsListAray[0] = (self.morningListArray)
        self.slotsListAray[1] = (self.afternoonListArray)
        self.slotsListAray[2] = (self.eveningListArray)
        self.slotsListAray[3] = (self.lateEveningListArray)
        self.selectedSectionIndexArray.add(3)
        self.workoutTblView.reloadData()
    }
    
    
    @objc func close_Btn_Action(sender: UIButton) {
        
        let section = Int(sender.accessibilityIdentifier!)
        let row = sender.tag
        let dict = self.slotsListAray[section!] as! NSArray
        let tempDict = dict[sender.tag] as? NSDictionary
        
        if section == 0 {
            
            self.morningListArray.remove(tempDict!)
            self.slotsListAray[0] = (self.morningListArray)
            
        }else if section == 1 {
            
            self.afternoonListArray.removeObject(at: row)
            self.slotsListAray[1] = (self.afternoonListArray)
            
        }else if section == 2 {
            
            self.eveningListArray.removeObject(at: row)
            self.slotsListAray[2] = (self.eveningListArray)
            
        }else if section == 3{
            
            self.lateEveningListArray.removeObject(at: row)
            self.slotsListAray[3] = (self.lateEveningListArray)
            
        }
        
        self.workoutTblView.reloadData()
    }
    
    
    @objc func viewAllBookingSlots_Btn_Action(sender: UIButton) {
        
        self.viewBookingListView.isHidden = false
        let section = Int(sender.accessibilityIdentifier!)
        let row = sender.tag
        let dict = self.slotsListAray[section!] as! NSArray
        let tempDict = dict[sender.tag] as? NSDictionary
        
        let tempSelectedDict = NSMutableDictionary()
        tempSelectedDict["gymId"] = tempDict?.value(forKey: "gymId") as? Int
        tempSelectedDict["slotDate"] = tempDict?.value(forKey: "slotDate") as? String
        tempSelectedDict["slotCategory"] = tempDict?.value(forKey: "slotCategory") as? String
        tempSelectedDict["gender"] = tempDict?.value(forKey: "gender") as? Int
        tempSelectedDict["startTimeHours"] = tempDict?.value(forKey: "startTimeHours") as? Int
        tempSelectedDict["startTimeMinutes"] = tempDict?.value(forKey: "startTimeMinutes") as? Int
        tempSelectedDict["endTimeHours"] = tempDict?.value(forKey: "endTimeHours") as? Int
        tempSelectedDict["endTimeMinutes"] = tempDict?.value(forKey: "endTimeMinutes") as? Int
        viewAllBookingSlots(dict: tempSelectedDict)
    }
    
    
    @objc func endTime_Btn_Action(sender: UIButton) {
        
        self.timePickerBgView.isHidden = false
        self.slotCountPickerBgView.isHidden = true
        
        self.datePickerView.backgroundColor = UIColor.lightGray
        
        sections = Int(sender.accessibilityIdentifier!)!
        rows = sender.tag
        self.isTimeStrFrom = "EndTime"
        self.view.endEditing(true)
    }
    
    
    
    @objc func startTime_Btn_Action(sender: UIButton) {
        
        self.timePickerBgView.isHidden = false
        self.slotCountPickerBgView.isHidden = true
        
        self.datePickerView.backgroundColor = UIColor.lightGray
        sections = Int(sender.accessibilityIdentifier!)!
        rows = sender.tag
        self.isTimeStrFrom = "StartTime"
        self.view.endEditing(true)
    }
    
    @objc func capacityCount_Btn_Action(_ sender : UIButton) {
        
        let section = Int(sender.accessibilityIdentifier!)
        let row = sender.tag
        let dict = self.slotsListAray[section!] as! NSArray
        let tempDict = dict[sender.tag] as? NSDictionary
        
        
    }
    
    
    @objc func male_Btn_Action(sender: UIButton) {
        
        let section = Int(sender.accessibilityIdentifier!)
        let row = sender.tag
        let dict = self.slotsListAray[section!] as! NSArray
        var tempDict = dict[sender.tag] as? NSDictionary
        
        var tempDict1 = NSMutableDictionary()
        tempDict1 = tempDict?.mutableCopy() as! NSMutableDictionary
        
        if section == 0 {
            
            tempDict1["gender"] = 0
            self.morningListArray[row] = tempDict1
            //self.slotsListAray.removeObject(at: 0)
            self.slotsListAray[0] = self.morningListArray
            
        }else if section == 1 {
            
            tempDict1["gender"] = 0
            self.afternoonListArray[row] = tempDict1
            //self.slotsListAray.removeObject(at: 1)
            self.slotsListAray[1] = self.afternoonListArray
            
        }else if section == 2 {
            
            tempDict1["gender"] = 0
            self.eveningListArray[row] = tempDict1
            // self.slotsListAray.removeObject(at: 2)
            self.slotsListAray[2] = self.eveningListArray
            
        }else {
            
            tempDict1["gender"] = 0
            self.lateEveningListArray[row] = tempDict1
            //self.slotsListAray.removeObject(at: 3)
            self.slotsListAray[3] = self.lateEveningListArray
            
            
        }
        
        self.workoutTblView.reloadData()
    }
    
    @objc func female_Btn_Action(sender: UIButton) {
        
        let section = Int(sender.accessibilityIdentifier!)
        let row = sender.tag
        let dict = self.slotsListAray[section!] as! NSArray
        var tempDict = dict[sender.tag] as? NSDictionary
        
        var tempDict1 = NSMutableDictionary()
        tempDict1 = tempDict?.mutableCopy() as! NSMutableDictionary
        
        if section == 0 {
            
            tempDict1["gender"] = 1
            self.morningListArray[row] = tempDict1
            //self.slotsListAray.removeObject(at: 0)
            self.slotsListAray[0] = self.morningListArray
            
        }else if section == 1 {
            
            tempDict1["gender"] = 1
            self.afternoonListArray[row] = tempDict1
            //self.slotsListAray.removeObject(at: 1)
            self.slotsListAray[1] = self.afternoonListArray
            
        }else if section == 2 {
            
            tempDict1["gender"] = 1
            self.eveningListArray[row] = tempDict1
            //self.slotsListAray.removeObject(at: 2)
            self.slotsListAray[2] = self.eveningListArray
            
        }else {
            
            tempDict1["gender"] = 1
            self.lateEveningListArray[row] = tempDict1
            //self.slotsListAray.removeObject(at: 3)
            self.slotsListAray[3] = self.lateEveningListArray
            
        }
        
        self.workoutTblView.reloadData()
    }
    
    @objc func maleAndFemale_Btn_Action(sender: UIButton) {
        
        let section = Int(sender.accessibilityIdentifier!)
        let row = sender.tag
        let dict = self.slotsListAray[section!] as! NSArray
        var tempDict = dict[sender.tag] as? NSDictionary
        
        var tempDict1 = NSMutableDictionary()
        tempDict1 = tempDict?.mutableCopy() as! NSMutableDictionary
        
        if section == 0 {
            
            tempDict1["gender"] = 3
            self.morningListArray[row] = tempDict1
            //self.slotsListAray.removeObject(at: 0)
            self.slotsListAray[0] = self.morningListArray
            
        }else if section == 1 {
            
            tempDict1["gender"] = 3
            self.afternoonListArray[row] = tempDict1
            //self.slotsListAray.removeObject(at: 1)
            self.slotsListAray[1] = self.afternoonListArray
            
        }else if section == 2 {
            
            tempDict1["gender"] = 3
            self.eveningListArray[row] = tempDict1
            //self.slotsListAray.removeObject(at: 2)
            self.slotsListAray[2] = self.eveningListArray
            
        }else {
            
            tempDict1["gender"] = 3
            self.lateEveningListArray[row] = tempDict1
            //self.slotsListAray.removeObject(at: 3)
            self.slotsListAray[3] = self.lateEveningListArray
            
        }
        
        self.workoutTblView.reloadData()
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
    
    
    
    @objc func slotsCountConfigPicker(sender: UIButton) {
        
        self.slotCountPickerBgView.isHidden = false
        self.timePickerBgView.isHidden = true
        
        sections = Int(sender.accessibilityIdentifier!)!
        rows = sender.tag
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView == workoutTblView {
            
            return 50
            
        }else{
            
            return 0
            
        }
    }
}



extension UserSlotBookingVC:  FSCalendarDataSource, FSCalendarDelegate {
    
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        self.selectedDate = (self.dateFormatter.string(from: date))
        
        //tempDict.updateValue(self.selectedDate, forKey: "slotDate")
        
        self.timePickerBgView.isHidden = true
        self.slotCountPickerBgView.isHidden = true
        
        getSlotsBasedOnDate(selectedDate: self.selectedDate)
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    
    func getSlotsBasedOnDate(selectedDate:String)  {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")
        
        // let subId = UserDefaults.standard.object(forKey: "subId") as? Int
        
        let params = ["gymId":Defaults.trainer_GYM_ID ?? 0,"slotStartDate":selectedDate,"slotEndDate":selectedDate] as [String : Any]
        
        print("Params == >\(params)")
        
        let urlString = "https://beapis.dieatto.com:8090/dao/gym/slotPublishment/getGymSlots"
        
        Alamofire.request(urlString, method: .put, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json; charset=utf-8","accept": "application/json"]).responseJSON{ (response) in
            
            Services.sharedInstance.dissMissLoader()
            
           
            self.sectionTitleArr.removeAllObjects()
            self.numberOfSlots = 0
            
            if let responseData = response.result.value as? NSArray {
                
                if responseData.count > 0 {
                    
                    self.morningListArray.removeAllObjects()
                    self.afternoonListArray.removeAllObjects()
                    self.eveningListArray.removeAllObjects()
                    self.lateEveningListArray.removeAllObjects()
                    self.slotsListAray.removeAllObjects()
                    
                    for i in 0..<responseData.count {
                        
                        let dict = responseData[i] as? NSDictionary
                        
                        if let slotCategory = dict?.value(forKey: "slotCategory") as? String {
                            
                            if !self.sectionTitleArr.contains(slotCategory + " Slots") {
                                
                                self.sectionTitleArr.add(slotCategory + " Slots")
                                
                            }
                            if slotCategory == "morning" || slotCategory == "Morning" {
                                
                                self.morningListArray.add(dict!)
                                
                            }else if slotCategory == "afternoon" || slotCategory == "Afternoon"{
                                
                                self.afternoonListArray.add(dict!)
                                
                            }else if slotCategory == "evening" || slotCategory == "Evening"{
                                
                                self.eveningListArray.add(dict!)
                                
                            }else if slotCategory == "late-evening" || slotCategory == "Late-Evening"{
                                
                                self.lateEveningListArray.add(dict!)
                                
                            }
                        }
                    }
                    
                    if self.morningListArray.count != 0 {
                        
                        self.numberOfSlots += 1
                        self.slotsListAray.add(self.morningListArray)
                    }
                    
                    if self.afternoonListArray.count != 0 {
                        
                        self.slotsListAray.add(self.afternoonListArray)
                        self.numberOfSlots += 1
                        
                    }
                    if self.eveningListArray.count != 0 {
                        
                        self.slotsListAray.add(self.eveningListArray)
                        self.numberOfSlots += 1
                        
                    }
                    if self.lateEveningListArray.count != 0 {
                        
                        self.slotsListAray.add(self.lateEveningListArray)
                        self.numberOfSlots += 1
                        
                    }
                    self.saveSlotTappedBtn.isHidden = true
                    self.isPublished = true
                    self.copyPreviousDaysSlotTappedBtn.isHidden = true
                    self.copyDate = false
                    self.workoutTblView.reloadData()
                }else{
                    
                self.gettingSlotBookingEmptyListMethod()

                }
            }else{
                
               self.gettingSlotBookingEmptyListMethod()
                
            }
            
        }
    }
    
    func gettingSlotBookingEmptyListMethod() {

            self.numberOfSlots = 4
            self.saveSlotTappedBtn.isHidden = false
            self.isPublished = false
            self.copyPreviousDaysSlotTappedBtn.isHidden = false
            self.copyDate = true
            self.slotsListAray.removeAllObjects()

            for  i in 0..<self.morningListArray.count {
                
                let item = self.morningListArray[i] as? NSDictionary

                var dictMute = NSMutableDictionary()
                
                dictMute = item?.mutableCopy() as! NSMutableDictionary

                dictMute["slotDate"] = self.selectedDate
                self.copyMorningListArray[i] = dictMute
                
            }
            
            for  i in 0..<self.afternoonListArray.count {
                
                let item = self.afternoonListArray[i] as? NSDictionary

                var dictMute = NSMutableDictionary()
                
                dictMute = item?.mutableCopy() as! NSMutableDictionary

                dictMute["slotDate"] = self.selectedDate
                self.copyAfternoonListArray[i] = dictMute
                
            }
            for  i in 0..<self.eveningListArray.count {
                
                let item = self.eveningListArray[i] as? NSDictionary

                var dictMute = NSMutableDictionary()
                
                dictMute = item?.mutableCopy() as! NSMutableDictionary

                dictMute["slotDate"] = self.selectedDate
                self.copyEveningListArray[i] = dictMute
                
            }
            for  i in 0..<self.lateEveningListArray.count {
                
                let item = self.lateEveningListArray[i] as? NSDictionary

                var dictMute = NSMutableDictionary()
                
                dictMute = item?.mutableCopy() as! NSMutableDictionary

                dictMute["slotDate"] = self.selectedDate
                self.copyLateEveningListArray[i] = dictMute
                
            }

            self.morningListArray.removeAllObjects()
            self.afternoonListArray.removeAllObjects()
            self.eveningListArray.removeAllObjects()
            self.lateEveningListArray.removeAllObjects()
                    
           self.workoutTblView.reloadData()
        
    }
    
    
    func viewAllBookingSlots(dict:NSDictionary)  {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")
        
        // let subId = UserDefaults.standard.object(forKey: "subId") as? Int
        
        let params = dict as! [String : Any]
        
        print("Params == >\(print(params))")
        
        let urlString = "https://beapis.dieatto.com:8090/dao/gym/slotPublishment/viewSubscribers"
        
        Alamofire.request(urlString, method: .put, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json; charset=utf-8","accept": "application/json"]).responseJSON{ (response) in
            
            Services.sharedInstance.dissMissLoader()
            
            self.viewBookingSlotsList.removeAllObjects()
            
            if let responseData = response.result.value as? NSDictionary {
                
                if let dictArr = responseData.value(forKey: "slotSubscribers") as? NSArray{
                    
                    self.viewBookingSlotsList = dictArr.mutableCopy() as! NSMutableArray
                    
                    Services.sharedInstance.dissMissLoader()
                    //self.workoutTblView.isHidden = true
                    self.viewBookingListTblView.reloadData()
                }
                
            }else{
                
                self.viewBookingListTblView.reloadData()
                Services.sharedInstance.dissMissLoader()
                
            }
        }
    }
    
    func slotPublishmentAPICall(slotArr:NSMutableArray)  {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")
        
        let tempSelectedDict = NSMutableDictionary()
        
        tempSelectedDict["gymId"] = Defaults.trainer_GYM_ID ?? 0
        tempSelectedDict["publishedSlotDetails"] = slotArr
        
        let params = tempSelectedDict as! [String : Any]
        
        print("Params == >\(params)")
        
        let urlString = "https://beapis.dieatto.com:8090/dao/gym/slotPublishment/save"
        
        Alamofire.request(urlString, method: .put, parameters: params , encoding: JSONEncoding.default, headers: ["Content-Type": "application/json; charset=utf-8","accept": "application/json"]).responseJSON{ (response) in
            
            Services.sharedInstance.dissMissLoader()
            
            let statusCode = response.response?.statusCode
            
            if statusCode == 200 {
                
                self.getSlotsBasedOnDate(selectedDate: self.selectedDate)
                
            }else{
                
                Services.sharedInstance.dissMissLoader()
                
            }
        }
    }
}

extension UserSlotBookingVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // number of session
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return slotsCapacityArray.count // number of dropdown items
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return slotsCapacityArray[row] // dropdown item
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let index = IndexPath(row: rows , section: sections)
        let cell: UserSlotBookingTVCell = self.workoutTblView.cellForRow(at: index) as! UserSlotBookingTVCell
        
        cell.countTxtField.text = slotsCapacityArray[row]
        
        let dict = self.slotsListAray[sections] as! NSArray
        var tempDict = dict[rows] as? NSDictionary
        
        var tempDict1 = NSMutableDictionary()
        tempDict1 = tempDict?.mutableCopy() as! NSMutableDictionary
        
        if sections == 0 {
            
            tempDict1["slotCapacity"] = Int(slotsCapacityArray[row])
            tempDict1["remainingCapacity"] = Int(slotsCapacityArray[row])
            
            self.morningListArray[rows] = tempDict1
            //self.slotsListAray.removeObject(at: 0)
            self.slotsListAray[0] = self.morningListArray
            
        }else if sections == 1 {
            
            tempDict1["slotCapacity"] = Int(slotsCapacityArray[row])
            tempDict1["remainingCapacity"] = Int(slotsCapacityArray[row])
            self.afternoonListArray[rows] = tempDict1
            //self.slotsListAray.removeObject(at: 1)
            self.slotsListAray[1] = self.afternoonListArray
            
        }else if sections == 2 {
            
            tempDict1["slotCapacity"] = Int(slotsCapacityArray[row])
            tempDict1["remainingCapacity"] = Int(slotsCapacityArray[row])
            self.eveningListArray[rows] = tempDict1
            //self.slotsListAray.removeObject(at: 2)
            self.slotsListAray[2] = self.eveningListArray
            
        }else {
            
            tempDict1["slotCapacity"] = Int(slotsCapacityArray[row])
            tempDict1["remainingCapacity"] = Int(slotsCapacityArray[row])
            self.lateEveningListArray[rows] = tempDict1
            //self.slotsListAray.removeObject(at: 3)
            self.slotsListAray[3] = self.lateEveningListArray
            
        }
        
        self.workoutTblView.reloadData()
        
    }
}
