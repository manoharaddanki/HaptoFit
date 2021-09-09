//
//  AllUserTVCell.swift
//  TrainerDiet
//
//  Created by Developer Dev on 28/05/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

class AllUserTVCell: UITableViewCell {
    
    @IBOutlet var name_Lbl: UILabel!
    @IBOutlet var email_Lbl: UILabel!
    @IBOutlet var workoutName_Lbl: UILabel!
    @IBOutlet var checkBox: UIButton!
    @IBOutlet var userImg: UIImageView!
    @IBOutlet var bg_View: UIView!
    @IBOutlet var goalLbl_Btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bg_View.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 5.0)
        
    }
    
    func setCellData(resp_Dict : NSDictionary) {
        
        if let nameStr = resp_Dict.value(forKey: "subscriberFirstName") as? String {
            
            self.name_Lbl.text = nameStr
        }
        
        if let subscriberEmail = resp_Dict.value(forKey: "subscriberEmail") as? String {
            
            self.email_Lbl.text = subscriberEmail
        }
        
        if resp_Dict.value(forKey: "subscriberGender") as? Int == 0 {
            
            self.userImg.image = UIImage(named: "icon-male-inactive-9")
            
        }else{
            
            self.userImg.image = UIImage(named: "icon-female-inactive")
            
        }
    }
    
    
    func downloadingImageFromServer(id:String, genderID:Int){
        
        if let url = URL(string: "https://beapis.dieatto.com:8090/profilepic/download/SUB/\(id)") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread
                    
                    // It is the best way to manage nil issue.
                    if data.count > 0 {
                        
                        self.userImg.image = UIImage(data: data)
                        //self.userShortName_Lbl.isHidden = true
                    }else{
                        
                        if genderID == 0 {
                            self.userImg.image = UIImage(named: "Male")
                            }else{
                
                            self.userImg.image = UIImage(named: "Female")
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
}
