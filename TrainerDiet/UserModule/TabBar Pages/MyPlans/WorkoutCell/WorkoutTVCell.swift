//
//  WorkoutTVCell.swift
//  Dieatto
//
//  Created by Developer Dev on 12/06/20.
//  Copyright © 2020 Developer Dev. All rights reserved.
//

import UIKit

class WorkoutTVCell: UITableViewCell {

    @IBOutlet var workoutType_Lbl: UILabel!
    @IBOutlet var time_Lbl: UILabel!
    @IBOutlet var weight_Lbl: UILabel!
    @IBOutlet var sets_Lbl: UILabel!
    @IBOutlet var reps_Lbl: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
