//
//  ViewAllCommentsTVCell.swift
//  TrainerDiet
//
//  Created by Developer Dev on 20/06/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

class ViewAllCommentsTVCell: UITableViewCell {
    
    @IBOutlet weak var name_Lbl:UILabel!
    @IBOutlet weak var time_Lbl:UILabel!
    @IBOutlet weak var desciption_Lbl:UILabel!
    
    @IBOutlet weak var shortName_Lbl:UILabel!

    @IBOutlet weak var imgView: UIImageView!
    
    var currentDate = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        currentDate = formatter.string(from: date)
        
    }
    
    func setCellData(resp_Dict : NSDictionary) {
        
        self.time_Lbl.text = ""
        self.name_Lbl.text = ""
        self.desciption_Lbl.text = ""
        self.shortName_Lbl.text = ""
        
        if let firstName = resp_Dict.value(forKey: "commentFirstName") as? String {
            
            if let lastName = resp_Dict.value(forKey: "commentLastName") as? String {
                
                self.name_Lbl.text = "\(firstName) \(lastName)"
                self.shortName_Lbl.text = getShortNames(name: "\(firstName) \(lastName)")
            }else{
                
                self.name_Lbl.text = "\(firstName)"
                self.shortName_Lbl.text = getShortNames(name: "\(firstName)")

            }
        }else{
            
            if let commentLastName = resp_Dict.value(forKey: "commentLastName") as? String {
                
                self.name_Lbl.text = "\(commentLastName)"
                self.shortName_Lbl.text = getShortNames(name: "\(commentLastName)")

            }else{
                self.shortName_Lbl.text = "NA"
            }
        }
        
        
        if let commentDesc = resp_Dict.value(forKey: "commentDesc") as? String {
            
            self.desciption_Lbl.text = "\(commentDesc)"
            
        }
        
        if let commentTime = resp_Dict.value(forKey: "commentTime") as? String {
            
            let timeStr = commentTime.components(separatedBy: ".").first

            getDateDifferenceTime(postTime: timeStr!, curentTime: self.currentDate, txtLabel: self.time_Lbl, isFrom: "commentPost")
        }else{
            
            self.time_Lbl.text = "NA"
        }
        
        if let id = resp_Dict.value(forKey: "commentSubId") as? Int {
            
          if (resp_Dict.value(forKey: "commentIdentification") as? String)?.capitalized == "Trainer" {
                   
            downloadingImageFromServer(id: "\(id)", type: "TRN")
              
          }else{
            
            downloadingImageFromServer(id: "\(id)", type: "SUB")

            }
        }
    }
    
    
    func downloadingImageFromServer(id:String,type:String){
        
        if let url = URL(string: "https://beapis.dieatto.com:8090/profilepic/download/\(type)/\(id)") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread
                    
                    // It is the best way to manage nil issue.
                    if data.count > 0 {
                           self.imgView.image = UIImage(data: data)
                           self.shortName_Lbl.isHidden = true
                       }else{
                        self.shortName_Lbl.isHidden = false
                        self.shortName_Lbl.backgroundColor = UIColor.init(hexFromString: "D6E0F3")

                    }
                }
            }
            
            task.resume()
        }
    }
}
