//
//  homeTableCell.swift
//  TrainerDiet
//
//  Created by RadhaKrishna on 29/05/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

class homeTableCell: UITableViewCell {
    
    @IBOutlet var shadowView: UIView!
    
    @IBOutlet weak var postName_Lbl:UILabel!
    @IBOutlet weak var postTime_Lbl:UILabel!
    
    @IBOutlet weak var postShortName_Lbl:UILabel!
    @IBOutlet weak var trainerIcon_ImgView:UIImageView!
    @IBOutlet weak var postProfile_ImgView:UIImageView!
    @IBOutlet weak var commentProfile_ImgView:UIImageView!
    
    @IBOutlet weak var postDiscription_Lbl:UILabel!
    @IBOutlet weak var postLikeCount_Lbl:UILabel!
    @IBOutlet weak var postViewAllLike_Btn:UIButton!
    @IBOutlet weak var postLike_Btn:UIButton!
    
    @IBOutlet weak var eventName_Lbl:UILabel!
    @IBOutlet weak var eventStartDateTime_Lbl:UILabel!
    @IBOutlet weak var eventEndDateTime_Lbl:UILabel!
    
    @IBOutlet weak var eventLocation_Lbl:UILabel!
    
    @IBOutlet weak var postCommentCount_Lbl:UILabel!
    @IBOutlet weak var postViewAllComment_Btn:UIButton!
    @IBOutlet weak var postComment_Btn:UIButton!
    
    @IBOutlet weak var userLikeCount_Lbl:UILabel!
    @IBOutlet weak var userLike_Btn:UIButton!
    @IBOutlet weak var userName_Lbl:UILabel!
    @IBOutlet weak var userTime_Lbl:UILabel!
    
    @IBOutlet weak var userShortName_Lbl:UILabel!
    @IBOutlet weak var userDiscription_Lbl:UILabel!
    
