//
//  StrengthCollectionViewCell.swift
//  TrainerDiet
//
//  Created by RadhaKrishna on 29/05/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

class StrengthCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLbl:UILabel!
    @IBOutlet weak var mainView:UIView!
    @IBOutlet var bg_ImgView: UIImageView!
    
    func setCellData(resp_Dict : NSDictionary) {
        
        self.titleLbl.text = ""
        if let activityName = resp_Dict.value(forKey: "activityType") as? String {
            self.titleLbl.text = activityName
        }
    }
}
