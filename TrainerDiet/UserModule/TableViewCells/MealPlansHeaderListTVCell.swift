//
//  MealPlansHeaderListTVCell.swift
//  Dieatto
//
//  Created by Developer Dev on 26/10/19.
//  Copyright © 2019 Developer Dev. All rights reserved.
//

import UIKit

class MealPlansHeaderListTVCell: UITableViewCell {

    @IBOutlet var hader_lbl: UILabel!
    @IBOutlet var expandCollapseBtn: UIButton!
    @IBOutlet var expandCollapseDropDown: UIButton!
    @IBOutlet var header_ImgView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
