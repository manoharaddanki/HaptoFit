//
//  StrengthTrainingListTVCell.swift
//  TrainerDiet
//
//  Created by Developer Dev on 30/05/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

class StrengthTrainingListTVCell: UITableViewCell {

    @IBOutlet var checkMarkBtn: UIButton!
    @IBOutlet var title_Lbl: UILabel!
    @IBOutlet var bg_View: UIView!

    func setCellData(resp_Dict : NSDictionary, selectedDateStr: String) {
           
        self.title_Lbl.text = ""
        //self.bg_View.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 10.0)

//        if let date = resp_Dict.value(forKey: "subWorkoutDate") as? String {
//
//            if selectedDateStr == date {
                
                if let activityName = resp_Dict.value(forKey: "subActivityType") as? String {
                    self.title_Lbl.text = activityName
                }
//            }
//
//        }
           
       }

}
