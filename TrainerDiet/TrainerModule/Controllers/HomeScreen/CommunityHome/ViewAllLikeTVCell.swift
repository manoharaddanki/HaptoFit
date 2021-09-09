//
//  ViewAllLikeTVCell.swift
//  TrainerDiet
//
//  Created by Developer Dev on 20/06/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

class ViewAllLikeTVCell: UITableViewCell {
    
    @IBOutlet weak var name_Lbl:UILabel!
    @IBOutlet weak var time_Lbl:UILabel!
    @IBOutlet weak var desciption_Lbl:UILabel!
    @IBOutlet weak var shortName_Lbl:UILabel!
    @IBOutlet weak var imgView:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    func setCellData(resp_Dict : NSDictionary) {
        
        self.name_Lbl.text = ""
        
        if let firstName = resp_Dict.value(forKey: "likeFirstName") as? String {
            
            if let lastName = resp_Dict.value(forKey: "likeLastName") as? String {
                
                self.name_Lbl.text = "\(firstName) \(lastName)"
                self.shortName_Lbl.text = getShortNames(name: "\(firstName) \(lastName)")
            }else{
                
                self.name_Lbl.text = "\(firstName)"
                self.shortName_Lbl.text = getShortNames(name: "\(firstName)")
                
            }
        }else{
            
            if let commentLastName = resp_Dict.value(forKey: "likeLastName") as? String {
                
                self.name_Lbl.text = "\(commentLastName)"
                self.shortName_Lbl.text = getShortNames(name: "\(commentLastName)")
                
            }else{
                
                self.shortName_Lbl.text = "NA"
                
            }
            
            if (resp_Dict.value(forKey: "likeIdentification") as? String)?.capitalized == "Trainer" {
                
                if let id = resp_Dict.value(forKey: "likeTrainerId") as? Int {
                    
                    downloadingImageFromServer(id: "\(id)", type: "TRN")
                }
            }else{
                
                if let id = resp_Dict.value(forKey: "likeSubId") as? Int {
                    
                    downloadingImageFromServer(id: "\(id)", type: "SUB")
                }
                
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
