//
//  HomeVC.swift
//  Dieatto
//
//  Created by M Venkat  Rao on 10/23/19.
//  Copyright © 2019 Developer Dev. All rights reserved.
//

import UIKit
import Alamofire

class HomeVC: UIViewController {
    
    @IBOutlet weak var headerView:UIView!
    @IBOutlet weak var stressView:UIView!
    
    @IBOutlet weak var collectionBlogView:UICollectionView!
    
    @IBOutlet weak var communityBgView:UIView!
    @IBOutlet weak var energyTrackerBgView:UIView!
    @IBOutlet weak var slotBookingBgView:UIView!
    @IBOutlet weak var gymMemberShipView:UIView!
    @IBOutlet weak var liveGymStatusView:UIView!

    @IBOutlet weak var liveGymStstusLbl:UILabel!

    @IBOutlet weak var watchLiveBgView:UIView!
    @IBOutlet weak var covidBgView:UIView!
    
    @IBOutlet weak var sleepScore_Lbl:UILabel!
    @IBOutlet weak var sleepBtn:UIButton!
    
    @IBOutlet weak var stressScore_Lbl:UILabel!
    @IBOutlet weak var stressBtn:UIButton!
    
    @IBOutlet weak var wellnessScore_Lbl:UILabel!
    @IBOutlet weak var wellnessBtn:UIButton!
    
    @IBOutlet weak var userName_Lbl:UILabel!
    
    
    var titleArr = [String]()
    var titleImgArr = NSMutableArray()
    var blogListArray = NSMutableArray()

    var homeListArray = NSArray()
    var selectedRows:[IndexPath] = []
    var commentsSelectedRows:[IndexPath] = []
    var shortNameListArray = NSMutableArray()
    
    var sleepScore = Int()
    var sleepScoreDate = String()
    var stressScore = Int()
    var stressScoreDate = String()
    var wellnessScore = Int()
    var wellnessScoreDate = String()
    
    //var currentDate = String()
    
    var reloadTimer : Timer?
    
    var emptyStr = "Click here"
    
    var currentDateStr = String()
    
