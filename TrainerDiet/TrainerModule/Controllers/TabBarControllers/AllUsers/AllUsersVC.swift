//
//  AllUsersVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 28/05/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

struct SubCategory {
    
    static var subID = Int()
    static var isFromPersonal = String()
    static var genderType = String()
    static var levelType = String()

}
class AllUsersVC: UIViewController {
    
    @IBOutlet var allUserTable: UITableView!
    @IBOutlet var searchTxt: UITextField!

    @IBOutlet var title_Lbl1: UILabel!
    @IBOutlet var title_Lbl2: UILabel!

    @IBOutlet var rating_view: UIView!
    @IBOutlet var planer_View: UIView!
    @IBOutlet var nextBtn_View: UIView!
    @IBOutlet var feedbackslider: UISlider!
    @IBOutlet var searchView: UIView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var headerView1: UIView!

    var isFrom = String()
    
    var userOnBoardingListArray = NSArray()
    var checkedRow:Int!
    //var levelType = String()
    //var genderType = String()
    var feedbackRating = Int()
    
    var selectedArray = NSMutableArray()
    var selectedIDsListArray = NSMutableArray()
    var finalSelectedBulkArray = NSMutableArray()
    
    var clientListArrModel = [SearchAllClientListModel]()
    var clientListArrModel1 = [SearchAllClientListModel]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 5.0)
        self.searchView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 15.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.title_Lbl1.text = ""
        self.title_Lbl2.text = ""

        if let gymName = UserDefaults.standard.object(forKey: "gymName") as? String {
            
            self.title_Lbl1.text = gymName
            self.title_Lbl2.text = gymName

        }else{
            
            self.title_Lbl1.text = "NA"
            self.title_Lbl2.text = "NA"

        }
        
        self.getAllUserHandlerMethod()
        
        if isFrom == "Feedback" {
            
            self.planer_View.isHidden = true
            self.rating_view.isHidden = true
            self.nextBtn_View.isHidden = false
            self.nextBtn_View.isUserInteractionEnabled = true
            
        } else if isFrom == "PersonalPlanner" {
            
            self.planer_View.isHidden = false
            self.rating_view.isHidden = true
            self.nextBtn_View.isHidden = true
            self.headerView.isHidden = true
            self.headerView1.isHidden = false
            self.nextBtn_View.isUserInteractionEnabled = false
            self.tabBarController?.tabBar.isHidden = true

        }
            
        else{
            self.planer_View.isHidden = true
            self.rating_view.isHidden = true
            self.nextBtn_View.isHidden = true
            self.headerView.isHidden = false
            self.headerView1.isHidden = true
            self.nextBtn_View.isUserInteractionEnabled = false
            self.tabBarController?.tabBar.isHidden = false

        }
        
    }
    
    
    @IBAction func feedbackSliderBtnACtion(_ sender: Any) {
        
        self.feedbackRating = Int(feedbackslider.value)
        
        
    }
    
    
    @IBAction func seach_ActionTxt(_ sender: UITextField) {
        
        if sender.text == "" {
            
          clientListArrModel1 = clientListArrModel
        }
        else{
            
            let serchstring = sender.text
            clientListArrModel1 = clientListArrModel.filter({(categoryName: SearchAllClientListModel) in
                return ((categoryName.subscriberFirstName.lowercased().range(of: (serchstring!.lowercased())) != nil) || (categoryName.subscriberEmail.lowercased().range(of: (serchstring!.lowercased())) != nil))
            })
        }
       
        allUserTable.reloadData()
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        
        
        if isFrom == "Feedback" {
            
            if self.selectedArray.count == 0 {
                
                showToast(message: "Please select one subscriber")
                
            }else if self.feedbackRating == 0 {
                
                showToast(message: "Please select feedback rating")
                
            }else if self.selectedArray.count == 1  {
                
                var subID = Int()
                
                for obj in selectedArray {
                    
                    if let dict = obj as? NSDictionary {
                        
                        subID = dict.value(forKey: "subId")  as? Int ?? 0
                    }
                }
                self.trainerFeedbackHandlerMethod(subID: subID, feedbackRating: self.feedbackRating)
                
            }else{
                
                self.finalSelectedBulkArray.removeAllObjects()
                
                for obj in selectedArray {
                    
                    var tempDict = NSMutableDictionary()
                    
                    if let dict = obj as? NSDictionary {
                        
                        tempDict["subId"] = dict.value(forKey: "subId")  as? Int ?? 0
                        tempDict["trainerId"] = dict.value(forKey: "trainerId")  as? Int ?? 0
                        tempDict["rating"] = self.feedbackRating
                        self.finalSelectedBulkArray.add(tempDict)
                    }
                    
                }
                print("final select array is ==\(self.finalSelectedBulkArray)")
                self.trainerBulkFBHandlerMethod()
            }
            
        }else{
            
        }
    }
    
    @IBAction func playNowBtnAction(_ sender: UIButton) {
        
        SubCategory.isFromPersonal = "Personal"
        let objVC = storyboard?.instantiateViewController(withIdentifier: "CardioActivityVC") as! CardioActivityVC
        objVC.genderTypeStr = SubCategory.genderType
        objVC.cardioLevelType = "\(SubCategory.levelType)/\(SubCategory.genderType)"
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    @IBAction func notificationBtnAction(_ sender: UIButton) {
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        
        self.navigationController?.pushViewController(objVC, animated: true)


    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func getAllUserHandlerMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")

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
                
                if let onBoardingList = dict.value(forKey: "subscriberOnboarding") as? [[String: Any]] {
                    
                    self.clientListArrModel.removeAll()
                    self.clientListArrModel1.removeAll()
                    self.searchTxt.text?.removeAll()

                                            
                        for list in onBoardingList {
                            let object = SearchAllClientListModel(data: list as NSDictionary)
                            self.clientListArrModel.append(object)
                        }
                        self.clientListArrModel1 = self.clientListArrModel
                        self.allUserTable.reloadData()

                    self.allUserTable.reloadData()
                }
                
            }
        })
    }
    
    
    func trainerFeedbackHandlerMethod(subID: Int, feedbackRating: Int) {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Done")
        
        let urlString = "https://beapis.dieatto.com:8090/dao/trainerfeedback/update/\(subID)/\(feedbackRating)"
        
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
                let dict = dict_responce(dict: response)
                
            }
        })
    }
    
    func trainerBulkFBHandlerMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Done")
        
        let urlString = "https://beapis.dieatto.com:8090/dao/trainerfeedback/bulkupdate"
        
        let params = ["trainerFeedbacks": self.finalSelectedBulkArray]
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
            
            if response == nil
            {
                Services.sharedInstance.dissMissLoader()
                return
            }else
            {
                let dict = dict_responce(dict: response)
                
            }
        })
    }
}

