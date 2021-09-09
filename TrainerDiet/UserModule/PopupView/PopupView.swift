//
//  PopupView.swift
//  GoFantacy
//
//  Created by laxman on 4/30/20.
//  Copyright © 2020 Rize. All rights reserved.
//

import UIKit

protocol PopupViewDelegate {
    
    func tappingButtonHandlerMethod(statusSucess : Bool);
}

class PopupView: UIView {

    @IBOutlet var title_Lbl: UILabel!
    
    @IBOutlet var status_ImgView: UIImageView!

    @IBOutlet var status_Lbl: UILabel!

    @IBOutlet var message_Lbl: UILabel!

    @IBOutlet var done_Btn: UIButton!

    var popupDelegate : PopupViewDelegate? = nil
    
    var statusSucess = false
    
    func setupData(titleStr: String, statusSucess: Bool, statusStr: String, messageStr: String, doneBtnTitleStr: String) {
            
        self.statusSucess = statusSucess
        
        title_Lbl.text = titleStr
        
        status_ImgView.image = statusSucess ? UIImage.init(named: "success_status") : UIImage.init(named: "failed_status");
        
        status_ImgView.image = status_ImgView.image?.withRenderingMode(.alwaysTemplate)
        status_ImgView.tintColor = statusSucess ? UIColor.init(named: "#4AAF2B") : UIColor.red;
        
        status_Lbl.textColor = statusSucess ? UIColor.black : UIColor.red;
        
        status_Lbl.text = statusStr
        
        message_Lbl.text = messageStr
        
        done_Btn.setTitle(doneBtnTitleStr, for: .normal)
    }
    
    @IBAction func done_Btn_Action(_ sender: UIButton) {
        
        popupDelegate?.tappingButtonHandlerMethod(statusSucess: self.statusSucess)
    }
}
