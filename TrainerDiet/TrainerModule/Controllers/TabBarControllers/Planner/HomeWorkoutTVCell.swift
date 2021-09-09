//
//  HomeWorkoutTVCell.swift
//  TrainerDiet
//
//  Created by Developer Dev on 13/06/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

class HomeWorkoutTVCell: UITableViewCell {

    @IBOutlet var name_Lbl: UILabel!
    @IBOutlet var checkBox: UIButton!
    @IBOutlet var bg_View: UIView!

   func setCellData(resp_Dict : NSDictionary) {
        
    bg_View.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 5.0)

        self.name_Lbl.text = ""
        if let activityType = resp_Dict.value(forKey: "activityType") as? String {
            self.name_Lbl.text = activityType
        }
    }
}
