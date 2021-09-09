//
//  PaymentDetailsVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 28/05/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit
import PaymentSDK

class PaymentDetailsVC: UIViewController {

    @IBOutlet var headerView: UIView!
    @IBOutlet var cardView: UIView!

    @IBOutlet var name_Lbl: UILabel!
    @IBOutlet var availableCredits_Lbl: UILabel!
    
    
    @IBOutlet var amount_Txt: UITextField!
    @IBOutlet var comments_Txt: UITextField!

    @IBOutlet var paayementButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 2.0)
       // self.cardView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
          
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        //self.tabBarController?.tabBar.tintColor = UIColor.lightGray
                
        
        if let trainerName = UserDefaults.standard.object(forKey: "firstName") as? String {
            
            self.name_Lbl.text = "Hi, \(trainerName)"
            
        }else{
            
            self.name_Lbl.text = ""
        }
      }

@IBAction func makePaymentBtnAction(_ sender: UIButton) {
             
    if amount_Txt.text == "" {
        
        self.showToast(message: "Please Enter Amount")
        
    }else{
        
        self.paymentPutMethod()
    }
}

@IBAction func notificationBtnAction(_ sender: UIButton) {
                 
        let objVC = storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(objVC, animated: true)

    }
    
    
@IBAction func backBtnAction(_ sender: UIButton) {
        
    self.navigationController?.popViewController(animated: true)
    
    }
    
    func paymentPutMethod()  {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")
        
        var subName = String()
        var gender = Int()

        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let startDate = formatter.string(from: date)
        //let endDate = getEndDate(dayDifference: planPeriodStr)
        if let name = UserDefaults.standard.object(forKey: "firstName") as? String {
            subName = name
        }
        let subMobile = UserDefaults.standard.object(forKey: "subMobile") as? Int ?? 0
        let subId = UserDefaults.standard.object(forKey: "subId") as? Int ?? 0
        let trainerID = UserDefaults.standard.object(forKey: "subtrainerId") as? Int ?? 0
        let genderStr = UserDefaults.standard.object(forKey: "gender") as? String ?? ""
        
        if genderStr.capitalized == "Male" {
            gender = 0
        }else{
            gender = 1
        }
        
        let gymID = UserDefaults.standard.object(forKey: "trainerGymId") as? Int ?? 0
        let subEmailId = UserDefaults.standard.object(forKey: "subEmailId") as? String ?? ""
        let subFirstName = UserDefaults.standard.object(forKey: "firstName") as? String ?? ""
        let subLastName = UserDefaults.standard.object(forKey: "lastName") as? String ?? ""

        let  urlString = "https://beapis.dieatto.com:8090/payment/paytm/getChecksum"
        
        var subscriberDetailsObj = ["subId":subId,"subFirstName":subFirstName,"subLastName":subLastName, "subGender":gender,"gymId": gymID, "trainerId": trainerID, "membershipTitle":"miscellaneous", "membershipCategory":"", "planPeriod":"", "startDate": startDate, "endDate":"", "membershipStatus":"","memberName" : subName,"memberTitle":0, "membershipCost":amount_Txt.text!, "paidAmount":amount_Txt.text!,"dueAmount":0,"paymentDate":startDate,"lastPaymentDate":startDate,"paymentStatus":"Paid","authorizeTrainer":1] as [String : Any]
        
        let paramsObj = ["transactionAmount": amount_Txt.text!, "subId":subId, "gymId":gymID, "emailId":"\(subEmailId)","mobileNumber":"\(subMobile)", "comments": comments_Txt.text ?? "", "callbackUrl":"https://beapis.dieatto.com:8090/payment/paytm/updatePaymentStatus","subscriberDetails": subscriberDetailsObj] as [String : Any]

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
}

extension PaymentDetailsVC : PGTransactionDelegate,UIViewControllerTransitioningDelegate {
    
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
    func didCancelTrasaction(_ controller : PGTransactionViewController) {
        controller.navigationController?.popViewController(animated: true)
    }
    //Called when a required parameter is missing.
    func errorMisssingParameter(_ controller : PGTransactionViewController, error : NSError?) {
        controller.navigationController?.popViewController(animated: true)
    }
}
