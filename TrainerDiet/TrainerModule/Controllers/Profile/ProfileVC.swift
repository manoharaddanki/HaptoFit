//
//  ProfileVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 28/05/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit
import Photos
import SDWebImage
import Alamofire

class ProfileVC: UIViewController {
    
    @IBOutlet var profile_ImgView: UIImageView!
    
    @IBOutlet var signInScrollView: UIScrollView!
    @IBOutlet var shortName_Lbl: UILabel!
    @IBOutlet var shortName_ShadowView: UIView!

    @IBOutlet var header_View: UIView!
    @IBOutlet var userName_Txt: UITextField!
    @IBOutlet var userLastName_Txt: UITextField!
    @IBOutlet var mobile_Txt: UITextField!
    @IBOutlet var email_Txt: UITextField!
    @IBOutlet var gymName_Txt: UITextField!
    @IBOutlet var gymLocation_Txt: UITextField!
    @IBOutlet var gymCity_Txt: UITextField!
    
    @IBOutlet var saveButton: UIButton!
    
    var shortName = String()
    
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
       // mobile_Txt.addTarget(self, action: #selector(ProfileVC.textFieldDidChange(_:)), for: .editingChanged)
        //email_Txt.addTarget(self, action: #selector(ProfileVC.textFieldDidChange(_:)), for: .editingChanged)
        