    var sleepStatusFlag:Bool = true
    var stressStatusFlag:Bool = true
    var wellnessStatusFlag:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        headerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 0.0)
        slotBookingBgView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20)
        //covidBgView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 10.0)
        //watchLiveBgView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 10.0)
        communityBgView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20)
        energyTrackerBgView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20)
        gymMemberShipView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20)
        liveGymStatusView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20)


    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        self.currentDateStr = formatter.string(from: date)

        self.getAllScoreCardGetCall()
        
        DispatchQueue.main.async {
            
         self.getBlogDataCall()
         self.getLiveGymStatusCountCall()


        }
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
                
      //  reloadTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(HomeVC.currentDateCalling), userInfo: nil, repeats: true)
        
        
        if let trainerName = UserDefaults.standard.object(forKey: "firstName") as? String {
            
            self.userName_Lbl.text = "Hi, \(trainerName)"
        }else{
            
            self.userName_Lbl.text = "Hi"
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if (reloadTimer != nil){
            if reloadTimer!.isValid{
                reloadTimer!.invalidate()
            }
        }
        
       // self.invalidTimer()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("*** method calling in Home List ***")
        self.reloadTimer?.invalidate()
    }
    
    // MARK:  Valid & invalid timer  Methods
    
    func invalidTimer()  {
        
        if (reloadTimer != nil){
            if reloadTimer!.isValid{
                reloadTimer!.invalidate()
            }
        }
        print("=====refresh invalid=====")
    }
    
    @objc func currentDateCalling() {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let currentDateStr = formatter.string(from: date)
        
        let sleepDateStr = UserDefaults.standard.object(forKey: "sleepDate") as? String ?? ""
        let wellNessDateStr = UserDefaults.standard.object(forKey: "wellNessDate") as? String ?? ""
        let stressLevelDateStr = UserDefaults.standard.object(forKey: "stressLevelDate") as? String ?? ""
        
        
        self.differenceBetweenTwoDates(postDate: sleepDateStr, currentDate: currentDateStr ,txtLabel: self.sleepScore_Lbl, dateKey: "sleepDate",scoreKey: "sleepScore", clickBtn: sleepBtn)
        self.differenceBetweenTwoDates(postDate: stressLevelDateStr, currentDate: currentDateStr ,txtLabel: self.stressScore_Lbl, dateKey: "stressLevelDate",scoreKey: "stressScore", clickBtn: stressBtn)
        self.differenceBetweenTwoDates(postDate: wellNessDateStr, currentDate: currentDateStr ,txtLabel: self.wellnessScore_Lbl, dateKey: "wellNessDate",scoreKey: "wellnessScore", clickBtn: wellnessBtn)
        
    }
    
    func differenceBetweenTwoDates(postDate:String, currentDate:String, txtLabel : UILabel, dateKey: String, scoreKey:String, clickBtn: UIButton)  {
        
        let days = getDaysHoursMinsSecsBetweenTwoDates(post_server_time: postDate , current_start_time: currentDate, calComponentType: .day)
        
        if days < 16 {
            
            clickBtn.isUserInteractionEnabled = false

        }else{
            
            txtLabel.text = "Click here"
            print("text == \(txtLabel.text!)")
            clickBtn.isUserInteractionEnabled = true
            UserDefaults.standard.removeObject(forKey: dateKey)
            UserDefaults.standard.removeObject(forKey: scoreKey)
        }
        
    }
    
    @IBAction func slotBookingBtnAction(_ sender: UIButton) {
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "SlotBookingVC") as! SlotBookingVC
        
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    @IBAction func sleepBtnAction(_ sender: UIButton) {
        
        if  sleepStatusFlag == true {
            
            let objVC = storyboard?.instantiateViewController(withIdentifier: "SleepVC") as! SleepVC
            self.navigationController?.pushViewController(objVC, animated: true)

        }else{
            
            //showToast(message: "You have already submitted sleep score for this fortnight")

            AlertSingletanClass.sharedInstance.validationAlert(title: "Sleep", message: "You have already submitted sleep score for this fortnight", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                
            })
        }
                
    }
    
    @IBAction func stressBtnAction(_ sender: UIButton) {
        
        if  stressStatusFlag == true {
            
            let objVC = storyboard?.instantiateViewController(withIdentifier: "StressLevelsVC") as! StressLevelsVC
            self.navigationController?.pushViewController(objVC, animated: true)

        }else{
            
            //showToast(message: "You have already submitted stress score for this fortnight")

            AlertSingletanClass.sharedInstance.validationAlert(title: "Stress", message: "You have already submitted stress score for this fortnight", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                
            })

        }
    }
    
    
    @IBAction func wellnesBtnAction(_ sender: UIButton) {
        
        if  wellnessStatusFlag == true {
                   
        let objVC = storyboard?.instantiateViewController(withIdentifier: "WellnessVC") as! WellnessVC
        self.navigationController?.pushViewController(objVC, animated: true)

        }else{
                   
        //showToast(message: "You have already submitted wellness score for this fortnight")

            AlertSingletanClass.sharedInstance.validationAlert(title: "Wellness", message: "You have already submitted wellness score for this fortnight", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                
            })


        }
        
    }
    @IBAction func covidBtnAction(_ sender: UIButton) {
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "CovidVC") as! CovidVC
        
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    @IBAction func energyTrackerBtnAction(_ sender: UIButton) {

        let objVC = storyboard?.instantiateViewController(withIdentifier: "EnergyTrackerVC") as! EnergyTrackerVC
        self.navigationController?.pushViewController(objVC, animated: true)

    }
    
    @IBAction func gymMemberShipBtnAction(_ sender: UIButton) {

           let objVC = storyboard?.instantiateViewController(withIdentifier: "MemberShipPackagesVC") as! MemberShipPackagesVC
           self.navigationController?.pushViewController(objVC, animated: true)

       }
    
    @IBAction func liveStreamingBtnAction(_ sender: UIButton) {

        showToast(message: "This is available only for web")
    }
    @IBAction func communityBtnAction(_ sender: UIButton) {
        
        if UserIntroduce.userIntrProceedFlag == true {
            
            let nextViewController = storyboard?.instantiateViewController(withIdentifier: "UserCommunityIntroduceVC") as! UserCommunityIntroduceVC
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }else{
            
            let nextViewController = storyboard?.instantiateViewController(withIdentifier: "UserCommunityListVC") as! UserCommunityListVC
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
        
    }
    
    
    @IBAction func notificationBtnAction(_ sender: UIButton) {
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    
    
    func getAllScoreCardGetCall() {
        
        var urlString = String()
        
        var subID = Int()
        if let Id = UserDefaults.standard.object(forKey: "subId") as? Int {
            
            subID = Id
        }
        
        urlString = TrinerUrlPath.sharedInstance.getUrlPath("dao/wellnessscore/subId/\(subID)")
        
        print("score Api is ==>\(urlString)")
        
        Alamofire.request(urlString, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            if let responseData = response.result.value as? NSArray {
                
                Services.sharedInstance.dissMissLoader()
                
                if responseData.count != 0 {
                    
                    for i in 0..<responseData.count {
                        
                        let scoreList = responseData[i] as! NSDictionary
                        
                        if let sleepScoreVal = scoreList.value(forKey: "sleepScore") as? Int {
                            
                            if sleepScoreVal == 0 {

                                self.sleepScore_Lbl.text = "Click here"
                                //self.sleepBtn.isUserInteractionEnabled = true
                                self.sleepStatusFlag = true
                                UserDefaults.standard.removeObject(forKey: "sleepScore")

                            }else{

                                if let sleepScoreDateStr = scoreList.value(forKey: "sleepCalcDate") as? String {
                                                           
                                    let days = self.getDaysHoursMinsSecsBetweenTwoDates(post_server_time: sleepScoreDateStr , current_start_time: self.currentDateStr, calComponentType: .day)

                                    if days < 16 {
                                        
                                        //self.sleepBtn.isUserInteractionEnabled = false
                                        self.sleepScore_Lbl.text = "\(sleepScoreVal)"
                                        self.sleepStatusFlag = false
                                        UserDefaults.standard.set(sleepScoreVal, forKey: "sleepScore")


                                    }else{
                                        
                                        //self.sleepBtn.isUserInteractionEnabled = true
                                        self.sleepScore_Lbl.text = "Click here"
                                        self.sleepStatusFlag = true
                                        UserDefaults.standard.removeObject(forKey: "sleepScore")

                                    }
                                    
                                    }
                            }
                            
                        }
                       
                        if let stressScoreVal = scoreList.value(forKey: "stressScore") as? Int {
                            
                            if stressScoreVal == 0 {

                                self.stressScore_Lbl.text = "Click here"
                                //self.stressBtn.isUserInteractionEnabled = true
                                self.stressStatusFlag = true
                                UserDefaults.standard.removeObject(forKey: "stressScore")

                            }else{
                                
                                if let stressCalcDate = scoreList.value(forKey: "stressCalcDate") as? String {
                                    
                                    let days = self.getDaysHoursMinsSecsBetweenTwoDates(post_server_time: stressCalcDate , current_start_time: self.currentDateStr, calComponentType: .day)

                                    if days < 16 {
                                                                           
                                        //self.stressBtn.isUserInteractionEnabled = false
                                        self.stressScore_Lbl.text = "\(stressScoreVal)"
                                        self.stressStatusFlag = false
                                        UserDefaults.standard.set(stressScoreVal, forKey: "stressScore")


                                    }else{
                                                                           
                                        //self.stressBtn.isUserInteractionEnabled = true
                                        self.stressScore_Lbl.text = "Click here"
                                        self.stressStatusFlag = true
                                        UserDefaults.standard.removeObject(forKey: "stressScore")

                                        }
                                }

                            }
                            
                        }
                        
                        
                        if let wellnessScoreVal = scoreList.value(forKey: "wellnessScore") as? Int {
                                                        
                            if wellnessScoreVal == 0 {

                                self.wellnessScore_Lbl.text = "Click here"
                                //self.wellnessBtn.isUserInteractionEnabled = true
                                self.wellnessStatusFlag = true
                                UserDefaults.standard.removeObject(forKey: "wellnessScore")

                            }else{

                            if let wellCalcDate = scoreList.value(forKey: "wellCalcDate") as? String {
                                                                    
                            let days = self.getDaysHoursMinsSecsBetweenTwoDates(post_server_time: wellCalcDate , current_start_time: self.currentDateStr, calComponentType: .day)

                            if days < 16 {
                                                                                                              
                           // self.wellnessBtn.isUserInteractionEnabled = false
                            self.wellnessScore_Lbl.text = "\(wellnessScoreVal)"
                            self.wellnessStatusFlag = false
                            UserDefaults.standard.set(wellnessScoreVal, forKey: "wellnessScore")

                            }else{
                                                                                                              
                            //self.wellnessBtn.isUserInteractionEnabled = true
                            self.wellnessScore_Lbl.text = "Click here"
                            self.wellnessStatusFlag = true
                            UserDefaults.standard.removeObject(forKey: "wellnessScore")
                                
                            }
                              }
                            }
                        }
                    }
                }else{
                    
                    //self.sleepBtn.isUserInteractionEnabled = true
                    //self.stressBtn.isUserInteractionEnabled = true
                    //self.wellnessBtn.isUserInteractionEnabled = true
                    //UserDefaults.standard.removeObject(forKey: "sleepDate")
                    //UserDefaults.standard.removeObject(forKey: "stressLevelDate")
                    //UserDefaults.standard.removeObject(forKey: "wellNessDate")
                    
                }
                print("response score is ==>\(responseData)")
            }else{
                
                Services.sharedInstance.dissMissLoader()
                
            }
        }
        
    }
    
    func getBlogDataCall() {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")

       let urlString = "https://www.dieatto.com/blog/feed/json"
        
        Alamofire.request(urlString, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            Services.sharedInstance.dissMissLoader()

            if let responseData = response.result.value as? NSArray {
                        
                self.blogListArray.removeAllObjects()
                self.titleImgArr.removeAllObjects()
                self.titleArr.removeAll()

                if responseData.count != 0 {
                    
                    //self.blogListArray = responseData as! NSMutableArray
                    
                    for i in 0..<responseData.count {
                        
                        self.blogListArray.add(responseData[i])
                        let listData = responseData[i] as! NSDictionary
                      
                        if let titleStr = listData.value(forKey: "title") as? String {
                            
                            self.titleArr.append(titleStr)
                        }
                        
                        if let thumbnailStr = listData.value(forKey: "thumbnail") as? String {
                                                   
                            let thumbarray = thumbnailStr.components(separatedBy: ", ")

                                let str = (thumbarray[0]).components(separatedBy: " ")
                            
                                let imgStr = str[0]

                                self.titleImgArr.add(imgStr)
                                print("image list == \(self.titleImgArr)")
                            
                        }
                        
                    }
                    
                    //self.collectionBlogView.reloadData()

                }else{
                    
                   
                }
            }else{
                
                
            }
        }
        
    }
    
    
    func getLiveGymStatusCountCall() {
        
        var urlString = String()
        
        var gymId = Int()
        if let id = UserDefaults.standard.object(forKey: "trainerGymId") as? Int {
            
            gymId = id
        }
        
        urlString = TrinerUrlPath.sharedInstance.getUrlPath("dao/livegymstatus/getCounts/gymId/\(gymId)")
        
        print("LiveGymStatus Api is ==>\(urlString)")
        
        Alamofire.request(urlString, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            if let responseData = response.result.value as? NSDictionary {
                
                if let count = responseData.value(forKey: "clientsCount") as? Int {
                
                self.liveGymStstusLbl.text = "\(count)"
                    
                }
            }else{
                
                Services.sharedInstance.dissMissLoader()
                
            }
        }
        
    }
}



extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return titleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVCell", for: indexPath) as! HomeCVCell
        
        cell.title_Lbl.text = titleArr[indexPath.row]
        //cell.title_Lbl.UILableTextShadow(color: .darkGray)
        
        //cell.imgView.contentMode = .scaleAspectFill
        cell.imgView.sd_setImage(with: URL (string: titleImgArr[indexPath.row] as! String), placeholderImage:UIImage(named:""))

        //cell.imgView.downloaded(from: titleImgArr[indexPath.row] as! String)

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dict = blogListArray[indexPath.row] as? NSDictionary
        let img = titleImgArr[indexPath.row] as? String ?? ""
        let contentDiv = dict?.value(forKey: "content") as? String ?? ""
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "BlogDetailsVC") as! BlogDetailsVC
        objVC.content = contentDiv
        objVC.imgStr = img
        self.navigationController?.pushViewController(objVC, animated: true)

    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {

       func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {

            return CGSize(width: 300, height: 150)
        
            
            //return CGSize(width: widthPerItem, height: widthPerItem)
        
    }
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 8
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        }


}
extension UIImage {
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height

        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }

        let newSize = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
        let resized = resizedImage(newSize: newSize)
        return resized
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
