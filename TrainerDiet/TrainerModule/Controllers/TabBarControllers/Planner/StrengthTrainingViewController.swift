//
//  StrengthTrainingViewController.swift
//  TrainerDiet
//
//  Created by RadhaKrishna on 29/05/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit
import Alamofire
import FSCalendar


class WorkoutCategory {
    
    let type : [String]?
    let date : [String]?
    var items : [String:[String:Any]]?
    
    init(activityType:[String],selectDate:[String], items:[String:[String:Any]]) {
        
        self.type = activityType
        self.date = selectDate
        self.items = items
        
    }
}

class StrengthTrainingViewController: UIViewController {
    
    @IBOutlet weak var collectionview:UICollectionView!
    
    var strenghtTrainArray = [[String:Any]]()
    var dictArray = NSMutableArray()
    
    var  selectedFinaList = [String:Any]()
    
    var  selectDict = [[String:Any]]()
    
    var  selectedWorkFinaList = [String:Any]()
    
    var strenghtTrainListArr = NSMutableArray()
    
    var names = [String]()
    
    @IBOutlet var calenderView: FSCalendar!
    @IBOutlet weak var previousTapped:UIButton!
    @IBOutlet weak var nextTappedBtn:UIButton!
    
    @IBOutlet var headerView: UIView!
    
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!
    
    var typeStr = String()
    
    var selectedIndexPaths = [IndexPath]()
    var selectedArray = NSMutableArray()
    var selectedIDsListArray = NSMutableArray()
    
    var fromCardioListArray = NSMutableArray()
    
    var sectionsList = [WorkoutCategory]()
    
    var selectedNamesArray = NSMutableArray()
    
    var selectedDate = String()
    
    var arrData = [String]() // This is your data array
    var arrSelectedIndex = [IndexPath]() // This is selected cell Index array
    var arrSelectedData = [String]() // This is selected cell data array
    
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
        
        let layout = UICollectionViewCenterLayout()
        collectionview.collectionViewLayout = layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        strenghtTrainingHandlerMethod()
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
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        
                
        var selectTypesDict = NSMutableDictionary()
                
