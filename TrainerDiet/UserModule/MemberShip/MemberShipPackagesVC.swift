//
//  MemberShipPackagesVC.swift
//  TrainerDiet
//
//  Created by Sunkpo on 19/11/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit
import Alamofire
import PaymentSDK

// fight your battles with prayer & win your battles with your faith
class MemberShipPackagesVC: UIViewController {
    
    @IBOutlet var headerShadowView: UIView!
    @IBOutlet var membershipListTbl: UITableView!
    @IBOutlet var userNamelbl: UILabel!
    
    @IBOutlet var offLinePaymentBtn: UIButton!
    @IBOutlet var onLinePaymentBtn: UIButton!

    var membershipList = NSArray()
    var checkedRow:Int!
    
    var membershipSelectStatus: Bool = false
    var selectMembershipList = NSDictionary()
    
    var paymentMemberShipDetails = NSDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerShadowView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 2.0);
        
        if let trainerName = UserDefaults.standard.object(forKey: "firstName") as? String {
            
            self.userNamelbl.text = "Hi,\(trainerName)"
            
        }else{
            
            self.userNamelbl.text = ""
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        getPaidMembershipPackagesDeatils()
        self.getMembershipPackagesMethod()
        
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func offlinePayBtnAction(_ sender: UIButton) {
        if self.membershipSelectStatus == false {
            self.showToast(message: "Please select at least one membership")
        }else{
            payOfflinePutMethod()
        }
    }
    
    @IBAction func onlinePayBtnAction(_ sender: UIButton) {
        
        self.payOnlinePutMethod()
        
    }
    

    
    func getEndDate(dayDifference: Int) -> String {
        
      var dayComponent = DateComponents()
      dayComponent.day = dayDifference // For removing one day (yesterday): -1
      let theCalendar = Calendar.current
      let nextDate = theCalendar.date(byAdding: dayComponent, to: Date())
      
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      let someDateTime = formatter.string(from: nextDate!)
      return someDateTime
    }
    
    func getMembershipPackagesMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")
        
        var trainerID = Int()
        var gender = Int()

        if let id = UserDefaults.standard.object(forKey: "trainerGymId") as? Int {
            
            trainerID = id
            
        }else{
            
        }
        
        if (UserDefaults.standard.object(forKey: "gender") as? String)?.uppercased() == "MALE" {

            gender = 0
            
        }else{
            
            gender = 1
            
        }
        
        let urlString = TrinerUrlPath.sharedInstance.getUrlPath("membershipplanner/getMembershipPlannerByGymIdAndGender/\(trainerID)/\(gender)")
        
        Alamofire.request(urlString, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            if let responseData = response.result.value as? NSArray {
                
                Services.sharedInstance.dissMissLoader()
                
                self.membershipList = responseData
                self.membershipListTbl.reloadData()
                print("responseData is ==>\(responseData)")
            }else{
                
                Services.sharedInstance.dissMissLoader()
                
            }
        }
    }
    
    func getPaidMembershipPackagesDeatils() {
                
        var gymID = Int()
        var subId = Int()

        if let id = UserDefaults.standard.object(forKey: "trainerGymId") as? Int {
            
            gymID = id
            
        }else{
            
        }
        
       if let Id = UserDefaults.standard.object(forKey: "subId") as? Int {
            subId = Id
            
        }else{
            
        }
        
        let urlString = TrinerUrlPath.sharedInstance.getUrlPath("membershipdetails/subId/\(gymID)/\(subId)")
        
        Alamofire.request(urlString, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil).responseJSON { response in
            print("response")
            
            if let responseData = response.result.value as? NSArray {
                Services.sharedInstance.dissMissLoader()
                if responseData.count > 0 {
                    if let dict = responseData[0] as? NSDictionary {
                    self.paymentMemberShipDetails = dict
                    }
                }else{
                    
                }
            }else{
                if let dict = response.result.value as? NSDictionary {
                self.paymentMemberShipDetails = dict
                }
                Services.sharedInstance.dissMissLoader()
            }
            
            print("paymentMemberShipDetails is ==>\(self.paymentMemberShipDetails)")
        }
    }
    
    
    //Mark:- Pay Offline API Method
    func payOfflinePutMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Submitted")
        var subID = Int()
        var params = [String:Any]()
        let urlString = TrinerUrlPath.sharedInstance.getUrlPath("membershipdetails/save")
        
        let gymID = self.selectMembershipList.value(forKey: "gymId") as? Int ?? 0
        let trainerID = self.selectMembershipList.value(forKey: "trainerId") as? Int ?? 0
        //let subId = self.selectMembershipList.value(forKey: "subId") as? Int ?? 0
        let membershipTitle = self.selectMembershipList.value(forKey: "membershipTitle") as? String ?? ""
        let membershipCategoryStr = self.selectMembershipList.value(forKey: "membershipCategory") as? String ?? ""
        let planPeriodStr = self.selectMembershipList.value(forKey: "planPeriod") as? Int ?? 0
        
        if let Id = UserDefaults.standard.object(forKey: "subId") as? Int {
            subID = Id
        }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let startDate = formatter.string(from: date)
        let endDate = getEndDate(dayDifference: planPeriodStr)
        
        //        "gymId":1,
        //        "trainerId":1,
        //        "subId":2,
        //        "membershipTitle":"Annual Membership",
        //        "membershipCategory":"Personal",
        //        "planPeriod":365,
        //        "startDate":"2020-10-31"
        //        "endDate":"2021-10-31"
        
        params = ["gymId": gymID, "trainerId": trainerID, "subId": subID, "membershipTitle":membershipTitle, "membershipCategory": membershipCategoryStr, "planPeriod":planPeriodStr, "startDate": startDate, "endDate":endDate]
        
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
            
            print("response is ====> \(response)")
            let statusCode = response?.value(forKey: "status") as? Int
            if statusCode == 500 {
                
                
            }else{
                
                AlertSingletanClass.sharedInstance.validationAlert(title: "", message: "Successfully", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                    
                    self.popBack(toControllerType: HomeVC.self)
                })
                
            }
        }
        )
    }
    
    func payOnlinePutMethod()  {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")
        
        var subName = String()
        var subID = Int()
        var genderID = Int()

        let trainerID = self.selectMembershipList.value(forKey: "trainerId") as? Int ?? 0
        let membershipTitle = self.selectMembershipList.value(forKey: "membershipTitle") as? String ?? ""
        let membershipCategoryStr = self.selectMembershipList.value(forKey: "membershipCategory") as? String ?? ""
        let planPeriodStr = self.selectMembershipList.value(forKey: "planPeriod") as? Int ?? 0
        let gymID = self.selectMembershipList.value(forKey: "gymId") as? Int ?? 0
        let finalPrice = self.selectMembershipList.value(forKey: "finalPrice") as? Int ?? 0
        
       // let subId = self.selectMembershipList.value(forKey: "subId") as? Int ?? 0
       // let gender = self.selectMembershipList.value(forKey: "gender") as? Int ?? 0

        if let Id = UserDefaults.standard.object(forKey: "subId") as? Int {
            subID = Id
        }
        if (UserDefaults.standard.object(forKey: "gender") as? String)?.uppercased() == "MALE" {
            genderID = 0
        }else{
            genderID = 1
        }

        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let startDate = formatter.string(from: date)
        let endDate = getEndDate(dayDifference: planPeriodStr)
        if let name = UserDefaults.standard.object(forKey: "firstName") as? String {
            subName = name
        }
        let subMobile = UserDefaults.standard.object(forKey: "subMobile") as? Int ?? 0
        let subEmailId = UserDefaults.standard.object(forKey: "subEmailId") as? String ?? ""
        let subFirstName = UserDefaults.standard.object(forKey: "firstName") as? String ?? ""
        let subLastName = UserDefaults.standard.object(forKey: "lastName") as? String ?? ""

        let  urlString = "https://beapis.dieatto.com:8090/payment/paytm/getChecksum"
        
        var subscriberDetailsObj = ["subId":subID,"subFirstName":subFirstName,"subLastName":subLastName, "subGender":genderID,"gymId": gymID, "trainerId": trainerID, "membershipTitle":membershipTitle, "membershipCategory":membershipCategoryStr, "planPeriod":planPeriodStr, "startDate": startDate, "endDate":endDate, "membershipStatus":"Existing","memberName" : subName,"memberTitle":0, "membershipCost":finalPrice, "paidAmount":finalPrice,"dueAmount":0,"paymentDate":startDate,"lastPaymentDate":startDate,"paymentStatus":"Paid","authorizeTrainer":1] as [String : Any]
        let paramsObj = ["transactionAmount": finalPrice, "subId":subID, "gymId":gymID, "emailId":"\(subEmailId)","mobileNumber":"\(subMobile)", "comments":"REGULAR", "callbackUrl":"https://beapis.dieatto.com:8090/payment/paytm/updatePaymentStatus","subscriberDetails": subscriberDetailsObj] as [String : Any]

        print("Params == >\(paramsObj)")

        TrinerAPI.sharedInstance.TrainerService_put_with_header(paramsDict: paramsObj as NSDictionary, urlPath:urlString,onCompletion: {
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
            let dataDict = dict_responce(dict: response)
            
            print("response is == >\(dataDict)")
            
            let mobileNum = dataDict.value(forKey: "mobileNumber") as? String ?? ""
            let email = dataDict.value(forKey: "emailId") as? String ?? ""
            let channelID = dataDict.value(forKey: "channelId") as? String ?? ""
            let industryTypeID = dataDict.value(forKey: "industryType") as? String ?? ""
            let webSite = dataDict.value(forKey: "webSite") as? String ?? ""
            let txt_Amount = dataDict.value(forKey: "transactionAmount") as? String ?? ""
            let callbackURL = dataDict.value(forKey: "callbackUrl") as? String ?? ""
            let orderID = dataDict.value(forKey: "orderId") as? String ?? ""
            let MID = dataDict.value(forKey: "merchantId") as? String ?? ""
            let checkSUM = dataDict.value(forKey: "checkSum") as? String ?? ""
            let subId = dataDict.value(forKey: "subId") as? String ?? ""

            let paytmParams = ["ORDER_ID":orderID,"MID":MID,"CUST_ID": subId,"MOBILE_NO": mobileNum,"EMAIL": email,"CHANNEL_ID":channelID,"INDUSTRY_TYPE_ID":industryTypeID,"WEBSITE": webSite,"TXN_AMOUNT": txt_Amount,"CALLBACK_URL":callbackURL ,"CHECKSUMHASH":checkSUM];
                                                        
            print("paytmParams is === \(paytmParams)")
            if let mutableDataDict = dataDict.mutableCopy() as? NSMutableDictionary {
                
                if let ORDER_ID = dataDict.value(forKeyPath: "orderId") as? String {
                    
                    if let MID = dataDict.value(forKeyPath: "merchantId") as? String {
                        
                        if let CHECKSUMHASH = dataDict.value(forKeyPath: "checkSum") as? String {
                            
                            if let INDUSTRY_TYPE_ID = dataDict.value(forKeyPath: "industryType") as? String {
                                
                                if let WEBSITE = dataDict.value(forKeyPath: "webSite") as? String {
                                                                                    
                                    let txnController = PGTransactionViewController.init(transactionParameters: paytmParams as! [String : Any])
                                    
                                    txnController.delegate = self
                                    txnController.transitioningDelegate = self
                                    txnController.title = "DIEATTO WELLNESS PRIVATE LIMITED"
                                    txnController.serverType = ServerType.eServerTypeProduction
                                    txnController.merchant = PGMerchantConfiguration.defaultConfiguration()
                                    txnController.merchant?.checksumGenerationURL = CHECKSUMHASH
                                    txnController.merchant?.merchantID = MID
                                    txnController.merchant?.checksumValidationURL = CHECKSUMHASH + ORDER_ID
                                    txnController.isLoggingEnabled = true
                                    txnController.merchant?.website = WEBSITE
                                    txnController.merchant?.industryID = INDUSTRY_TYPE_ID
                                    self.navigationController?.pushViewController(txnController, animated: true)
                                }
                            }
                        }
                    }
                }
            }else{
                
                print("response is == >\(dataDict)")

            }
            
        }
        )
    }
    
    
    func payWithPaytmResponseHandler(params : NSDictionary) {
                
        let urlString = "https://beapis.dieatto.com:8090/payment/paytm/updatePaymentStatus"
        
        TrinerAPI.sharedInstance.TrinerService_post(paramsDict: params, urlPath:urlString,onCompletion: {
            (response,error) -> Void in
            if let networkError = error {
                
               // AppDelegate().removeCustomLoader(self)
                if (networkError.code == -1009) {
                    print("No Internet \(String(describing: error))")
                    //AppDelegate().removeCustomLoader(self)
                    AlertSingletanClass.sharedInstance.validationAlert(title: "No Internet", message: "", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                    })
                    
                    return
                }
            }
            
            if response == nil
            {
                //AppDelegate().removeCustomLoader(self)
                return
            }else {
                
                //AppDelegate().removeCustomLoader(self)

                let dict = dict_responce(dict: response)
                
                print(dict)
                
                if status_Check(dict: dict) {
                    
                    if let err_code = dict.value(forKeyPath: "err_code") as? String {
                        
                        self.setupPopupView(status: "TXN_SUCCESS", message: err_code)
                    }
                    
                } else {
                    
                    if let err_code = dict.value(forKeyPath: "err_code") as? String {
                        
                        self.setupPopupView(status: "TXN_FAILURE", message: err_code)
                    }
                }
            }
        })
    }
    
    let popupView = Bundle.main.loadNibNamed("PopupView", owner: self, options: nil)?[0] as! PopupView
    
    func setupPopupView(status: String, message: String) {
        
        popupView.frame = self.view.frame
        
        self.view.addSubview(popupView)
        
        if status == "TXN_SUCCESS" {
                        
            popupView.setupData(titleStr: "PaymentTransactionStatus", statusSucess: true, statusStr: "Thankyou", messageStr: message, doneBtnTitleStr: "  \("Ok_Btn")  ")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [unowned self] in
            
                if self.popupView.popupDelegate != nil {
                    
                    self.tappingButtonHandlerMethod(statusSucess: true)
                }
            }
            
        } else {
                        
            popupView.setupData(titleStr: "PaymentTransactionStatus", statusSucess: false, statusStr: "PaymentFailed", messageStr: message, doneBtnTitleStr: "  \("Ok_Btn")  ")
        }
        
        popupView.popupDelegate = self
    }
    
    func GetFormattedDate(dateStr : String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateStr)
        
        dateFormatter.dateFormat = "MMMM dd yyyy"
        let istDate = dateFormatter.string(from: date!)
    
        return istDate
    }
}

