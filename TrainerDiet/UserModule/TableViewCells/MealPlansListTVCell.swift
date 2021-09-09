//
//  MealPlansListTVCell.swift
//  Dieatto
//
//  Created by Developer Dev on 26/10/19.
//  Copyright © 2019 Developer Dev. All rights reserved.
//

import UIKit

class MealPlansListTVCell: UITableViewCell {

    @IBOutlet var radio_Img: UIImageView!
    @IBOutlet var title_Lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
