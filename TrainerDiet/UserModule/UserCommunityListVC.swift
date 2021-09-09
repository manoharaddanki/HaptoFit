//
//  UserCommunityListVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 13/07/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit
import Alamofire
import SocketRocket
import StompClientLib

struct UserPostLike {
    
    static var selectedRows:[IndexPath] = []
    static var commentsSelectedRows:[IndexPath] = []

}

class UserCommunityListVC: UIViewController {

    @IBOutlet weak var headerView:UIView!
    @IBOutlet weak var tableListview:UITableView!
    @IBOutlet weak var userName_Lbl:UILabel!
    @IBOutlet weak var postTypeCollectionList:UICollectionView!

    
    var homeListArray = NSMutableArray()
    var shortNameListArray = NSMutableArray()
    var myPostListArray = NSMutableArray()

    var titleArr = ["All Posts","My Posts"]//["User Posts","Events"]
    var selectIndex = 0

    var userPostTypeFalg:Bool = false

    var socketClient = StompClientLib()
       var url = NSURL()
       //Set the Channel
       var topic = ""
    
    weak var timer: Timer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerSocket()

        headerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 2.0)
        
        self.userHomeListHandlerMethod()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        startTimer()

        if let trainerName = UserDefaults.standard.object(forKey: "firstName") as? String {
            
            self.userName_Lbl.text = "Hi, \(trainerName)"
        }else{
            
            self.userName_Lbl.text = "Hi"

        }
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
         
        self.popBack(toControllerType: HomeVC.self)
 
    }
    
    @IBAction func notificationBtnAction(_ sender: UIButton) {
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(objVC, animated: true)
    }

    
    @IBAction func addPostBtnAction(_ sender: UIButton) {
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "HomeStreamingPostVC") as! HomeStreamingPostVC
        objVC.isFrom = "User"
        //objVC.delegate = self
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    func userHomeListHandlerMethod() {
        
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
        
        Alamofire.request(urlString, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? NSArray {
                
                Services.sharedInstance.dissMissLoader()

                self.homeListArray.removeAllObjects()// = []

                //self.homeListArray = responseData.mutableCopy() as! NSMutableArray
                    
                self.homeListArray = NSMutableArray(array: responseData.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray

                    self.tableListview.reloadData()
                print("homeListArray is ==>\(responseData)")
            }else{
                
                Services.sharedInstance.dissMissLoader()
                
            }
        }
    }
    
    
    func addLikePostHandlerMethod(postDict: NSDictionary, isFrom: String, postID: Int) {
        
        Services.sharedInstance.customLoader(view: self.view, message: " Please wait")

        let firstName = UserDefaults.standard.object(forKey: "firstName") as? String ?? ""
        let lastName = UserDefaults.standard.object(forKey: "lastName") as? String ?? ""

        var likeSubId = 0
        var commentSubId = ""
        var params = [String:Any]()
        let nullVal = NSNull()

        if isFrom == "PostLike" {
            
            if let subId = UserDefaults.standard.object(forKey: "subId") as? Int {
                
                likeSubId = subId
                
            }

            
            params = ["postId": postID,"likeSubId": likeSubId,"likeFirstName": firstName,"likeLastName": lastName,"likeIdentification": "Subscriber","likeCommentId":0 , "likeCommentIdentification": nullVal , "likeCommentSubId": 0]
            
        }else{
            
            if let subId = postDict.value(forKey: "commentSubId") as? Int {
                
                commentSubId = String(subId)
                
            }
            if let subId = postDict.value(forKey: "commentId") as? Int {
                           
                           likeSubId = subId
                           
                       }
            
            
            params = ["postId": postID,"likeCommentSubId": commentSubId, "likeCommentId": likeSubId , "likeFirstName": firstName,"likeLastName": lastName,"likeCommentIdentification": "subscriber"]
            
        }
        
        print("params is === >\(params)")
        
        let urlString = "https://beapis.dieatto.com:8070/community/addLike"
            
        TrinerAPI.sharedInstance.TrainerService_put_with_header(paramsDict: params as NSDictionary, urlPath:urlString,onCompletion: {
            (response,error) -> Void in
            
            if let networkError = error {
                
                Services.sharedInstance.dissMissLoader()
                
                if (networkError.code == -1009) {
                    print("No Internet \(String(describing: error))")
                    Services.sharedInstance.dissMissLoader()
                    AlertSingletanClass.sharedInstance.validationAlert(title: "No Internet", message: "", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                    })
                    
                    return
                }
            }
            
            //self.userHomeListHandlerMethod()
            if response == nil
            {
                Services.sharedInstance.dissMissLoader()
                return
            }else
            {
                Services.sharedInstance.dissMissLoader()

                let dict = dict_responce(dict: response)
                var postLikeCount = Int()
                               
                if let likeCount = dict.value(forKey: "postLikeCount") as? Int {
                                   
                postLikeCount = likeCount
                    
               }
                
                self.socketPostCall(bodyData: params, postLikeCount: postLikeCount)
                //self.userHomeListHandlerMethod()
                
                if status_Check(dict: dict)
                {
                    
                    
                }else
                {
                    if let err_code = dict.value(forKeyPath: "error") as? String {
                        
                        AlertSingletanClass.sharedInstance.validationAlert(title: "Error", message: err_code, preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                        })
                    }
                }
            }
        }
        )
    }
    
    
}