extension MemberShipPackagesVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    //Mark:- To Print Count for Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return membershipList.count
    }
    
    
    //Mark:- To Display data for UIPart
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MemberShipTVCell", for: indexPath) as?
            MemberShipTVCell {
            
            let dict = membershipList[indexPath.row] as! NSDictionary
            cell.selectionStyle = .none
            cell.setCellData(resp_Dict: dict)
            
            if self.paymentMemberShipDetails.value(forKey: "membershipTitle") as? String == dict.value(forKey: "membershipTitle") as? String {
                cell.bgView.backgroundColor = UIColor.init(hexFromString: "79A62A")
                cell.bookNowBtn.setTitle("Completed", for: .normal)
            }else{
                if indexPath.row == checkedRow {
                    cell.bgView.backgroundColor = UIColor.init(hexFromString: "9A9A9A")
                }else{
                    cell.bgView.backgroundColor = UIColor.init(hexFromString: "D5F7F6")
                }
                cell.bookNowBtn.setTitle("Open", for: .normal)
            }
            
            cell.bookNowBtn.tag = indexPath.row
            cell.bookNowBtn.addTarget(self, action: #selector(checkBox_BtnAction(sender:)), for: .touchUpInside)
            
            return cell
            
        }else{
            
            return UITableViewCell()
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedPackage(index: indexPath.row)
    }
    func selectedPackage(index: Int) {
        
        checkedRow = index
        let dict = self.membershipList[index] as! NSDictionary
        
        if paymentMemberShipDetails.count > 0 {
            
            let dateStr = self.paymentMemberShipDetails.value(forKey: "endDate") as? String ?? ""
            let endDateStr = self.GetFormattedDate(dateStr: dateStr)
            if self.paymentMemberShipDetails.value(forKey: "membershipTitle") as? String == dict.value(forKey: "membershipTitle") as? String {
                membershipSelectStatus = false
                let actionSheetController: UIAlertController = UIAlertController(title: "" , message: "You will gym subscription will expire on \(endDateStr)", preferredStyle: .alert)
                let cancelAction : UIAlertAction = UIAlertAction(title: "OK", style: .cancel) {
                    action -> Void in
                }
                actionSheetController.addAction(cancelAction)
                self.present(actionSheetController, animated: true, completion: nil)
                self.offLinePaymentBtn.isHidden = true
                self.onLinePaymentBtn.isHidden = true

            }else{
                self.offLinePaymentBtn.isHidden = false
                self.onLinePaymentBtn.isHidden = false
                self.selectMembershipList = dict
                membershipSelectStatus = true
            }
        }else{
            self.offLinePaymentBtn.isHidden = false
            self.onLinePaymentBtn.isHidden = false
            self.selectMembershipList = dict
            membershipSelectStatus = true
        }
        self.membershipListTbl.reloadData()
        
    }
    
    @objc func checkBox_BtnAction(sender: UIButton) {
        selectedPackage(index: sender.tag)
    }
}

