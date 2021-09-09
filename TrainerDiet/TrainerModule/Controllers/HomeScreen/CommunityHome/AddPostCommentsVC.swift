//
//  AddPostCommentsVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 19/06/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit
import StompClientLib
import SocketRocket


protocol AddCommentPostBoardCastingDataDelegate {
    
    func addPostChildViewControllerResponse(boardCastList: NSDictionary)

}

class AddPostCommentsVC: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var name_Lbl: UILabel!
    @IBOutlet weak var time_Lbl: UILabel!
    @IBOutlet weak var shorcutName_Lbl: UILabel!
    @IBOutlet weak var trainerPostName_Lbl: UILabel!

    @IBOutlet weak var comments_TxtView: UITextView!

    let datePicker = UIDatePicker()
    var commentsArrayList = NSDictionary()
    
    var socketClient = StompClientLib()
    var url = NSURL()
    //Set the Channel
    var topic = ""
    var isFrom = String()
    
    var delegate: AddCommentPostBoardCastingDataDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.registerSocket()

        if let trainerFirstName = UserDefaults.standard.object(forKey: "firstName") as? String {
              
                  if let trainerLastName = UserDefaults.standard.object(forKey: "lastName") as? String {
                      
                      self.trainerPostName_Lbl.text = "\(trainerFirstName) \(trainerLastName)"
                      self.shorcutName_Lbl.text = getShortNames(name: "\(trainerFirstName) \(trainerLastName)")

                  }else{
                      
                      self.trainerPostName_Lbl.text = "\(trainerFirstName)"
                      self.shorcutName_Lbl.text = getShortNames(name: "\(trainerFirstName)")

                  }
                      }else{
              
                  
                  if let trainerLastName = UserDefaults.standard.object(forKey: "lastName") as? String {

                          self.trainerPostName_Lbl.text = "\(trainerLastName)"
                          self.shorcutName_Lbl.text = getShortNames(name: "\(trainerLastName)")

                  }else{
                      
                      self.trainerPostName_Lbl.text = "NA"
                      self.shorcutName_Lbl.text = "NA"

                  }
                      }

    }

    
    @IBAction func commentPostBtnAction(_ sender: UIButton) {
        
        self.postHandlerMethod()
                 
       }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
             
    if let navController = self.navigationController {
           
           navController.popViewController(animated: true)
       }
              
    }

    
    func postHandlerMethod() {
        
        var postID = Int()
        var commentSubId = Int()
        var firstName = ""
        var lastName = ""
        var postIdentification = ""

        Services.sharedInstance.customLoader(view: self.view, message: " Please wait")
        
        if let id = commentsArrayList.value(forKey: "postId") as? Int {
            
            postID = id
        
        }

        
        if let firstNameStr = UserDefaults.standard.object(forKey: "firstName") as? String {
            
            firstName = firstNameStr
        
        }
        if let lastNameStr = UserDefaults.standard.object(forKey: "lastName") as? String {
            
            lastName = lastNameStr
        
        }
            if isFrom == "TRN"{
                                
                if let subId = UserDefaults.standard.object(forKey: "trainerId") as? Int {
                                       
                    commentSubId = subId
                }
                postIdentification = "trainer"
                                        
            }else{
                
                postIdentification = "subscriber"
                if let subId = UserDefaults.standard.object(forKey: "subId") as? Int {

                    commentSubId = subId
                                
                }
            }
            
        let commentLikes:NSArray = []
        
        var params = [String:Any]()
            
        let currentDate = getCurrentDateAndTime()
        
        params = ["postId": postID, "commentSubId": commentSubId,"commentFirstName": firstName,"commentLastName": lastName,"commentDesc":"\(self.comments_TxtView.text!)","commentIdentification": postIdentification,"commentTime":"\(currentDate)","commentLikes": commentLikes]

    
        print("params is === >\(params)")
        
        let urlString = "https://beapis.dieatto.com:8070/community/addComment"
        
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
            
            if response == nil
            {
              Services.sharedInstance.dissMissLoader()
                return
            }else
            {
                Services.sharedInstance.dissMissLoader()

                let dict = dict_responce(dict: response)
                
                if let comment_Id = dict.value(forKey: "commentId") as? Int {
                                  
                     params["commentId"] = comment_Id
                    
                    self.socketPostCall(bodyData: params, postIDVal: postID)

                }else{
                    
                    
                    
                }

                //Services.sharedInstance.dissMissLoader()
            }
        }
        )
    }
    
    
}

extension AddPostCommentsVC : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
            textView.text = ""
        textView.textColor = UIColor.black
        }

    func textViewDidEndEditing(_ textView: UITextView) {
         if textView.text.isEmpty {
             textView.text = "Write your comment."
            textView.textColor = UIColor.darkGray
         }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n"  // Recognizes enter key in keyboard
            {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
}

//MARK: WEBSOCKET METHODS

extension AddPostCommentsVC : StompClientLibDelegate {
          
    
    //CONNECT TO WEBSOCKET
    func registerSocket(){
        
        self.topic = getChannelWithGymID()

        url = NSURL(string: WEBSOCKET_URL)!
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL) , delegate: self as StompClientLibDelegate)
    }
    
    
      func stompClientDidConnect(client: StompClientLib!) {
          let topic = self.topic
          print("Socket is Connected : \(topic)")
          socketClient.subscribe(destination: topic)
          // Auto Disconnect after 3 sec
          //socketClient.autoDisconnect(time: 3)
          // Reconnect after 4 sec
          socketClient.reconnect(request: NSURLRequest(url: url as URL) , delegate: self as StompClientLibDelegate, time: 4.0)
      }
      
      func stompClientDidDisconnect(client: StompClientLib!) {
          print("Socket is Disconnected")
      }
    
    func socketPostCall(bodyData: [String:Any], postIDVal: Int){
        
        let firstName = UserDefaults.standard.object(forKey: "firstName") as? String
        let lastName = UserDefaults.standard.object(forKey: "lastName") as? String

        //broadcast JSON data to the channel
        var jsonObject = [String:Any]()
        jsonObject["type"] = "CHAT"
        jsonObject["content"] = ["type":"post-comment", "postId": postIDVal,"postComment":bodyData]
        jsonObject["sender"] = "\(firstName ?? "") \(lastName ?? "")"

        print("jsonObject is ==\(jsonObject)")
        
        let commentObj = ["postId": postIDVal,"postComment":bodyData] as [String : Any]
        
       let websocketEndPoint = getWebsocketEndPoint()

        socketClient.sendJSONForDict(dict: jsonObject as AnyObject, toDestination: websocketEndPoint)

        //self.delegate?.addPostChildViewControllerResponse(boardCastList: commentObj as NSDictionary)
        self.navigationController?.popViewController(animated: true)

    }
    

      //RECEIVES BORADCAST MESSAGE
      func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
          print("DESTIONATION : \(destination)")
          print("JSON BODY : \(String(describing: jsonBody))")
          print("STRING BODY : \(stringBody ?? "nil")")
      }

      //RECEIVES BORADCAST MESSAGE
      func stompClientJSONBody(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
          print("DESTIONATION : \(destination)")
          print("String JSON BODY : \(String(describing: jsonBody))")
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

}


