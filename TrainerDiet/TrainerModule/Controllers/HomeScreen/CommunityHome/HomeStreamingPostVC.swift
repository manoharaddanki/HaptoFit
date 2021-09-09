//
//  HomeStreamingPostVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 29/05/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit
import StompClientLib
import SocketRocket


protocol PostBoardCastingDataDelegate {
    
    func childViewControllerResponse(boardCastList: NSDictionary)
    
}

class HomeStreamingPostVC: UIViewController{
    
    
    @IBOutlet weak var addPostview:UIView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var enevtView:UIView!
    @IBOutlet weak var enevtBtn:UIButton!
    @IBOutlet weak var genericBtn:UIButton!
    
    @IBOutlet weak var post_TxtDatePicker: UITextField!
    @IBOutlet weak var post_TxtTimePicker: UITextField!
    @IBOutlet weak var location_Txt: UITextField!
    @IBOutlet weak var eventName_Txt: UITextField!
    
    @IBOutlet weak var name_Lbl: UILabel!
    @IBOutlet weak var time_Lbl: UILabel!
    @IBOutlet weak var shorcutName_Lbl: UILabel!
    @IBOutlet weak var trainerName_Lbl: UILabel!
    
    @IBOutlet weak var comments_TxtView: UITextView!
    @IBOutlet weak var generic_Comments_TxtView: UITextView!
    @IBOutlet weak var generic_PostImage:UIImageView!

    @IBOutlet weak var generic_PostImageView:UIView!
    @IBOutlet weak var comments_PostImageView: UIView!
    @IBOutlet weak var comments_PostImage:UIImageView!
    @IBOutlet weak var postProfile_ImgView:UIImageView!

    
    
    var delegate: PostBoardCastingDataDelegate?
    
    
    let datePicker = UIDatePicker()
    
    var typeStr = "General"
    var currentDate = String()
    
    var isFrom = String()
    
    var likesArrayList:NSArray = []
    var postsLikesArrayList:NSArray = []
    var commentsArrayList:NSArray = []
    var postTagsArrayList:NSArray = []
    
    var myArray = [AnyObject]()
    
    
    var socketClient = StompClientLib()
    var url = NSURL()
    //Set the Channel
    var topic = ""
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.startShowDatePicker()
        self.endShowDatePicker()
        self.registerSocket()
        
        if isFrom == "User"{
            if let subId = UserDefaults.standard.object(forKey: "subId") as? Int {
            self.downloadingImageFromServer(id: "\(subId)", type:"SUB")
            }else{
                
            }
        }else{
            if let trainID = UserDefaults.standard.object(forKey: "trainerId") as? Int {
            self.downloadingImageFromServer(id: "\(trainID)", type:"TRN")
            }else{
                
            }
        }
        if let trainerFirstName = UserDefaults.standard.object(forKey: "firstName") as? String {
            
            if let trainerLastName = UserDefaults.standard.object(forKey: "lastName") as? String {
                
                self.trainerName_Lbl.text = "\(trainerFirstName) \(trainerLastName)"
                //self.shorcutName_Lbl.text = getShortNames(name: "\(trainerFirstName) \(trainerLastName)")
                
            }else{
                
                self.trainerName_Lbl.text = "\(trainerFirstName)"
               // self.shorcutName_Lbl.text = getShortNames(name: "\(trainerFirstName)")
                
            }
        }else{
            
            if let trainerLastName = UserDefaults.standard.object(forKey: "lastName") as? String {
                
                self.trainerName_Lbl.text = "\(trainerLastName)"
               // self.shorcutName_Lbl.text = getShortNames(name: "\(trainerLastName)")
                
            }else{
                
                self.trainerName_Lbl.text = "NA"
                //self.shorcutName_Lbl.text = "NA"
                
            }
        }
        
        
        self.enevtView.isHidden = true
        
