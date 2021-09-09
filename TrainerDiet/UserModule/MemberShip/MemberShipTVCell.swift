//
//  MemberShipTVCell.swift
//  TrainerDiet
//
//  Created by Sunkpo on 19/11/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

class MemberShipTVCell: UITableViewCell {

    @IBOutlet weak var subscriptionTitleLbl:UILabel!
    @IBOutlet weak var planDaysLbl:UILabel!
    @IBOutlet weak var subscriptionTypeLbl:UILabel!
    @IBOutlet weak var chargesAmountLbl:UILabel!
    @IBOutlet weak var finalAmountLbl:UILabel!
    @IBOutlet weak var bookNowBtn:UIButton!
    @IBOutlet weak var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setCellData(resp_Dict : NSDictionary) {

        if let titleStr = resp_Dict.value(forKey: "membershipTitle") as? String {
            
         self.subscriptionTitleLbl.text = titleStr
            
          }
        
        if let planPeriod = resp_Dict.value(forKey: "planPeriod") as? Int {
           
            if planPeriod == 1 {
                self.planDaysLbl.text = "\(planPeriod) Month"

            }else{
                self.planDaysLbl.text = "\(planPeriod) Months"
            }
         }
        
        if let membershipCategory = resp_Dict.value(forKey: "membershipCategory") as? String {
          
          self.subscriptionTypeLbl.text = membershipCategory
          
        }
        
        if let membershipCost = resp_Dict.value(forKey: "membershipCost") as? Int {
            
            let example = NSAttributedString(string: "₹\(membershipCost)").withStrikeThrough(1)
            self.chargesAmountLbl.attributedText = example
          
        }
    
//        if let discount = resp_Dict.value(forKey: "discount") as? Int {
//
//           self.discountLbl.text = "\(discount) %"
//
//        }
        
        if let finalPrice = resp_Dict.value(forKey: "finalPrice") as? Int {
                        
           self.finalAmountLbl.text = "₹\(finalPrice)"
                        
        }
         
    }
}
