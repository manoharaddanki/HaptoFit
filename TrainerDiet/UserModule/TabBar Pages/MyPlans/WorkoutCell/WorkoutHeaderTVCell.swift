//
//  WorkoutHeaderTVCell.swift
//  Dieatto
//
//  Created by Developer Dev on 12/06/20.
//  Copyright © 2020 Developer Dev. All rights reserved.
//

import UIKit

class WorkoutHeaderTVCell: UITableViewCell {

    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var dropDownImgView: UIImageView!
    @IBOutlet var foodImg: UIImageView!
    @IBOutlet var selectBtn: UIButton!
    @IBOutlet var headerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