extension UserCommunityListVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.homeListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for: indexPath) as? homeTableCell {
            
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
                        
                        return 360 //UITableView.automaticDimension
                        
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
                    
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostViewAllCommentsVC") as! PostViewAllCommentsVC
                    vc.commentsListArray = comments
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
                    
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostViewAllLikesVC") as! PostViewAllLikesVC
                    vc.likesListArray = likes
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
            }
            
        }
        
    }
    
    @objc func addComments_BtnAction(sender: UIButton) {
        
        if let tempDict = homeListArray[sender.tag] as? NSDictionary {
            
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddPostCommentsVC") as! AddPostCommentsVC
            vc.isFrom = "SUB"
            vc.commentsArrayList = tempDict
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
        if UserPostLike.selectedRows.contains(selectedIndexPath)
        {
          UserPostLike.selectedRows.remove(at: UserPostLike.selectedRows.index(of: selectedIndexPath)!)
        }
        else
        {
          UserPostLike.selectedRows.append(selectedIndexPath)
        }
        self.tableListview.reloadData()
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
               if UserPostLike.commentsSelectedRows.contains(selectedIndexPath)
               {
                 UserPostLike.commentsSelectedRows.remove(at: UserPostLike.commentsSelectedRows.index(of: selectedIndexPath)!)
               }
               else
               {
                 UserPostLike.commentsSelectedRows.append(selectedIndexPath)
               }
               self.tableListview.reloadData()
            
        }
    
}

extension UserCommunityListVC:UICollectionViewDelegate,UICollectionViewDataSource{
    
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

            self.userHomeListHandlerMethod()
        }else{
                        
            if let trainerIdStr = UserDefaults.standard.object(forKey: "subId") as? Int {
                
                if self.homeListArray.count > 0 {
                    
                    for i in 0 ..< self.homeListArray.count {
                        
                        let dict = self.homeListArray[i] as! NSDictionary
                        
                        var homeTempDict = [String:Any]()
                        
                        homeTempDict = dict as! [String : Any]
                        
                        if let trainer_Id = (homeTempDict as AnyObject).value(forKey: "subId") as? Int {
                                                            
                                if trainer_Id == trainerIdStr {
                                    
                                    if !self.myPostListArray.contains(homeTempDict) {
                                        
                                        self.myPostListArray.add(homeTempDict)

                                    }
                                    
                                }else{
                                    
                                }
                                
                            }else{
                                
                                
                            }
                        }
                    
                    //self.homeListArray.removeAllObjects()
                    self.homeListArray = self.myPostListArray
                    }
                }
          
        }
        postTypeCollectionList.reloadData()
        tableListview.reloadData()

    }
    
}

extension UserCommunityListVC: StompClientLibDelegate {
    
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
        let websocketEndPoint = getWebsocketEndPoint()
        print(websocketEndPoint)
        socketClient.sendJSONForDict(dict: jsonObject as AnyObject, toDestination: websocketEndPoint)
        
    }
    
    //MARK: DELEGATE METHODS
    func stompClientDidConnect(client: StompClientLib!) {
        
        self.topic = getChannelWithGymID()
        
        print("Socket is Connected : \(self.topic)")
        socketClient.subscribe(destination: self.topic)
        // Auto Disconnect after 3 sec
        // socketClient.autoDisconnect(time: 3)
        // Reconnect after 4 sec
        socketClient.reconnect(request: NSURLRequest(url: url as URL) , delegate: self as StompClientLibDelegate, time: 1.0)
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
        //stopTimer()
        receivesBoardCastMessage(boardCastDict: dict!)
        
    }
    
    //RECEIVES BORADCAST MESSAGE
    func stompClientJSONBody(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("DESTIONATION : \(destination)")
       // print("String JSON BODY : \(String(describing: jsonBody))")
        //stopTimer()

    }
    
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

extension UserCommunityListVC: PostBoardCastingDataDelegate {
    
    func childViewControllerResponse(boardCastList: NSDictionary) {
        
        self.homeListArray.insert(boardCastList, at: 0)
        print("final list is ===\(self.homeListArray)")
        
        self.tableListview.reloadData()
        
    }
}


extension UserCommunityListVC: AddCommentPostBoardCastingDataDelegate {
    
    func addPostChildViewControllerResponse(boardCastList: NSDictionary) {
        
        receivesBoardCastMessage(boardCastDict: boardCastList)
    }
    
}
