
//
//  SlotBookingTVCell.swift
//  Dieatto
//
//  Created by Developer Dev on 12/06/20.
//  Copyright © 2020 Developer Dev. All rights reserved.
//

import UIKit
import PickerButton

class SlotBookingTVCell: UITableViewCell {

    @IBOutlet var countLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var checkBoxBtn: UIButton!
    @IBOutlet var countTxtField: UITextField!
    @IBOutlet weak var editPickerButton: PickerButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

