//
//  UserModuleProfileVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 18/06/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit
import Photos
import SDWebImage
import Alamofire

class UserModuleProfileVC: UIViewController {
    
    @IBOutlet var headerShadowView: UIView!
    @IBOutlet var shortNameLbl: UILabel!
    @IBOutlet var profile_ImgView: UIImageView!
    
    @IBOutlet weak var firstName_Txt: UITextField!
    @IBOutlet weak var lastName_Txt: UITextField!
    
    @IBOutlet weak var gender_Txt: UITextField!
    @IBOutlet weak var dob_Txt: UITextField!
    @IBOutlet weak var height_Txt: UITextField!
    @IBOutlet weak var weight_Txt: UITextField!
    @IBOutlet weak var goal_Txt: UITextField!
    
    @IBOutlet weak var saveChangesBtn: UIButton!
    
    var profileDict = NSDictionary()
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        headerShadowView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 2.0);
        
        height_Txt.addTarget(self, action: #selector(ProfileVC.textFieldDidChange(_:)), for: .editingChanged)
        weight_Txt.addTarget(self, action: #selector(ProfileVC.textFieldDidChange(_:)), for: .editingChanged)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.tabBarController?.tabBar.isHidden = false
        if let trainerName = UserDefaults.standard.object(forKey: "firstName") as? String {
            
            self.shortNameLbl.text = getShortNames(name: trainerName)
            
        }else{
            
            // self.name_Lbl.text = "Hi"
            
        }
        getProfileHandlerMethod()
        downloadingImageFromServer()

    }
    
    
    @IBAction func saveChangesBtnAction(_ sender: UIButton) {
        
        self.updateProfileHandlerMethod()
        
    }
    
    @IBAction func profileBtnAction(_ sender: UIButton) {
        
       // self.cameraHandlerMethod()
        selectCameraAndPhotoActionCheat()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if  weight_Txt.text! == "" {
            
            self.saveChangesBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            
        } else {
            
            self.saveChangesBtn.setBackgroundImage(UIImage(named: "Rectangle -3"), for: .normal)
        }
    }
    
    @IBAction func logoutBtnAction(_ sender: UIButton) {
        
        // create the alert
        let alert = UIAlertController(title: "Logout", message: "Would you like to logout?", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
            
            
            
            // let domain = Bundle.main.bundleIdentifier!
            //UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.removeObject(forKey: "subMobile")
            UserDefaults.standard.removeObject(forKey: "subEmailId")
            UserDefaults.standard.removeObject(forKey: "firstName")
            UserDefaults.standard.removeObject(forKey: "lastName")
            UserDefaults.standard.removeObject(forKey: "subtrainerId")
            
            UserDefaults.standard.removeObject(forKey: "subId")
            UserDefaults.standard.removeObject(forKey: "trainerGymId")
            UserDefaults.standard.removeObject(forKey: "userLogin")
            
            UserDefaults.standard.synchronize()
            
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func paymentBtnAction(_ sender: UIButton) {
        
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentDetailsVC") as! PaymentDetailsVC
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    @IBAction func resetPasswordBtnAction(_ sender: UIButton) {
        
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
        objVC.isFormStr = "User"
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    func downloadingImageFromServer(){
        
        if let id = UserDefaults.standard.object(forKey: "subId") as? Int {

        if let url = URL(string: "https://beapis.dieatto.com:8090/profilepic/download/SUB/\(id)") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread
                    self.profile_ImgView.image = UIImage(data: data)
                }
            }
            
            task.resume()
        }
    }
    }
    
    func getProfileHandlerMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")
        
        var subId = Int()
        
        if let id = UserDefaults.standard.object(forKey: "subId") as? Int {
            
            subId = id
            
        }else{
            
        }
        
        let urlString = TrinerUrlPath.sharedInstance.getUrlPath("dao/subprofile/exclusive/\(subId)")
        
        TrinerAPI.sharedInstance.TrinerService_get(paramsDict: ["":""], urlPath:urlString,onCompletion: {
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
                
                self.profileDict = dict
                
                if let firstName = dict.value(forKey: "subFirstName") as? String {
                    
                    self.firstName_Txt.text = firstName
                    
                }
                
                if let dateofBirth = dict.value(forKey: "subDateOfBirth") as? String {
                    
                    
                    self.dob_Txt.text = self.convertDateFormater_New(dateofBirth)
                    
                }
                
                if let lastName = dict.value(forKey: "subLastName") as? String {
                    
                    self.lastName_Txt.text = lastName
                    
                }
                
                if  dict.value(forKey: "subGender") as? Int == 1 {
                    
                    self.gender_Txt.text = "Female"
                    
                }else{
                    
                    self.gender_Txt.text = "Male"
                    
                }
                
                if let height =  dict.value(forKey: "subHeight") as? Int {
                    
                    self.height_Txt.text = "\(height)"
                    
                }
                
                if let weight =  dict.value(forKey: "subWeight") as? Int {
                    
                    self.weight_Txt.text = "\(weight)"
                    
                }
                
                if let weight =  dict.value(forKey: "dietProfType") as? String {
                    
                    self.goal_Txt.text = "\(weight)"
                    
                }
                
            }
        }
        )
    }
    
    
    
    func convertDateFormater_New(_ dateStr: String) -> String
    {
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: dateStr)// create date from string
        
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date!)
        return timeStamp
        
    }
    
    
    func updateProfileHandlerMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")
        
        let subId = UserDefaults.standard.object(forKey: "subId") as! Int
        let mobile = UserDefaults.standard.object(forKey: "subMobile") as! Int
        
        let subDetailsStatus = self.profileDict.value(forKey: "subDetailsStatus") as? String ?? ""
        let id = self.profileDict.value(forKey: "id") as? Int
        let dietProfType = self.profileDict.value(forKey: "dietProfType") as? String
        
        var genderID = Int()
        
        if (self.gender_Txt.text!).uppercased() == "MALE" {
            
            genderID = 0
        }else{
            
            genderID = 1
            
        }
        
        let params = ["subFirstName" :"\(firstName_Txt.text!)","subLastName":"\(self.lastName_Txt.text!)","subGender":genderID,"subDateOfBirth":"\(self.dob_Txt.text!)","id":"\(id!)","subHeight":"\(height_Txt.text!)","subWeight":"\(self.weight_Txt.text!)","subDetailsStatus":subDetailsStatus,"dietProfType":"\(self.goal_Txt.text!)", "subMobPrimary":"\(mobile)"] as [String : Any]
        
        
        let urlString = TrinerUrlPath.sharedInstance.getUrlPath("dao/subprofile/exclusive/update")
        
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
            
            let statusCode = response?.value(forKey: "status") as? Int
            Services.sharedInstance.dissMissLoader()
            
            if statusCode == 200 {
                
                //self.showToast(message: "Invalide OTP")
                self.showToast(message: "Successfully update your profile")
                self.saveChangesBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
                
            }else{
                
                
            }
        }
        )
    }
    
    
    //MARK:- IMAGE SERVICE CALL
    func updateProfilePostSeriveCall()
    {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")
        let urlString = "https://beapis.dieatto.com:8090/profilepic/upload"
        let imgData = profile_ImgView.image!.jpegData(compressionQuality: 0.2)!
        let subId = UserDefaults.standard.object(forKey: "subId") as! Int
        let gymID = UserDefaults.standard.object(forKey: "trainerGymId") as! Int
        let params = ["id":"\(subId)","userType":"SUB","gymId":"\(gymID)"] as [String : Any]
        
        print(params)
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "file",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in params {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                
            }
        },
                         to:urlString)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value ?? "")
                    
                    let responseData = response.result.value as? Dictionary<String, Any>
                    print(responseData)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
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
}
extension UserModuleProfileVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
        
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
            self.profile_ImgView.image = originalImage

            self.updateProfilePostSeriveCall()
            self.downloadingImageFromServer()
            
        }
        
        // convert images into base64 and keep them into string
        
        func convertImageToBase64(image: UIImage) -> String {
            
            let imageData = image.pngData()
            
            let base64String = imageData?.base64EncodedString()
            
            return base64String!
            
        }// end convertImageToBase64
        
    }
