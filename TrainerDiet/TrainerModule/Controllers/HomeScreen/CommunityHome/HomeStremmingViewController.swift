//
//  HomeStremmingViewController.swift
//  TrainerDiet
//
//  Created by RadhaKrishna on 27/05/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit
import Alamofire
import StompClientLib
import SocketRocket

struct TrainerPostLike {
    
    static var selectedRows:[IndexPath] = []
    static var commentsSelectedRows:[IndexPath] = []

}

class HomeStremmingViewController: UIViewController {
    
    @IBOutlet weak var tableListview:UITableView!
    @IBOutlet weak var postCollectionList:UICollectionView!
    @IBOutlet weak var headerView:UIView!
    @IBOutlet weak var name_Lbl:UILabel!
    
    var homeListArray = NSMutableArray()
    var myPostListArray = NSMutableArray()

    //var selectedRows:[IndexPath] = []
    
    
    
    var shortNameListArray = NSMutableArray()
    
    var titleArr = ["All Posts","My Posts"]//["User Posts","Events"]
    var selectIndex = 0
    
    var postTypeFalg:Bool = false
    
    
    var socketClient = StompClientLib()
    var url = NSURL()
    //Set the Channel
    var topic = ""
    weak var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.homeListHandlerMethod()
        TrainerPostLike.selectedRows.removeAll()
        self.registerSocket()
        startTimer()

        headerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 2.0)
        
        if let trainerName = UserDefaults.standard.object(forKey: "firstName") as? String {
            
            self.name_Lbl.text = "Hi, \(trainerName)"
            
        }else{
            
            self.name_Lbl.text = "Hi"
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true

    }
    
    func startTimer() {
           
               timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
                   // do something here
                   
                   self?.tableListview.reloadData()
       }
       }

       func stopTimer() {
           
           timer?.invalidate()
           //timerDispatchSourceTimer?.suspend() // if you want to suspend timer
       }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.popBack(toControllerType: TrainerHomeVC.self)
        
    }
    @IBAction func addPostBtnAction(_ sender: UIButton) {
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "HomeStreamingPostVC") as! HomeStreamingPostVC
        objVC.isFrom = "Trainer"
        //objVC.delegate = self
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    @IBAction func notificationBtnAction(_ sender: UIButton) {
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        //objVC.isFrom = "PersonalPlanner"
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    @IBAction func liveStreamingBtnAction(_ sender: UIButton) {

        showToast(message: "This is available only for web")
    }
    
    //CONNECT TO WEBSOCKET
    //    func registerSocket(){
    //        let completedWSURL = "wss://beapis.dieatto.com:9000/community/websocket"
    //        url = NSURL(string: completedWSURL)!
    //        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL) , delegate: self as StompClientLibDelegate)
    //    }
    
    //    func socketPostCall(bodyData: [String:Any]){
    //
    //        let firstName = UserDefaults.standard.object(forKey: "firstName") as? String
    //        let lastName = UserDefaults.standard.object(forKey: "lastName") as? String
    //
    //        //broadcast JSON data to the channel
    //        var jsonObject = [String:Any]()
    //        jsonObject["type"] = "CHAT"
    //        jsonObject["content"] = ["type":"post", "post":bodyData]
    //        jsonObject["sender"] = "\(firstName ?? "") \(lastName ?? "")"
    //
    //        print("jsonObject is ==\(jsonObject)")
    //
    //        //let channel =  UserDefaults.standard.object(forKey: "Channel") as? String
    //
    //        socketClient.sendJSONForDict(dict: jsonObject as AnyObject, toDestination: WEBSOCKET_END_POINT)
    //
    //    }
    
    
    func homeListHandlerMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: " Please wait")
        
        var gymID = Int()
        var trainerID = Int()
        var urlString = String()
        
        if let trainer_Id = UserDefaults.standard.object(forKey: "trainerId") as? Int {
            
            trainerID = trainer_Id
        }
        
        if let Id = UserDefaults.standard.object(forKey: "trainerGymId") as? Int {
            
            gymID = Id
            
        }else{
            
            gymID = 0
            
        }
                    
        urlString = "https://beapis.dieatto.com:8070/community/getGymPosts/\(gymID)"
                    
        print("API urlString is==\(urlString)")
        Alamofire.request(urlString, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil).responseJSON { response in
            Services.sharedInstance.dissMissLoader()
            if let responseData = response.result.value as? NSArray {
                
                self.homeListArray.removeAllObjects()// = []
                //self.homeListArray = responseData.mutableCopy() as! NSMutableArray
                
                self.homeListArray = NSMutableArray(array: responseData.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
                
                self.tableListview.reloadData()
                print("homeListArray is ==>\(responseData)")
            }
        }
    }
    
    func addLikePostHandlerMethod(postDict: NSDictionary, isFrom: String, postID: Int) {
        
        let firstName = UserDefaults.standard.object(forKey: "firstName") as? String ?? ""
        let lastName = UserDefaults.standard.object(forKey: "lastName") as? String ?? ""

        var likeTrainerId = Int()
        var commentSubId = Int()
        var params = [String:Any]()
        let nullVal = NSNull()

        if isFrom == "PostLike" {
            
            if let trainerId = UserDefaults.standard.object(forKey: "trainerId") as? Int {
                
                likeTrainerId = trainerId
                
            }
           
            params = ["postId": postID,"likeTrainerId": likeTrainerId,"likeFirstName": firstName,"likeLastName": lastName,"likeIdentification": "Trainer" ,"likeCommentId":0 , "likeCommentIdentification": nullVal , "likeCommentSubId": 0]
            
        }else{
            
            if let subId = postDict.value(forKey: "commentSubId") as? Int {
                
                commentSubId = subId
                
            }
            if let subId = postDict.value(forKey: "commentId") as? Int {
                
                //likeSubId = subId
                
            }
            
            params = ["postId": postID,"likeCommentSubId": commentSubId, "likeCommentId": "" , "likeFirstName": firstName,"likeLastName": lastName,"likeCommentIdentification": "trainer"]
            
        }
        
        print("params is === >\(params)")
        
        let urlString = "https://beapis.dieatto.com:8070/community/addLike"
        
        Services.sharedInstance.customLoader(view: self.view, message: " Please wait")
        
        
        TrinerAPI.sharedInstance.TrainerService_put_with_header(paramsDict: params as NSDictionary, urlPath:urlString,onCompletion: {
            (response,error) -> Void in
            
            if let networkError = error {
                
                Services.sharedInstance.dissMissLoader()
                
                if (networkError.code == -1009) {
                    print("No Internet \(String(describing: error))")
                    //Services.sharedInstance.dissMissLoader()
                    AlertSingletanClass.sharedInstance.validationAlert(title: "No Internet", message: "", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                    })
                    return
                }
            }
            
            //self.homeListHandlerMethod()
            if response == nil
            {
                Services.sharedInstance.dissMissLoader()
                return
            }else
            {
                let dict = dict_responce(dict: response)
                
                print("like response is == \(dict)")

                var postLikeCount = Int()
                
                if let likeCount = dict.value(forKey: "postLikeCount") as? Int {
                    
                    postLikeCount = likeCount
                }
                self.socketPostCall(bodyData: params, postLikeCount: postLikeCount)
                //self.homeListHandlerMethod()
                Services.sharedInstance.dissMissLoader()
            }
        }
        )
    }
    
}
extension HomeStremmingViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StremmingCollectionCell", for: indexPath)as! StremmingCollectionCell
        cell.lblTitle.text = titleArr[indexPath.row]
        cell.mainView.layer.cornerRadius = 20
        
        if selectIndex == (indexPath as NSIndexPath).row
        {
            
            cell.mainView.backgroundColor = UIColor.init(hexFromString: "#C1D0EC")
            
        }
        else {
            
            cell.mainView.backgroundColor = UIColor.init(hexFromString: "#D1D1D1")
            
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        selectIndex = (indexPath as NSIndexPath).row
        
        if indexPath.row == 0 {
            
            //postTypeFalg = false
            self.homeListHandlerMethod()
        }else{
            
            //postTypeFalg = true
            
            if let trainerIdStr = UserDefaults.standard.object(forKey: "trainerId") as? Int {
                
                if self.homeListArray.count > 0 {
                    
                    for i in 0 ..< self.homeListArray.count {
                        
                        let dict = self.homeListArray[i] as! NSDictionary
                        
                        var homeTempDict = [String:Any]()
                        
                        homeTempDict = dict as! [String : Any]
                        
                        if let trainer_Id = (homeTempDict as AnyObject).value(forKey: "trainerId") as? Int {
                                                            
                                if trainer_Id == trainerIdStr {
                                    
                                    if !self.myPostListArray.contains(homeTempDict) {
                                        
                                        self.myPostListArray.add(homeTempDict)

                                    }
                                    
                                }else{
                                    
                                }
                                
                            }else{
                                
                                
                            }
                        }
                    
                   // self.homeListArray.removeAllObjects()
                    self.homeListArray = self.myPostListArray
                    }
                }
          
        }


        collectionView.reloadData()
        self.tableListview.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
        let width = collectionView.frame.width / 2
           return CGSize(width: width, height: 30)
       }
    
}
extension HomeStremmingViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.homeListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TrainerHomeTVCell", for: indexPath) as? TrainerHomeTVCell {
            
            cell.selectionStyle = .none
            
            if let tempDict = homeListArray[indexPath.row] as? NSDictionary {
                
                cell.setCellData(resp_Dict: tempDict)
                
                cell.postShortName_Lbl.backgroundColor = .random

                cell.postViewAllComment_Btn.tag = indexPath.row
                cell.postViewAllComment_Btn.addTarget(self, action: #selector(viewAllComments_BtnAction(sender:)), for: .touchUpInside)
                
                cell.postViewAllLike_Btn.tag = indexPath.row
                cell.postViewAllLike_Btn.addTarget(self, action: #selector(viewAllLikes_BtnAction(sender:)), for: .touchUpInside)
                
                
                cell.postComment_Btn.tag = indexPath.row
                cell.postComment_Btn.addTarget(self, action: #selector(addComments_BtnAction(sender:)), for: .touchUpInside)
                
                cell.postLike_Btn.tag = indexPath.row
                cell.postLike_Btn.addTarget(self, action: #selector(addLikes_BtnAction(sender:)), for: .touchUpInside)
                
            }
            return cell
            
        }else{
            
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let tempDict = homeListArray[indexPath.row] as? NSDictionary {
            
            if tempDict.value(forKey: "postEventType") as? String == "General" {
                
                if let comments = tempDict.value(forKey: "comments") as? NSArray {
                    
                    if comments.count == 0 {
                        
                        return 190
                    }
                    else{
                        
                        return 285 //UITableView.automaticDimension
                    }
                }else{
                    
                    return 190
                }
            }else{
                
                if let comments = tempDict.value(forKey: "comments") as? NSArray {
                    
                    if comments.count == 0 {
                        
                        return 300
                    }
                    else{
                        
                        return 380 //UITableView.automaticDimension
                        
                    }
                }else{
                    
                    return 300
                }
            }
        }else{
            
            return 0
        }
    }
    
    @objc func viewAllComments_BtnAction(sender: UIButton) {
        
        if let tempDict = homeListArray[sender.tag] as? NSDictionary {
            
            if let comments = tempDict.value(forKey: "comments") as? NSArray {
                
                
                if comments.count == 0  || comments == nil {
                    
                    
                }else{
                    
                    let dictArray = NSMutableArray(array: comments.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray

                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostViewAllCommentsVC") as! PostViewAllCommentsVC
                    vc.commentsListArray = dictArray
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
            }
            
        }
        
    }
    
    @objc func viewAllLikes_BtnAction(sender: UIButton) {
        
        if let tempDict = homeListArray[sender.tag] as? NSDictionary {
            
            if let likes = tempDict.value(forKey: "likes") as? NSArray {
                
                
                if likes.count == 0  || likes == nil {
                    
                    
                }else{
                    
                    let dictArray = NSMutableArray(array: likes.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray

                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostViewAllLikesVC") as! PostViewAllLikesVC
                    vc.likesListArray = dictArray
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
            }
            
        }
        
    }
    
    @objc func addComments_BtnAction(sender: UIButton) {
        
        if let tempDict = homeListArray[sender.tag] as? NSDictionary {
            
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddPostCommentsVC") as! AddPostCommentsVC
            
            vc.commentsArrayList = tempDict
            vc.isFrom = "TRN"
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            
        }
        
    }
    
    
    @objc func addLikes_BtnAction(sender: UIButton) {
        
        if let tempDict = homeListArray[sender.tag] as? NSDictionary {
            
            if let idStr = tempDict.value(forKey: "postId") as? Int {
                
                self.addLikePostHandlerMethod(postDict: tempDict, isFrom: "PostLike", postID: idStr)
            }
        }else{
            
        }
        
        let selectedIndexPath = IndexPath(row: sender.tag, section: 0)
        
        if TrainerPostLike.selectedRows.contains(selectedIndexPath)
        {
            TrainerPostLike.selectedRows.remove(at: TrainerPostLike.selectedRows.index(of: selectedIndexPath)!)
        }
        else
        {
            TrainerPostLike.selectedRows.append(selectedIndexPath)
        }
        //self.tableListview.reloadData()
    }
    
    @objc func commentsLikes_BtnAction(sender: UIButton) {
        
        if let tempDict = homeListArray[sender.tag] as? NSDictionary {
            
            if let tempArr = tempDict.value(forKey: "comments") as? NSArray{
                
                if  tempArr.count == 0  || tempArr == nil {
                    
                    
                }else{
                    
                    if let commentDict = tempArr[0] as? NSDictionary {
                        
                        if let idStr = tempDict.value(forKey: "postId") as? Int {
                            
                            self.addLikePostHandlerMethod(postDict: commentDict, isFrom: "CommentLike", postID: idStr)
                            
                        }
                        
                    }
                    
                }
                
            }else{
                
            }
        }
        
        let selectedIndexPath = IndexPath(row: sender.tag, section: 0)
        if TrainerPostLike.commentsSelectedRows.contains(selectedIndexPath)
        {
            TrainerPostLike.commentsSelectedRows.remove(at: TrainerPostLike.commentsSelectedRows.index(of: selectedIndexPath)!)
        }
        else
        {
            TrainerPostLike.commentsSelectedRows.append(selectedIndexPath)
        }
        self.tableListview.reloadData()
        
    }
    
}

/*extension String
{
    public func getAcronyms(separator: String = "") -> String
    {
        let acronyms = self.components(separatedBy: " ").map({ String($0.characters.first!) }).joined(separator: separator);
        return acronyms;
    }
}*/

extension UIColor {
    static var random: UIColor {
        return .init(hue: .random(in: 0...1), saturation: 1, brightness: 0.5, alpha: 0.2)
    }
}

extension HomeStremmingViewController : StompClientLibDelegate {
    
    func registerSocket() {
        
        self.topic = getChannelWithGymID()
        
        url = NSURL(string: WEBSOCKET_URL)!
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL) , delegate: self as StompClientLibDelegate)
    }
    
    func socketPostCall(bodyData: [String:Any], postLikeCount: Int!){
        
        let firstName = UserDefaults.standard.object(forKey: "firstName") as? String
        let lastName = UserDefaults.standard.object(forKey: "lastName") as? String
        
        var jsonObject = [String:Any]()
        jsonObject["type"] = "CHAT"
        jsonObject["content"] = ["type":"post-like", "postLikes":postLikeCount!, "timeStamp":"\(Date.currentTimeStamp)","data":bodyData]
        jsonObject["sender"] = "\(firstName ?? "") \(lastName ?? "")"
        print("jsonObject is ==\(jsonObject)")
        
        print(self.topic)
        let timeStamp = Date.currentTimeStamp
        print("timeStamp is ==\(timeStamp)")

        let websocketEndPoint = getWebsocketEndPoint()
        print(websocketEndPoint)
        socketClient.sendJSONForDict(dict: jsonObject as AnyObject, toDestination: websocketEndPoint)
        
       // receivesBoardCastMessage(boardCastDict: postLikeBody as NSDictionary)
    }
    
    //MARK: DELEGATE METHODS
    func stompClientDidConnect(client: StompClientLib!) {
        
        self.topic = getChannelWithGymID()
        
        print("Socket is Connected : \(self.topic)")
        socketClient.subscribe(destination: self.topic)
        // Auto Disconnect after 3 sec
        // socketClient.autoDisconnect(time: 3)
        // Reconnect after 4 sec
        socketClient.reconnect(request: NSURLRequest(url: url as URL) , delegate: self as StompClientLibDelegate, time: 4.0)
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Socket is Disconnected")
    }
    
    //RECEIVES BORADCAST MESSAGE
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("DESTIONATION : \(destination)")
        print("JSON BODY : \(String(describing: jsonBody))")
        print("STRING BODY : \(stringBody ?? "nil")")
        
        let dict = jsonBody?.value(forKey: "content") as? NSDictionary
        
        receivesBoardCastMessage(boardCastDict: dict!)
        
    }
    
//    //RECEIVES BORADCAST MESSAGE
//    func stompClientJSONBody(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
//        print("DESTIONATION : \(destination)")
//        print("String JSON BODY : \(String(describing: jsonBody))")
//    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("Receipt : \(receiptId)")
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("Error : \(String(describing: message))")
    }
    
    func serverDidSendPing() {
        print("Server Ping")
    }
    
    func receivesBoardCastMessage(boardCastDict: NSDictionary) {
            
            
            print("receivesBoardCastMessage calling")

            
            if let postBoardDict = boardCastDict.value(forKey: "post") as? NSDictionary {
                
                self.homeListArray.insert(postBoardDict, at: 0)
                
            }else if let commentBoardDict = boardCastDict.value(forKey: "postComment") as? NSDictionary {
                
                for i in 0 ..< self.homeListArray.count {
                    
                    let dict = self.homeListArray[i] as! NSDictionary
                    
                    var homeTempDict = [String:Any]()
                    
                    homeTempDict = dict as! [String : Any]
                    
                    if let postId = (homeTempDict as AnyObject).value(forKey: "postId") as? Int {
                        
                        if let boardCastPostID = boardCastDict.value(forKey: "postId") as? Int {
                            
                            if postId == boardCastPostID {
                                
                                if  (((homeTempDict as AnyObject).value(forKey: "comments") as? NSArray) != nil) { //? true : false

                                //if commentsStatus == true {

                                    let commentDict = (homeTempDict as AnyObject).value(forKey: "comments") as! NSArray

                                   // if commentDict.count > 0 {
                                            
                                    var commentTempDict = NSMutableArray()
                                    commentTempDict = commentDict.mutableCopy() as! NSMutableArray
                                    commentTempDict.add(commentBoardDict)//insert(commentBoardDict, at: 0)
                                                                        
                                    homeTempDict["comments"] = commentTempDict
                                    self.homeListArray[i] = homeTempDict
                                        
    //                                }else{
    //
    //                                    self.homeListArray[i] = homeTempDict
    //
    //                                }
                                }else{
                                    
                                    homeTempDict["comments"] = commentBoardDict
                                    self.homeListArray[i] = homeTempDict

                                }
                            }else{
                                
                                self.homeListArray[i] = homeTempDict
                            }
                            
                        }else{
                            
                            self.homeListArray[i] = homeTempDict
                            
                        }
                    }
                }
                
            }else if let postLikeTempDict = boardCastDict.value(forKey: "data") as? NSDictionary {
                
                var postLikeBoardDict = [String:Any]()
                //Received Broadcasing message
                postLikeBoardDict = postLikeTempDict as! [String : Any]
                
                for i in 0 ..< self.homeListArray.count {
                    
                    let dict = self.homeListArray[i] as! NSDictionary
                    
                    var homeTempDict = [String:Any]()
                    
                    homeTempDict = dict as! [String : Any]
                    
                    if let postId = (homeTempDict as AnyObject).value(forKey: "postId") as? Int {
                        
                        if let boardCastPostID = (postLikeBoardDict as AnyObject).value(forKey: "postId") as? Int {
                            
                            if postId == boardCastPostID {
                                
                                var finalLikeDict = NSMutableArray()
                                                            
                                if (postLikeBoardDict.removeValue(forKey: "postId") != nil) {
                                    
                                    if (((homeTempDict as AnyObject).value(forKey: "likes") as? NSArray) != nil) {
                                        
                                        finalLikeDict.removeAllObjects()
                                        let likesDict = (homeTempDict as AnyObject).value(forKey: "likes") as! NSArray
                                        
                                        finalLikeDict = likesDict.mutableCopy() as! NSMutableArray
                                        print(finalLikeDict)
                                        
                                        if likesDict.count > 0
                                        {

                                            var isLikeRemoved = false
                                            
                                            for i in 0 ..< likesDict.count {
                                                
                                                let dict = likesDict[i] as! [String : Any]
                                                
                                                if ((dict as AnyObject).value(forKey: "likeIdentification") as? String)?.uppercased() == ((postLikeBoardDict as AnyObject).value(forKey: "likeIdentification") as? String)?.uppercased()
                                                {


                                                    //Subscriber
                                                    if (dict as AnyObject).value(forKey: "likeSubId") as? Int == (postLikeBoardDict as AnyObject).value(forKey: "likeSubId") as? Int
                                                    {
                                                        //Remove
                                                        print(finalLikeDict)

                                                        finalLikeDict.remove(postLikeBoardDict)
                                                        print(finalLikeDict)
                                                        isLikeRemoved = true


                                                    }

                                                    else if (postLikeBoardDict as AnyObject).value(forKey: "likeTrainerId") != nil {

                                                        if (dict as AnyObject).value(forKey: "likeTrainerId") as? Int == (postLikeBoardDict as AnyObject).value(forKey: "likeTrainerId") as? Int
                                                        {
                                                            //Trainer
                                                            finalLikeDict.remove(postLikeBoardDict)
                                                            print("finalLikeDict1")
                                                            isLikeRemoved = true
                                                        }
                                                    }
                                                 }
                                            }

                                            if !isLikeRemoved {
                                                finalLikeDict.add(postLikeBoardDict)
                                            }
                                            
                                        }
                                        else
                                        {
                                            // If no LIKES then ADD
                                            finalLikeDict.add(postLikeBoardDict)
                                            print("finalLikeDict4")

                                        }
                                        
                                    }
                                    else
                                    {
                                        
                                        finalLikeDict.add(dict)
                                    }
                                }
                                print(finalLikeDict)

                                homeTempDict["likes"] = finalLikeDict
                                self.homeListArray[i] = homeTempDict
                                
                            }else{
                                
                                self.homeListArray[i] = homeTempDict
                            }
                            
                        }else{
                            //Adding the same which already exist
                            self.homeListArray[i] = homeTempDict
                            
                        }
                    }
                }
            }
            
            self.tableListview.reloadData()
        }
}

extension HomeStremmingViewController: PostBoardCastingDataDelegate {
    
    func childViewControllerResponse(boardCastList: NSDictionary) {
        
        self.homeListArray.insert(boardCastList, at: 0)
        print("final list is ===\(self.homeListArray)")
        
        self.tableListview.reloadData()
        
    }
}


extension HomeStremmingViewController: AddCommentPostBoardCastingDataDelegate {
    
    func addPostChildViewControllerResponse(boardCastList: NSDictionary) {
        
        receivesBoardCastMessage(boardCastDict: boardCastList)
    }
    
}
