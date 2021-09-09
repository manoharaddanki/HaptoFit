//
//  FantasyPointsTVCell.swift
//  GoFantacy
//
//  Created by laxman on 3/10/20.
//  Copyright © 2020 Rize. All rights reserved.
//

import UIKit

class NutritionTVCell: UITableViewCell {

    @IBOutlet var mealTypeLbl: UILabel!
    @IBOutlet var quantityLbl: UILabel!
    @IBOutlet var nutrition_Img: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
