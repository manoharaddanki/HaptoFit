//
//  UserPaymentVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 17/07/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

class UserPaymentVC: UIViewController {

    @IBOutlet var headerView: UIView!
    @IBOutlet var cardView: UIView!

    @IBOutlet var name_Lbl: UILabel!
    @IBOutlet var shortName_Lbl: UILabel!
    @IBOutlet var availableCredits_Lbl: UILabel!
    @IBOutlet var amount_Txt: UITextField!
    @IBOutlet var selectAmountBtn1: UIButton!
    @IBOutlet var selectAmountBtn2: UIButton!
    @IBOutlet var selectAmountBtn3: UIButton!
    @IBOutlet var paymentColloectionView: UICollectionView!
    
    @IBOutlet var creditCardBtn: UIButton!
    @IBOutlet var debitCardBtn: UIButton!
    @IBOutlet var paytmBtn: UIButton!
    @IBOutlet var phonePayBtn: UIButton!
    @IBOutlet var amazonPayBtn: UIButton!
    @IBOutlet var googlePayBtn: UIButton!

    @IBOutlet var paymentButton: UIButton!
    
    var titleArr = ["Credit Card","Debit Card","Amazon Pay","Paytm","Phone Pay","Google Pay"]
    var selectIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 2.0)

    }
    
    override func viewWillAppear(_ animated: Bool) {
          
          self.navigationController?.navigationBar.isHidden = true
          self.tabBarController?.tabBar.isHidden = true

        if let trainerName = UserDefaults.standard.object(forKey: "firstName") as? String {
            
            self.name_Lbl.text = "Hi, \(trainerName)"
            
        }else{
            
            //self.name_Lbl.text = "Hi"

        }
      }

@IBAction func makePaymentBtnAction(_ sender: UIButton) {
             
          
}

    @IBAction func notificationBtnAction(_ sender: UIButton) {
                 
        let objVC = storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(objVC, animated: true)

        
    }
    
      @IBAction func backBtnAction(_ sender: UIButton) {
            

        self.navigationController?.popViewController(animated: true)

       }
    
    @IBAction func selectedAmountBtnAction(_ sender: UIButton) {
         
        if sender.tag == 1 {
            
            self.selectAmountBtn1.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            self.selectAmountBtn1.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            self.selectAmountBtn2.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.selectAmountBtn2.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)
            
            self.selectAmountBtn3.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.selectAmountBtn3.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)
            
            self.amount_Txt.text = "5,000"
            
        }else if sender.tag == 2 {
            
            self.selectAmountBtn1.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.selectAmountBtn1.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)
            
            self.selectAmountBtn2.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            self.selectAmountBtn2.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            self.selectAmountBtn3.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.selectAmountBtn3.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)
            
            self.amount_Txt.text = "10,000"

        }else{
            
            self.selectAmountBtn1.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.selectAmountBtn1.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)
            
            self.selectAmountBtn2.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.selectAmountBtn2.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)
            
            self.selectAmountBtn3.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            self.selectAmountBtn3.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            self.amount_Txt.text = "15,000"

        }
                      
    }
    
    
    @IBAction func selectedPaymentBtnAction(_ sender: UIButton) {
         
        if sender.tag == 1 {
            
            self.creditCardBtn.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            self.creditCardBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            self.debitCardBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.debitCardBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)
            
            self.paytmBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.paytmBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)
            
            self.phonePayBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.phonePayBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)

            self.amazonPayBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.amazonPayBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)

            self.googlePayBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.googlePayBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)

                        
        }else if sender.tag == 2 {
            
            self.creditCardBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.creditCardBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)
            
            self.debitCardBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.debitCardBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)
            
            self.paytmBtn.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            self.paytmBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            self.phonePayBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.phonePayBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)

            self.amazonPayBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.amazonPayBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)

            self.googlePayBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.googlePayBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)

                        
        }else if sender.tag == 3 {
            
            self.creditCardBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.creditCardBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)
            
            self.debitCardBtn.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            self.debitCardBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            self.paytmBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.paytmBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)
            
            self.phonePayBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.phonePayBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)

            self.amazonPayBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.amazonPayBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)

            self.googlePayBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.googlePayBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)

                        
        }else if sender.tag == 4 {
            
            self.creditCardBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.creditCardBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)
            
            self.debitCardBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.debitCardBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)
            
            self.paytmBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.paytmBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)
            
            self.phonePayBtn.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            self.phonePayBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)

            self.amazonPayBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.amazonPayBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)

            self.googlePayBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.googlePayBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)

                        
        }else if sender.tag == 5 {
            
            self.creditCardBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.creditCardBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)
            
            self.debitCardBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.debitCardBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)
            
            self.paytmBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.paytmBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)
            
            self.phonePayBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.phonePayBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)

            self.amazonPayBtn.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            self.amazonPayBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)

            self.googlePayBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.googlePayBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)

                        
        }
        else{
            
            self.creditCardBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.creditCardBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)
            
            self.debitCardBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.debitCardBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)
            
            self.paytmBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.paytmBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)
            
            self.phonePayBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.phonePayBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)

            self.amazonPayBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.amazonPayBtn.setTitleColor(#colorLiteral(red: 0.2067782283, green: 0.2667183876, blue: 0.444429636, alpha: 1), for: .normal)

            self.googlePayBtn.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            self.googlePayBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)

                        
        }
                      
    }

}
extension UserPaymentVC:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaymentCardCVCell", for: indexPath) as! PaymentCardCVCell
        cell.name_Lbl.text = titleArr[indexPath.row]
        cell.mainBgView.layer.cornerRadius = 5
        
       if selectIndex == (indexPath as NSIndexPath).row
        {
            
            cell.mainBgView.layer.borderUIColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            
        }
        else {
            
        cell.mainBgView.layer.borderUIColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            
        }
        return cell
    }
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        selectIndex = (indexPath as NSIndexPath).row
        paymentColloectionView.reloadData()

//        let idStr = collectionListData[indexPath.row].id
//        self.adoptProductsListService(id: idStr ?? "")
        
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: view.frame.width, height: view.frame.height + 30)
    }
    
}