        if strenghtTrainListArr.count > 0 {
            
            if arrSelectedData.count == 0 {
                
                showToast(message: "Please select one strenght training")
                
            }else{
                
//                for obj in selectedArray {
//
//                    self.fromCardioListArray.add(obj)
//                }
                print("ListArray is==>\(fromCardioListArray)")
                
                for i in 0..<strenghtTrainListArr.count {
                                    
                    let dict = strenghtTrainListArr[i] as? NSDictionary
                                 
                    if let name = dict?.value(forKey: "activityType") as? String {
                                                
//                        if arrSelectedData.contains(name) {
                            
                            var selectTypsArray = NSMutableArray()
                            
                            if let arry = selectTypesDict.value(forKey: name) as? NSArray {
                                
                                selectTypsArray = NSMutableArray(array: arry)
                                
                                selectTypsArray.add(dict!)
                            }
                            else {
                                
                                selectTypsArray.add(dict!)
                                
                            }
                          
                            selectTypesDict.setValue(selectTypsArray, forKey: name)
                            
//                        }
                                   
                    }
                            
                }
                
                print("dictTypes:\(selectTypesDict)")
               
                let objVC = storyboard?.instantiateViewController(withIdentifier: "StrengthTrainingWorkoutVC") as! StrengthTrainingWorkoutVC
                objVC.typeLevel = typeStr
                objVC.titless = arrSelectedData
                objVC.workoutSubTitlesList = self.strenghtTrainListArr as! [[String : Any]]
                objVC.fromStrenghtOneListArray = fromCardioListArray
                objVC.strenthListArray = strenghtTrainListArr
                objVC.selectedActiviyTypeDict = selectTypesDict
                
                self.navigationController?.pushViewController(objVC, animated: true)
            }
                
            }else{
                
                
            }
            
        }
        
        
        func strenghtTrainingHandlerMethod() {
            
            Services.sharedInstance.customLoader(view: self.view, message: "Please wait")

            let urlString = TrinerUrlPath.sharedInstance.getUrlPath("dao/workoutdata/find/\(typeStr)/Strength_Training")
            
            print("Strength Trainer one Api is ==>\(urlString)")

            Alamofire.request(urlString, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil).responseJSON { response in
                
                if let responseData = response.result.value as? NSArray {
                    
                    Services.sharedInstance.dissMissLoader()
//                    self.strenghtTrainListArr = responseData
                    
                    //print("noDuplicates is:-> \(self.noDuplicates(responseData as! [[String : String]]))")
                    
                    for i in 0..<responseData.count {
                        
                        var dict = responseData[i] as? NSDictionary
                                                
                        var dictMute = NSMutableDictionary()
                        
                        dictMute = dict?.mutableCopy() as! NSMutableDictionary
                        
//                        dictMute.addEntries(from: dict as! [AnyHashable : Any])
                        
                        dictMute.setValue([], forKey: "activityTypeSelectedDate")
                        dictMute.setValue([], forKey: "activityNameSelectedDate")
                        
                        self.strenghtTrainListArr.add(dictMute)
                        
                        if let name = dict?.value(forKey: "activityType") as? String {
                            
                            if !self.names.contains(name) {
                                
                                self.names.append(name)
                            }else{
                            }
                        }
                    }
                    print("filter Type Name Array is ==>\(self.names)")
                    print("filter Type Name wise list Array is ==>\(self.strenghtTrainListArr)")
                    
                    self.collectionview.reloadData()
                }else{
                    Services.sharedInstance.dissMissLoader()

                }
                Services.sharedInstance.dissMissLoader()
            }
        }
        
        func noDuplicates(_ arrayOfDicts: [[String: String]]) -> [[String: String]] {
            var noDuplicates = [[String: String]]()
            var usedNames = [String]()
            for dict in arrayOfDicts {
                if let name = dict["name"], !usedNames.contains(name) {
                    noDuplicates.append(dict)
                    usedNames.append(name)
                }
            }
            return noDuplicates
        }
    }
    extension StrengthTrainingViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return names.count
        }
        
        func handleSelectionBy(tempDict: NSDictionary, cell: StrengthCollectionViewCell, workout_id: String) {
            
            if selectedIDsListArray.contains(workout_id) {
                
                cell.bg_ImgView?.image = UIImage(named: "Rectangle -11")
                
            } else {
                
                cell.bg_ImgView?.image = UIImage(named: "")
            }
            
        }
        
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectioncell", for: indexPath) as? StrengthCollectionViewCell {
                
                let name = names[indexPath.row]
                
                var arr = NSArray()
                                
                for i in 0..<strenghtTrainListArr.count {
                    
                    let dict = strenghtTrainListArr[i] as? NSDictionary
                    
                    if let name1 = dict?.value(forKey: "activityType") as? String {
                                        
                    if name == name1 {
                        
                        arr = (dict?.value(forKey: "activityTypeSelectedDate") as?  NSArray)!
                        
                        break
                        
                        }
                    }
                    
                }
                
                cell.titleLbl.text = name
                cell.mainView.layer.cornerRadius = 15
                cell.mainView.layer.backgroundColor = UIColor.white.cgColor
                cell.clipsToBounds = true
                
                if arrSelectedIndex.contains(indexPath) && arr.contains(self.selectedDate) {
                    
                    cell.bg_ImgView?.image = UIImage(named: "Rectangle -11")
                    cell.titleLbl.textColor = UIColor.white
                }
                else {
                    
                    cell.bg_ImgView?.image = UIImage(named: "Rectangle -10")
                    cell.titleLbl.textColor = UIColor.init(named: "1D5384")//(UIColor.init(named: "1D5384"), for: .normal)

                }
                
                return cell
            }else{
                
                return UICollectionViewCell()
            }
        }
        
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            var valueStr = String()
            
            if names.count > 0 {
                
                valueStr = (names[indexPath.row])
                
            } else {
                
                return CGSize(width: 0, height: 0)
            }
            
            let myText = valueStr
            
            let size = myText.size(withAttributes:[.font: UIFont.systemFont(ofSize:14.0)])
            
            return CGSize(width: size.width + 20 + 20, height: 40)
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            
            let strData = names[indexPath.item]
            
            if arrSelectedIndex.contains(indexPath) {
                
                arrSelectedIndex = arrSelectedIndex.filter { $0 != indexPath}
                arrSelectedData = arrSelectedData.filter { $0 != strData}
                
                for i in 0..<strenghtTrainListArr.count {
                                    
                                    let dict = strenghtTrainListArr[i] as? NSDictionary
                                    
                                    var dictMute = NSMutableDictionary()
                    
                    dictMute = dict?.mutableCopy() as! NSMutableDictionary
                    
                                  
                                    if let name = dict?.value(forKey: "activityType") as? String {
                                                            
                                        if strData == name {
                                            
                                            let arr = dict?.value(forKey: "activityTypeSelectedDate") as! NSArray
                                            
                                            print(arr.count)
                                                                
                                            var selectDateArr = NSMutableArray(array: arr)
//                                            selectDateArr.add(self.selectedDate)
                                            
                                            selectDateArr.remove(self.selectedDate)
                                                                        
                                            dictMute.setValue(selectDateArr, forKey: "activityTypeSelectedDate")
                                            dictMute.setValue(dict, forKey: "activityNameSelectedDate")
                                            
                                        }
                                    }
                                    
                                    strenghtTrainListArr[i] = dictMute
                                    
                                }
            }
                
            else {
                arrSelectedIndex.append(indexPath)
                arrSelectedData.append(strData)
                self.selectedWorkFinaList.removeAll()
                
                for i in 0..<strenghtTrainListArr.count {
                    
                    let dict = strenghtTrainListArr[i] as? NSDictionary
                    
                    var dictMute = NSMutableDictionary()
//                    dictMute.setValue([], forKey: "activityTypeSelectedDate")
//                    dictMute.setValue([], forKey: "activityNameSelectedDate")
                    
                    dictMute = dict?.mutableCopy() as! NSMutableDictionary
                  
                    if let name = dict?.value(forKey: "activityType") as? String {
                                            
                        if strData == name {
                            
                            let dateArr = dict?.value(forKey: "activityTypeSelectedDate") as! NSArray
                            
                            print(dateArr.count)
                                                
                            var selectDateArr = NSMutableArray(array: dateArr)
                            selectDateArr.add(self.selectedDate)
                            dictMute.setValue(selectDateArr, forKey: "activityTypeSelectedDate")
                            
//                            let nameArr = dict?.value(forKey: "activityNameSelectedDate") as! NSArray
                            
//                            var selectNameArr = NSMutableArray(array: nameArr)
                                                      
//                            selectNameArr.add(dict)
                            
//                            dictMute.setValue(selectNameArr, forKey: "activityNameSelectedDate")
                            
                        }
                    }
                    
                    strenghtTrainListArr[i] = dictMute
                    
                }
                
            }
            print("You selected data ==>\(self.strenghtTrainListArr)")
            print("You select dictArray data ==>\(self.selectedFinaList)")
            print("You select temp dictArray data ==>\(self.selectedFinaList)")
            
            
            self.collectionview.reloadData()
        }
        
    }
    
    
    extension StrengthTrainingViewController:  FSCalendarDataSource, FSCalendarDelegate {
        
        
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
            collectionview.reloadData()
            
        }
        
        func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
            print("\(self.dateFormatter.string(from: calendar.currentPage))")
        }
        
}
