//
//  UserSlotBookingHeaderTVCell.swift
//  TrainerDiet
//
//  Created by Developer Dev on 17/07/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

class UserSlotBookingHeaderTVCell: UITableViewCell {

    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var dropDownImgView: TintedImageView!
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