    var currentDate = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        currentDate = formatter.string(from: date)
        
    }
    
    
    
    func setCellData(resp_Dict : NSDictionary) {
        
        self.postName_Lbl.text = ""
        if let firstName = resp_Dict.value(forKey: "firstName") as? String {
            
            if let lastName = resp_Dict.value(forKey: "lastName") as? String {
                
                self.postName_Lbl.text = "\(firstName) \(lastName)"
                self.postShortName_Lbl.text = getShortNames(name: "\(firstName) \(lastName)")
                
            }else{
                
                self.postName_Lbl.text = "\(firstName)"
                self.postShortName_Lbl.text = getShortNames(name: "\(firstName)")
                
                
            }
        }else{
            
            if let lastName = resp_Dict.value(forKey: "lastName") as? String {
                
                self.postName_Lbl.text = "\(lastName)"
                self.postShortName_Lbl.text = getShortNames(name: "\(lastName)")
                
                
            }else{
                
                self.postName_Lbl.text = "No name found"
                self.postShortName_Lbl.text = "NA"
                
            }
            
        }
        
        self.trainerIcon_ImgView.image = UIImage(named: "")
        
        if (resp_Dict.value(forKey: "postIdentification") as? String)?.capitalized == "Trainer" {
            
            self.trainerIcon_ImgView.image = UIImage(named: "muscular-icon")
            if let trainID = resp_Dict.value(forKey: "trainerId") as? Int {
                self.downloadingImageFromServer(id: "\(trainID)", type:"TRN", postCommentProfile: "Post")
            }
            
        }else{
            
            self.trainerIcon_ImgView.image = UIImage(named: "")
            if let subID = resp_Dict.value(forKey: "subId") as? Int {
                self.downloadingImageFromServer(id: "\(subID)", type:"SUB", postCommentProfile: "Post")
            }
        }
        
        self.postDiscription_Lbl.text = ""
        
        if resp_Dict.value(forKey: "postEventType") as? String == "General" {
            
            self.eventName_Lbl.isHidden = true
            self.eventStartDateTime_Lbl.isHidden = true
            self.eventEndDateTime_Lbl.isHidden = true
            self.eventLocation_Lbl.isHidden = true
            
            if let postDesc = resp_Dict.value(forKey: "postDesc") as? String {
                
                self.postDiscription_Lbl.text = postDesc
            }else{
                
                self.postDiscription_Lbl.text = "No posts found"
            }
            
        }else{
            
            self.eventName_Lbl.isHidden = false
            self.eventStartDateTime_Lbl.isHidden = false
            self.eventEndDateTime_Lbl.isHidden = false
            self.eventLocation_Lbl.isHidden = false
            
            if let eventDescription = resp_Dict.value(forKey: "eventDescription") as? String {
                
                self.postDiscription_Lbl.text = eventDescription
                
            }else{
                
                self.postDiscription_Lbl.text = "Event Description not found"
                
            }
            
            if let eventLocation = resp_Dict.value(forKey: "eventLocation") as? String {
                
                self.eventLocation_Lbl.text = "Location: \(eventLocation)"
                
            }else{
                
                self.eventLocation_Lbl.text = "Event Location not found"
                
            }
            if let eventName = resp_Dict.value(forKey: "eventName") as? String {
                
                self.eventName_Lbl.text = "Event Name: \(eventName)"
                
            }else{
                
                self.eventName_Lbl.text = "Event Name not found"
                
            }
            
            if let eventStartTime = resp_Dict.value(forKey: "eventStartTime") as? String {
                
                let startTime = eventStartTime.UTCToLocal(incomingFormat:"yyyy-MM-dd'T'HH:mm:ss", outGoingFormat: "dd/MM/yyyy h:mm a") //
                
                self.eventStartDateTime_Lbl.text = "StartTime:\(startTime)"
            }else{
                
                self.eventStartDateTime_Lbl.isHidden = true
                
            }
            if let eventEndTime = resp_Dict.value(forKey: "eventEndTime") as? String {
                
                let endtTime = eventEndTime.UTCToLocal(incomingFormat:"yyyy-MM-dd'T'HH:mm:ss", outGoingFormat: "dd/MM/yyyy h:mm a") //
                
                self.eventEndDateTime_Lbl.text = "EndTime:\(endtTime)"
                
            }else{
                
                self.eventEndDateTime_Lbl.isHidden = true
                
            }
        }
        
        self.postCommentCount_Lbl.text = ""
        self.userName_Lbl.text = ""
        self.userDiscription_Lbl.text = ""
        self.userLikeCount_Lbl.text = ""
        
        if let comments = resp_Dict.value(forKey: "comments") as? NSArray {
            
            if comments.count == 0 {
                
                self.postCommentCount_Lbl.text = "0 Comment"
                
                self.userShortName_Lbl.isHidden = true
                self.userName_Lbl.isHidden = true
                self.userTime_Lbl.isHidden = true
                self.userDiscription_Lbl.isHidden = true
                
            }else{
                
                if  comments.count == 1 {
                    
                    self.postCommentCount_Lbl.text = "\(comments.count) Comment"
                    
                }else{
                    
                    self.postCommentCount_Lbl.text = "\(comments.count) Comments"
                    
                }
                
                //let dict = NSMutableArray(array: comments.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
                
                if let tempDict = comments[0] as? NSDictionary {
                    
                    self.userShortName_Lbl.isHidden = false
                    self.userName_Lbl.isHidden = false
                    self.userTime_Lbl.isHidden = false
                    self.userDiscription_Lbl.isHidden = false
                    
                    
                    if (tempDict.value(forKey: "commentIdentification") as? String)?.capitalized == "Trainer" {
                        
                        //self.trainerIcon_ImgView.image = UIImage(named: "muscular-icon")
                        if let trainID = tempDict.value(forKey: "commentSubId") as? Int {
                            self.downloadingImageFromServer(id: "\(trainID)", type:"TRN", postCommentProfile: "Comment")
                        }
                        
                    }else{
                        
                        self.trainerIcon_ImgView.image = UIImage(named: "")
                        if let subID = resp_Dict.value(forKey: "commentSubId") as? Int {
                            self.downloadingImageFromServer(id: "\(subID)", type:"SUB", postCommentProfile: "Comment")
                        }
                    }
                    
                    if let firstName = tempDict.value(forKey: "commentFirstName") as? String {
                        
                        if let lastName = tempDict.value(forKey: "commentLastName") as? String {
                            
                            self.userName_Lbl.text = "\(firstName) \(lastName)"
                            self.userShortName_Lbl.text = getShortNames(name: "\(firstName) \(lastName)")
                            
                            
                        }else{
                            
                            self.userName_Lbl.text = "\(firstName)"
                            self.userShortName_Lbl.text = getShortNames(name: "\(firstName)")
                            
                        }
                    }else{
                        
                        if let commentLastName = tempDict.value(forKey: "commentLastName") as? String {
                            
                            self.userName_Lbl.text = "\(commentLastName)"
                            self.userShortName_Lbl.text = getShortNames(name: "\(commentLastName)")
                            
                        }
                        
                    }
                    
                    if let commentDesc = tempDict.value(forKey: "commentDesc") as? String {
                        
                        self.userDiscription_Lbl.text = "\(commentDesc)"
                        
                    }
                    
                    if let userCommentTime = tempDict.value(forKey: "commentTime") as? String {
                        
                        let timeStr = userCommentTime.components(separatedBy: ".").first
                        
                        
                        getDateDifferenceTime(postTime: timeStr!, curentTime: self.currentDate, txtLabel: self.userTime_Lbl, isFrom: "commentPost")
                        
                    }else{
                        
                        self.userTime_Lbl.text = "NA"
                        
                    }
                    
                }
            }
            
        }else{
            
            self.postCommentCount_Lbl.text = "0 Comment"
            self.userShortName_Lbl.isHidden = true
            self.userName_Lbl.isHidden = true
            self.userTime_Lbl.isHidden = true
            self.userDiscription_Lbl.isHidden = true
        }
        
        self.postLikeCount_Lbl.text = ""
        
        
        if let likes = resp_Dict.value(forKey: "likes") as? NSArray {
            
            if likes.count == 0 {
                
                self.postLikeCount_Lbl.text = "\(likes.count) Like"
                self.postLike_Btn.setImage(UIImage(named:"like icon"), for: .normal)
                
            }else{
                
                if  likes.count == 1 {
                    
                    self.postLikeCount_Lbl.text = "\(likes.count) Like"
                    
                }else{
                    
                    self.postLikeCount_Lbl.text = "\(likes.count) Likes"
                    
                }
                
                let subID = UserDefaults.standard.object(forKey: "subId") as? Int//resp_Dict.value(forKey: "subId") as? Int
                
                if likes.count != 0 {
                    
                    var isLikeRemoved = false
                    
                    for i in 0..<likes.count {
                        
                        let dict = likes[i] as? NSDictionary
                        let likeSubId = dict?.value(forKey: "likeSubId") as? Int
                        
                        if subID == likeSubId {
                            
                            //self.postLike_Btn.setImage(UIImage(named:"comment like pressed state"), for: .normal)
                            
                            isLikeRemoved = true
                            
                        }else{
                            
                            //self.postLike_Btn.setImage(UIImage(named:"like icon"), for: .normal)
                        }
                    }
                    
                    if isLikeRemoved {
                        
                        self.postLike_Btn.setImage(UIImage(named:"comment like pressed state"), for: .normal)
                        
                    }else{
                        
                        self.postLike_Btn.setImage(UIImage(named:"like icon"), for: .normal)
                        
                    }
                    
                }else{
                    
                    self.postLike_Btn.setImage(UIImage(named:"like icon"), for: .normal)
                    
                }
            }
            
        }else{
            
            self.postLikeCount_Lbl.text = "0 Like"
            
        }
        
        if let postTime = resp_Dict.value(forKey: "postTime") as? String {
            
            
            getDateDifferenceTime(postTime: postTime, curentTime: self.currentDate, txtLabel: self.postTime_Lbl, isFrom: "normalPost")
            
        }else{
            
            self.postTime_Lbl.text = "NA"
            
        }
        
    }
    
    func downloadingImageFromServer(id:String,type:String,postCommentProfile:String){
        
        if let url = URL(string: "https://beapis.dieatto.com:8090/profilepic/download/\(type)/\(id)") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread
                    
                    // It is the best way to manage nil issue.
                    if data.count > 0 {
                        
                        if postCommentProfile == "Post" {
                        self.postProfile_ImgView.image = UIImage(data: data)
                        self.postShortName_Lbl.isHidden = true
                        }else{
                            self.commentProfile_ImgView.image = UIImage(data: data)
                            self.userShortName_Lbl.isHidden = true

                        }
                    }else{
                        
                        if postCommentProfile == "Post" {

                        self.postShortName_Lbl.isHidden = false
                        self.postShortName_Lbl.backgroundColor = UIColor.init(hexFromString: "D6E0F3")
                        }else{
                            
                            self.userShortName_Lbl.isHidden = false
                            self.userShortName_Lbl.backgroundColor = UIColor.init(hexFromString: "D6E0F3")

                        }
                    }
                }
            }
            
            task.resume()
        }
    }
}
