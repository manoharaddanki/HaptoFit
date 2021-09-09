//
//  FantasyPointsHeaderCell.swift
//  GoFantacy
//
//  Created by laxman on 3/10/20.
//  Copyright © 2020 Rize. All rights reserved.
//

import UIKit

class MyPlansHeaderCell: UITableViewCell {

    @IBOutlet var titleLbl: UILabel!
    
    @IBOutlet var dropDownImgView: UIImageView!
    
    @IBOutlet var foodImg: UIImageView!

    @IBOutlet var selectBtn: UIButton!
    @IBOutlet var headerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //headerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