        currentDate = getCurrentDateAndTime()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isFrom == "User"{
            
            self.enevtBtn.isHidden = true
            self.enevtBtn.isUserInteractionEnabled = false
            self.comments_PostImageView.isHidden = true
            self.generic_PostImageView.isHidden = false
        }else{
            
            self.enevtBtn.isHidden = false
            self.enevtBtn.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func genericBtnAction(_ sender: UIButton) {
        
        self.enevtView.isHidden = true
        self.genericBtn.setTitleColor(UIColor.init(hexFromString: "#34C759"), for: .normal)
        self.enevtBtn.setTitleColor(UIColor.darkGray, for: .normal)
        self.typeStr = "General"
        self.comments_PostImageView.isHidden = true
        self.generic_PostImageView.isHidden = false
        
    }
    
    @IBAction func eventBtnAction(_ sender: UIButton) {
        
        self.enevtView.isHidden = false
        self.genericBtn.setTitleColor(UIColor.darkGray, for: .normal)
        self.enevtBtn.setTitleColor(UIColor.init(hexFromString: "#34C759"), for: .normal)
        self.comments_PostImageView.isHidden = false
        self.generic_PostImageView.isHidden = true
        
        self.typeStr = "Event"
        
    }
    
    @IBAction func imagePickBtnAction(_ sender: UIButton) {
        selectCameraAndPhotoActionCheat()
    }
    @IBAction func postBtnAction(_ sender: UIButton) {
        
        let generalCommentStr = self.generic_Comments_TxtView.text!
        let eventCommentStr = self.comments_TxtView.text!
        
        let trimmedStringGen = generalCommentStr.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedStringEvent = eventCommentStr.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.typeStr == "General" {
            
            if trimmedStringGen == "" {
                
                self.showToast(message: "Please enter post comment")
                
            }else if trimmedStringGen == "Write your description here.." {
                
                self.showToast(message: "Please enter post comment")
                
            }else if self.generic_Comments_TxtView.text.count <= 280 {
                
                self.postHandlerMethod()
                
            }else{
                
                self.showToast(message: "Post comment limit upto 280 only")
                
            }
        }else{
            
            if self.eventName_Txt.text == "" {
                
                self.showToast(message: "Please enter event name")
                
            }else if self.post_TxtDatePicker.text == "" {
                
                self.showToast(message: "Please select start date & time")
                
                
            }else if self.post_TxtTimePicker.text == "" {
                
                self.showToast(message: "Please select end date & time")
                
                
            }else if (self.post_TxtDatePicker.text!) > (self.post_TxtTimePicker.text!) {
                
                self.showToast(message: "Start date must be before end date")
                
            }
            else if self.location_Txt.text == "" {
                
                self.showToast(message: "Please enter location name")
                
            }else if trimmedStringEvent == "" {
                
                self.showToast(message: "Please enter event comment")
                
            }else if trimmedStringEvent == "Write event description here..." {
                
                self.showToast(message: "Please enter event comment")
                
            }else if self.comments_TxtView.text.count <= 140 {
                
                self.postHandlerMethod()
                
            }else{
                
                self.showToast(message: "Event comment limit upto 140 only")
                
            }
        }
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        if let navController = self.navigationController {
            
            navController.popViewController(animated: true)
        }
        
    }
    
    func downloadingImageFromServer(id:String,type:String){
        
        if let url = URL(string: "https://beapis.dieatto.com:8090/profilepic/download/\(type)/\(id)") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread
                    
                    // It is the best way to manage nil issue.
                    if data.count > 0 {
                        
                            self.postProfile_ImgView.image = UIImage(data: data)
                            self.shorcutName_Lbl.isHidden = true
                    }else{
                            self.shorcutName_Lbl.isHidden = false
                            self.shorcutName_Lbl.backgroundColor = UIColor.init(hexFromString: "D6E0F3")
                        }
                    }
                }
            task.resume()
        }
    }
    
    
    func startShowDatePicker() {
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        post_TxtDatePicker.inputAccessoryView = toolbar
        post_TxtDatePicker.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        post_TxtDatePicker.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallary()
    {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func selectCameraAndPhotoActionCheat() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func endShowDatePicker() {
        
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePickerEnd));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePickerEnd));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        post_TxtTimePicker.inputAccessoryView = toolbar
        post_TxtTimePicker.inputView = datePicker
        
    }
    
    @objc func donedatePickerEnd(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let endDate = formatter.string(from: datePicker.date)
        
        if (self.post_TxtDatePicker.text!) == "" {
            
            post_TxtTimePicker.text = ""
            self.showToast(message: "Please select start date & time")
            
        }else if (self.post_TxtDatePicker.text!) < (self.post_TxtTimePicker.text!) {
            
            self.showToast(message: "Start date must be before end date")
            
        }
        else{
            
            self.post_TxtTimePicker.text = endDate
        }
        
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePickerEnd(){
        self.view.endEditing(true)
    }
    
    func convertDateFormater_New(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return  dateFormatter.string(from: date!)
        
    }
    
    func postHandlerMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: " Please wait")
        
        var subID = Int()
        var trainerID = Int()
        var firstName = String()
        var lastName = String()
        var gymId = Int()
        
        if let fname = UserDefaults.standard.object(forKey: "firstName") as? String {
            
            firstName = fname
        }else{
            
            firstName = ""
        }
        if let lname = UserDefaults.standard.object(forKey: "lastName") as? String {
            
            lastName = lname
        }else{
            
            lastName = ""
        }
        
        if let id = UserDefaults.standard.object(forKey: "trainerGymId") as? Int {
            
            gymId = id
        }else{
            
            gymId = 0
        }
        
        if let trainerId = UserDefaults.standard.object(forKey: "trainerId") as? Int {
            
            trainerID = trainerId
            
        }else{
            
            trainerID = 0
        }
        
        if let subId = UserDefaults.standard.object(forKey: "subId") as? Int {
            
            subID = subId
            
        }else{
            
            subID = 0
        }
        
        let startDateStr:String!
        let endDateStr:String!
        
        var params = [String:Any]()
        let nullVal = NSNull()
        //let tagsVal = []
        let postTag = [String]()
        

        if self.typeStr == "General" {
            
            //let imgData = generic_PostImage.image!.jpegData(compressionQuality: 0.2)!
            let imgData = convertImageToBase64(image: self.generic_PostImage.image!)

            if isFrom == "User"{
                
                params = ["gymId": gymId,"trainerId": trainerID,"subId": subID ,"gymName":nullVal,"firstName":"\(firstName)","lastName":"\(lastName)","postEventType":"\(self.typeStr)","postIdentification":"subscriber","postTime": "\(currentDate)","postDesc":"\(self.generic_Comments_TxtView.text!)","postImage":imgData,"eventName":nullVal,"eventLocation":nullVal,"eventDescription":nullVal,"eventStartTime":nullVal, "eventEndTime":nullVal,"postTags": postTag, "likes":postTag, "comments": postTag]
                
            }else{
                
                params = ["gymId" :gymId,"trainerId":trainerID,"subId":subID,"gymName":nullVal,"firstName":"\(firstName)","lastName":"\(lastName)","postEventType":"\(self.typeStr)","postIdentification":"trainer","postTime": "\(currentDate)","postDesc":"\(self.generic_Comments_TxtView.text!)","postImage":imgData,"eventName":nullVal,"eventLocation":nullVal,"eventDescription":nullVal,"eventStartTime":nullVal, "eventEndTime":nullVal,"postTags":postTag, "likes":postTag, "comments": postTag]
            }
            
        }else{
            
            //let imgData = comments_PostImage.image!.jpegData(compressionQuality: 0.2)!
            let imgData = convertImageToBase64(image: self.comments_PostImage.image!)

            if let startdate = self.post_TxtDatePicker.text {
                
                startDateStr = convertDateFormater_New(startdate)
                
            }else{
                
                startDateStr = ""
            }
            
            if let enddate = self.post_TxtTimePicker.text {
                
                endDateStr = convertDateFormater_New(enddate)
                
            }else{
                endDateStr = ""
            }
            
            if isFrom == "User" {
                
                params = ["gymId" :gymId,"subId":subID,"trainerId":trainerID,"gymName":"null","firstName":"\(firstName)","lastName":"\(lastName)","postEventType":"\(self.typeStr)","postIdentification":"subscriber","eventName":"\(self.eventName_Txt.text!)","eventLocation":"\(self.location_Txt.text!)","eventDescription":"\(self.comments_TxtView.text!)","postImage":imgData,"eventStartTime":"\(startDateStr!)","postTime": "\(currentDate)", "eventEndTime":"\(endDateStr!)","postTags": nullVal]
                
            }else{
                
                params = ["gymId" :gymId,"subId":subID,"trainerId":trainerID,"gymName":"null","firstName":"\(firstName)","lastName":"\(lastName)","postEventType":"\(self.typeStr)","postIdentification":"trainer","eventName":"\(self.eventName_Txt.text!)","eventLocation":"\(self.location_Txt.text!)","eventDescription":"\(self.comments_TxtView.text!)","postImage":imgData,"eventStartTime":"\(startDateStr!)","postTime": "\(currentDate)", "eventEndTime":"\(endDateStr!)","postTags": nullVal]
                
            }
        }
        
        print("params is === >\(params)")
        let urlString = "https://beapis.dieatto.com:8070/community/save"
        
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
            
            if response == nil
            {
                Services.sharedInstance.dissMissLoader()
                return
            }else
            {
                Services.sharedInstance.dissMissLoader()
                
                let dict = dict_responce(dict: response)
                
                if let post_Id = dict.value(forKey: "postId") as? Int {
                    
                    params["postId"] = post_Id
                    self.socketPostCall(bodyData: params)
                    
                }
                
                if status_Check(dict: dict)
                {
                    AlertSingletanClass.sharedInstance.validationAlert(title: "Success", message: "You have successfully register your account. Please login.", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                        
                        print("Register response is ==\(dict)")
                    })
                }else
                {
                    Services.sharedInstance.dissMissLoader()
                    
                    if let err_code = dict.value(forKeyPath: "error") as? String {
                        
                        AlertSingletanClass.sharedInstance.validationAlert(title: "Error", message: err_code, preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                        })
                    }
                }
                Services.sharedInstance.dissMissLoader()
            }
        }
        )
    }
}

