//
//  UserSlotBookingTVCell.swift
//  TrainerDiet
//
//  Created by Developer Dev on 17/07/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit
import AAPickerView

class UserSlotBookingTVCell: UITableViewCell {

    @IBOutlet var viewBookingsBtn: UIButton!
    @IBOutlet var countTxtField: UITextField!
    @IBOutlet var capacityCountBtn: UIButton!
    @IBOutlet var startTimeBtn: UIButton!
    @IBOutlet var startTimeTxt: UITextField!

    @IBOutlet var endTimeBtn: UIButton!
    @IBOutlet var startTimeLbl : UILabel!
    @IBOutlet var endTimeLbl : UILabel!
    @IBOutlet var maleBtn : UIButton!
    @IBOutlet var femaleBtn: UIButton!
    @IBOutlet var maleFemaleBtn: UIButton!
    @IBOutlet var closeBtn : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.startTimeTxt.isHidden = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }

}
extension UITextField {
    
    func addInputViewDatePicker(target: Any, selector: Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        
        //Add DatePicker as inputView
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .time
        self.inputView = datePicker
        
        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        
        self.inputAccessoryView = toolBar
    }
    
    @objc func cancelPressed() {
        self.resignFirstResponder()
    }
}