        shortName_ShadowView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
        header_View.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 0.0)

        
        if let trainerFirstName = UserDefaults.standard.object(forKey: "firstName") as? String {
            
             if let trainerLastName = UserDefaults.standard.object(forKey: "lastName") as? String {
            

                self.shortName = trainerFirstName + trainerLastName
                
             }else{
                
                self.shortName = trainerFirstName

            }
        }else{
            
            if let trainerLastName = UserDefaults.standard.object(forKey: "lastName") as? String {
            

                self.shortName = trainerLastName
                
             }else{
                
                self.shortName = "Not Allow"

            }
        }
        let stringInputArr = self.shortName.components(separatedBy: " ")
        var stringNeed = ""

       for str in stringInputArr {
            if let char = str.first {
                stringNeed += String(char)
            }
        }
        
        self.shortName_Lbl.text = stringNeed
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        getProfileHandlerMethod()
        downloadingImageFromServer()
    }
    
    @IBAction func saveChangesBtnAction(_ sender: UIButton) {
        
        self.updateProfileHandlerMethod()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if email_Txt.text == "" || mobile_Txt.text!.count > 10 {
            
            self.saveButton.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            
        } else {
            
            self.saveButton.setBackgroundImage(UIImage(named: "Button_Bg"), for: .normal)
        }
    }
    
    @IBAction func logoutBtnAction(_ sender: UIButton) {
        
        // create the alert
        let alert = UIAlertController(title: "Logout", message: "Would you like to logout?", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
            
            // let domain = Bundle.main.bundleIdentifier!
            //UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.removeObject(forKey: "trainerLogin")
            UserDefaults.standard.removeObject(forKey: "mobile")
            UserDefaults.standard.removeObject(forKey: "emailId")
            UserDefaults.standard.removeObject(forKey: "firstName")
            UserDefaults.standard.removeObject(forKey: "lastName")
            
            UserDefaults.standard.removeObject(forKey: "trainerId")
            UserDefaults.standard.removeObject(forKey: "trainerGymId")
            UserDefaults.standard.removeObject(forKey: "trainerLogin")
            
            UserDefaults.standard.synchronize()
            
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func resetPasswordBtnAction(_ sender: UIButton) {
        
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
        objVC.isFormStr = "Trainer"
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    @IBAction func paymentBtnAction(_ sender: UIButton) {
        
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "PaymentDetailsVC") as! PaymentDetailsVC
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    
    @IBAction func profileBtnAction(_ sender: UIButton) {
        
       // self.cameraHandlerMethod()
        selectCameraAndPhotoActionCheat()

    }
    
    
    func downloadingImageFromServer(){
        
        if let id = UserDefaults.standard.object(forKey: "trainerId") as? Int {

        if let url = URL(string: "https://beapis.dieatto.com:8090/profilepic/download/TRN/\(id)") {
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
        
        Services.sharedInstance.customLoader(view: self.view, message: " Please wait")

        var trainerID = Int()
        
        if let id = UserDefaults.standard.object(forKey: "trainerId") as? Int {
            
            trainerID = id
            
        }else{
            
            
        }
        
        let urlString = TrinerUrlPath.sharedInstance.getUrlPath("dao/trainer/exclusive/\(trainerID)")
        
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
                
                if let firstName = dict.value(forKey: "trainerFirstName") as? String {
                    
                    self.userName_Txt.text = firstName
                    
                }
                if let lastName = dict.value(forKey: "trainerLastName") as? String {
                    
                    self.userLastName_Txt.text = lastName
                    
                }
                if let trainerGymLocation = dict.value(forKey: "trainerGymLocation") as? String {
                    
                    self.gymLocation_Txt.text = trainerGymLocation
                    
                }
                if let trainerGymName = dict.value(forKey: "trainerGymName") as? String {
                    
                    self.gymName_Txt.text = trainerGymName
                    
                }
                if let trainerCity = dict.value(forKey: "trainerCity") as? String {
                    
                    self.gymCity_Txt.text = trainerCity
                    
                }
                if let trainerPrimaryMob = dict.value(forKey: "trainerPrimaryMob") as? String {
                    
                    self.mobile_Txt.text = trainerPrimaryMob
                    
                }
                if let trainerEmail = dict.value(forKey: "trainerEmail") as? String {
                    
                    self.email_Txt.text = trainerEmail
                    
                }
                
            }
        }
        )
    }
    
    
    //MARK:- IMAGE SERVICE CALL
    func updateProfilePostSeriveCall()
    {
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")
        let trainerID = UserDefaults.standard.object(forKey: "trainerId") as! Int
        let gymID = UserDefaults.standard.object(forKey: "trainerGymId") as! Int

        let urlReq = "https://beapis.dieatto.com:8090/profilepic/upload"

        let imgData = self.profile_ImgView.image!.jpegData(compressionQuality: 0.2)!
        let headers = ["Content-type": "multipart/form-data",
                   "Content-Disposition" : "form-data"]

        let params = ["id":"\(trainerID)","userType":"TRN","gymId":"\(gymID)"] as [String : Any]

        print(params)
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "file",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in params {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                
            }
        },
                         to:urlReq)
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
                    self.downloadingImageFromServer()
                    //let status = responseData!["status"] as! Int
                    //let message: String = responseData!["message"] as! String
//                    if status == 1
//                    {
//
//                        print(responseData!)
//                        self.showToast(message: message)
//                    }
//                    else
//                    {
//                        self.showToast(message: message)
//                    }
//
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    func updateProfileHandlerMethod() {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")

        let trainerID = UserDefaults.standard.object(forKey: "trainerId") as! Int
        
        let profileImg = convertImageToBase64(image: self.profile_ImgView.image!)
    
        //let data = self.profile_ImgView.image
        //let profileImg = data?.jpegData(compressionQuality: 1.0)

        let params = ["trainerFirstName" :"\(userName_Txt.text!)","trainerLastName":"\(self.userLastName_Txt.text!)","trainerPrimaryMob":"\(self.mobile_Txt.text!)","trainerEmail":"\(self.email_Txt.text!)","id":"\(trainerID)", "trainerProfilePic": profileImg] as [String : Any]
        
        
        let urlString = TrinerUrlPath.sharedInstance.getUrlPath("dao/trainer/exclusive/update")
        
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
                let dict = dict_responce(dict: response)
                
                self.saveButton.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
                
                
                if status_Check(dict: dict)
                {
                    AlertSingletanClass.sharedInstance.validationAlert(title: "Profile Update", message: "You have successfully updated you profile.", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                        
                        print("Register response is ==\(dict)")
                    })
                    
                    
                }else
                {
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


extension ProfileVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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