extension AllUsersVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if clientListArrModel1.count > 0 {
            
            return clientListArrModel1.count
            
        }else{
            
            return 0
            
        }
    }
    
    func handleSelectionBy(tempDict: NSDictionary, cell: AllUserTVCell, subId: Int) {
        
        if selectedIDsListArray.contains(subId) {
            
            cell.checkBox.setImage(UIImage(named: "checkbox-active"), for: .normal)
            cell.selectionStyle = .default
            
        } else {
            
            cell.checkBox.setImage(UIImage(named: "checkbox-4"), for: .normal)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AllUserTVCell", for: indexPath) as? AllUserTVCell {
            
            if clientListArrModel1.count > 0 {

                let nameStr = clientListArrModel1[indexPath.row].subscriberFirstName + " " + clientListArrModel1[indexPath.row].subscriberLastName
                
                let gender = clientListArrModel1[indexPath.row].subscriberGender ?? 0
                let subId = clientListArrModel1[indexPath.row].id ?? 0

                cell.downloadingImageFromServer(id: "\(subId)", genderID: gender)
                cell.name_Lbl.text = nameStr
                cell.email_Lbl.text = clientListArrModel1[indexPath.row].subscriberEmail

                let subProfileDict = clientListArrModel1[indexPath.row].subscriberProfile

                let goal = subProfileDict?.value(forKey: "subDietProfType") as? Int
                    
                cell.goalLbl_Btn.isHidden = false
                
                if goal == 1 {

                    cell.goalLbl_Btn.setTitle("WL", for: .normal)
                    
                }else if goal == 2 {
                    
                    cell.goalLbl_Btn.setTitle("WG", for: .normal)
                    
                }else if goal == 3 {
                    
                    cell.goalLbl_Btn.setTitle("MG", for: .normal)
                    
                }else if goal == 4{
                    
                    cell.goalLbl_Btn.setTitle("F", for: .normal)

                }else{
                    
                    cell.goalLbl_Btn.isHidden = true
                    
                }
                
                    if self.isFrom == "Feedback" {
                        
//                    let id = clientListArrModel1[indexPath.row].id
//                    let tempDict = clientListArrModel1[indexPath.row] as? [String: Any]
//
                        //handleSelectionBy(tempDict: tempDict! as NSDictionary, cell: cell, subId: "\(id)")
                        
                    }else{
                        
                        if indexPath.row == checkedRow {
                            
                            cell.checkBox.setImage(UIImage(named: "checkbox-active"), for: .normal)
                            
                        } else {
                            
                            cell.checkBox.setImage(UIImage(named: "checkbox-4"), for: .normal)
                        }
                        
                    }
                
                cell.checkBox.tag = indexPath.row
                cell.checkBox.addTarget(self, action: #selector(checkBox_BtnAction(sender:)), for: .touchUpInside)
                
                cell.selectionStyle = .none
                
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
        
        let tempDict = clientListArrModel1[indexPath.row]
        let objVC = storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        objVC.isFrom = "AllUser"
        
        objVC.detailsDict = [tempDict]
        
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    @objc func checkBox_BtnAction(sender: UIButton) {
        
        checkedRow = sender.tag
        SubCategory.subID = clientListArrModel1[sender.tag].id
        SubCategory.levelType = clientListArrModel1[sender.tag].subscriberFitnessLevel

        let gender = clientListArrModel1[sender.tag].subscriberGender
        if gender == 1 {
        
            SubCategory.genderType = "Female"
            
        }else{
        
            SubCategory.genderType = "Male"
        
            }
        
                        
        
//        if let tempDict = userOnBoardingListArray[sender.tag] as? NSDictionary {
//
//            if isFrom == "Feedback" {
//
//                if let subId = tempDict.value(forKey: "id") as? Int {
//
//                    if selectedIDsListArray.contains(subId) {
//
//                        var tempPlyrDict = NSDictionary()
//
//                        for obj in selectedArray {
//
//                            if let objDict = obj as? NSDictionary {
//
//                                if let sub_Code_Id = objDict.value(forKey: "subId") as? Int {
//
//                                    if subId == sub_Code_Id {
//
//                                        tempPlyrDict = objDict
//
//                                        selectedArray.remove(tempPlyrDict)
//
//                                        break
//                                    }
//                                }
//                            }
//                        }
//
//                        selectedIDsListArray.remove(subId)
//
//                    } else {
//
//                        let tempSelectedDict = NSMutableDictionary()
//
//                        tempSelectedDict["subId"] = tempDict.value(forKey: "id")
//                        tempSelectedDict["trainerId"] = tempDict.value(forKey: "trainerId")
//
//                        selectedArray.add(tempSelectedDict)
//                        selectedIDsListArray.add(subId)
//                    }
//                }
//
//            }else{
//
//                checkedRow = sender.tag
//
//                if let id = tempDict.value(forKey: "id") as? Int {
//
//                    SubCategory.subID = id
//                }
//                if let level = tempDict.value(forKey: "subscriberFitnessLevel") as? String {
//
//                    SubCategory.levelType = level
//                }
//                if tempDict.value(forKey: "subscriberGender") as? Int == 1 {
//
//                    SubCategory.genderType = "Female"
//                }else{
//
//                    SubCategory.genderType = "Male"
//
//                }
//
//            }
//        }
        self.allUserTable.reloadData()
        
    }
}