extension HomeStreamingPostVC : UITextViewDelegate {
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        generic_Comments_TxtView.text = ""
        generic_Comments_TxtView.textColor = UIColor.black
        comments_TxtView.text = ""
        comments_TxtView.textColor = UIColor.black
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if generic_Comments_TxtView.text.isEmpty {
            generic_Comments_TxtView.text = "Write your description here..."
            generic_Comments_TxtView.textColor = UIColor.darkGray
        }
        if comments_TxtView.text.isEmpty {
            comments_TxtView.text = "Write event description here..."
            comments_TxtView.textColor = UIColor.darkGray
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
extension HomeStreamingPostVC : StompClientLibDelegate {
    
    func registerSocket() {
        
        self.topic = getChannelWithGymID()
        
        url = NSURL(string: WEBSOCKET_URL)!
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL) , delegate: self as StompClientLibDelegate)
    }
    
    func socketPostCall(bodyData: [String:Any]){
        
        let firstName = UserDefaults.standard.object(forKey: "firstName") as? String
        let lastName = UserDefaults.standard.object(forKey: "lastName") as? String
        
        var jsonObject = [String:Any]()
        jsonObject["type"] = "CHAT"
        jsonObject["content"] = ["type":"post", "post":bodyData]
        jsonObject["sender"] = "\(firstName ?? "") \(lastName ?? "")"
        print("jsonObject is ==\(jsonObject)")
        
        print(self.topic)
        let websocketEndPoint = getWebsocketEndPoint()
        print(websocketEndPoint)
        socketClient.sendJSONForDict(dict: jsonObject as AnyObject, toDestination: websocketEndPoint)
        
        if isFrom == "User" {
            
        }else{
            
            self.delegate?.childViewControllerResponse(boardCastList: bodyData as NSDictionary)
        }
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: DELEGATE METHODS
    func stompClientDidConnect(client: StompClientLib!) {
        print("Socket is Connected : \(self.topic)")
        socketClient.subscribe(destination: self.topic)
        // Auto Disconnect after 3 sec
        //socketClient.autoDisconnect(time: 3)
        // Reconnect after 4 sec
        socketClient.reconnect(request: NSURLRequest(url: url as URL) , delegate: self as StompClientLibDelegate, time: 4.0)
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Socket is Disconnected")
    }
    
    //RECEIVES BORADCAST MESSAGE
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        
        //self.delegate?.childViewControllerResponse(filterList: tempArrDict)
        
        if let boardcastDict = (jsonBody?.value(forKey: "content") as? NSDictionary)?.value(forKey: "post") as? NSDictionary {
            
            print("parsing json body ==\(print(boardcastDict))")
            
            //            self.delegate?.childViewControllerResponse(boardCastList: boardcastDict)
            //            self.navigationController?.popViewController(animated: true)
            
        }
        
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

extension HomeStreamingPostVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //MARK:- UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        //  print("originalImage",originalImage)
        if self.typeStr == "General" {
            self.generic_PostImage.image = originalImage
        }else{
            self.comments_PostImage.image = originalImage
        }
        
    }
    
    // convert images into base64 and keep them into string
    
    func convertImageToBase64(image: UIImage) -> String {
        
        let imageData = image.pngData()
        
        let base64String = imageData?.base64EncodedString()
        
        return base64String!
        
    }// end convertImageToBase64
    
}