extension MemberShipPackagesVC : PGTransactionDelegate,UIViewControllerTransitioningDelegate {
    
    //this function triggers when transaction gets finished
    func didFinishedResponse(_ controller: PGTransactionViewController, response responseString: String) {
        
        print("After Paytm Payment Response ===\(responseString)")
        
       // controller.navigationController?.popViewController(animated: true)
        
        if let data = responseString.data(using: .utf8) {
            
            do {
                
                if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    //self.payWithPaytmResponseHandler(params: jsonDict)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    //this function triggers when transaction gets cancelled
    func didCancelTrasaction(_ controller: PGTransactionViewController) {
        
        print("User cancelled the trasaction")
        controller.navigationController?.popViewController(animated: true)
    }
    
    //Called when a required parameter is missing.
    func errorMisssingParameter(_ controller: PGTransactionViewController, error: NSError?) {
        
        print(error!.localizedDescription)
        controller.navigationController?.popViewController(animated: true)
    }
    
    func didFinishCASTransaction(_ controller: PGTransactionViewController!, response: [AnyHashable : Any]!) {
         print("my response isis : \(response)" )

    }

    // On Successful Payment
    func didSucceedTransaction(controller: PGTransactionViewController, response: [NSObject : AnyObject]) {
        print(response)
        print("Response - \(response)")
        //removeController  - Close PayTM Controller here using dismiss or pop controller methods
    }

    func didFinishCASTransaction(controller: PGTransactionViewController, response: [NSObject : AnyObject]) {
        print(response);
    }
    
    
}

extension MemberShipPackagesVC : PopupViewDelegate {
    
    func tappingButtonHandlerMethod(statusSucess: Bool) {
        
        self.popupView.removeFromSuperview()
        
        self.popupView.popupDelegate = nil
        
        if statusSucess {

            self.showToast(message: "manohar sucsess")
        } else {
            
            self.showToast(message: "manohar failed")

            // Failed
        }
    }
}
