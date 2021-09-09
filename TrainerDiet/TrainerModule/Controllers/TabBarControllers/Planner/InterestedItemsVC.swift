////
////  InterestedItemsVC.swift
////  MoviesMagic
////
////  Created by laxman on 7/19/19.
////  Copyright © 2019 Rize. All rights reserved.
////
//
//import UIKit
//
//class InterestedItemsVC: UIViewController {
//    
//    var isNavigatedFrom = ""
//    
//    @IBOutlet var itemsCV: UICollectionView!
//    
//    var languagesArray = NSMutableArray()
//    
//    , actorsArray = NSMutableArray()
//    
//    , selectedLanguageArray = NSMutableArray()
//    
//    , selectedActorsArray = NSMutableArray()
//    
//    ,  appDelegate = UIApplication.shared.delegate as! AppDelegate
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Do any additional setup after loading the view.
//        
//        itemsCV.register(UINib(nibName: "CVFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier:"myFooterView")
//        
//        let layout = UICollectionViewCenterLayout()
//        itemsCV.collectionViewLayout = layout
//        
//        if isNavigatedFrom != "" {
//            
//            setupHeaderView()
//        }
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        
//        getLanguagesHandlerMethod()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        
//        if isNavigatedFrom != "" {
//            
//            if !DEVICE_TYPE_IPHONE {
//                
//                self.setStatusBar(color: APP_RED_COLOR)
//                
//                self.mmHeaderView.removeFromSuperview()
//                
//                mmHeaderView.frame = CGRect.init(x: 0, y: STATUS_BAR_HEIGHT, width: self.view.frame.width, height: 50)
//                
//                self.view.addSubview(mmHeaderView)
//            }
//        }
//    }
//    
//    // MARK:- setupHeaderView
//    
//    let mmHeaderView = Bundle.main.loadNibNamed("MMHeaderView", owner: self, options: nil)?[0] as! MMHeaderView
//    
//    func setupHeaderView() {
//        
//        self.setStatusBar(color: APP_RED_COLOR)
//        
//        mmHeaderView.frame = CGRect.init(x: 0, y: STATUS_BAR_HEIGHT, width: self.view.frame.width, height: 50)
//        
//        self.view.addSubview(mmHeaderView)
//        
//        mmHeaderView.setupData(title_str: "Favorites", showBack: false, showPointsAndNuggets: true, isHistory: false)
//        
//        mmHeaderView.delegate = self
//    }
//    
//    @IBAction func nextButtonAction(_ sender: Any) {
//        
//        if selectedLanguageArray.count == 0 {
//            
//            AlertSingletanClass.sharedInstance.validationAlert(title: "Movie Magic", message: "Please select atleast one Language.", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
//            })
//            
//        } else if selectedActorsArray.count == 0  {
//            
//            AlertSingletanClass.sharedInstance.validationAlert(title: "Movie Magic", message: "Please select atleast one Actor.", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
//            })
//        } else {
//            
//            setInterestedItemsHandlerMethod()
//        }
//    }
//    
//    func setInterestedItemsHandlerMethod() {
//        
//        AppDelegate().showCustomLoader(self)
//        
//        //5bf3e82f14649b21d2cf3140
//        
//        let params = ["player_id": String(describing:USER_DEFAULTS.value(forKey:"uid")!), "interested_languages": selectedLanguageArray, "interested_actors": selectedActorsArray] as [String : Any]
//        
//        let urlString = QuizUrlPaths.sharedInstance.getUrlPath("add-player-interest")
//        
//        QuizAPI.sharedInstance.QuizService_post_with_header(paramsDict: params as NSDictionary, urlPath:urlString,onCompletion: {
//            (response,error) -> Void in
//            
//            if let networkError = error {
//                AppDelegate().removeCustomLoader(self)
//                if (networkError.code == -1009) {
//                    print("No Internet \(String(describing: error))")
//                    AppDelegate().removeCustomLoader(self)
//                    AlertSingletanClass.sharedInstance.validationAlert(title: "No Internet".localized, message: "QUIZ_000".displayErrorMessageAlert(), preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
//                    })
//                    return
//                }
//            }
//            if response == nil{
//                AppDelegate().removeCustomLoader(self)
//                return
//            }else{
//                
//                AppDelegate().removeCustomLoader(self)
//                
//                let dict = response! as NSDictionary
//                
//                if dict.value(forKeyPath: "status") as! String == "success"
//                {
//                    //print(dict)
//                    
//                    let interestedLngsStr = self.selectedLanguageArray.componentsJoined(by: ",")
//                    
//                    USER_DEFAULTS.set(interestedLngsStr, forKey: "interestedLngsStr")
//                    
//                    USER_DEFAULTS.set("TutorialScreen", forKey: TUTORIAL_SCREEN)
//                    
//                    let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
//                    let nav = UINavigationController(rootViewController: homeViewController)
//                    self.appDelegate.window!.rootViewController = nav
//                    nav.setNavigationBarHidden(true, animated: false)
//                    
//                }else{
//                    
//                    if let data = dict.value(forKey: "err_code") as? String {
//                        
//                        AlertSingletanClass.sharedInstance.validationAlert(title: "Quiz".localized, message:data.displayErrorMessageAlert(), preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
//                        })
//                    }
//                }
//            }
//        })
//    }
//    
//    func getLanguagesHandlerMethod() {
//        
//        AppDelegate().showCustomLoader(self)
//        
//        //http://13.52.148.6:7994/distinct_movie_languages
//        
//        let params = ["": ""]
//        
//        let urlString = QuizUrlPaths.sharedInstance.getMoviesUrlPath("distinct_movie_languages")
//        
//        QuizAPI.sharedInstance.QuizService_get(paramsDict: params as NSDictionary, urlPath:urlString,onCompletion: {
//            (response,error) -> Void in
//            
//            if let networkError = error {
//                AppDelegate().removeCustomLoader(self)
//                if (networkError.code == -1009) {
//                    print("No Internet \(String(describing: error))")
//                    AppDelegate().removeCustomLoader(self)
//                    AlertSingletanClass.sharedInstance.validationAlert(title: "No Internet".localized, message: "QUIZ_000".displayErrorMessageAlert(), preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
//                    })
//                    return
//                }
//            }
//            if response == nil{
//                AppDelegate().removeCustomLoader(self)
//                return
//            }else{
//                
//                AppDelegate().removeCustomLoader(self)
//                
//                let dict = response! as NSDictionary
//                
//                if dict.value(forKeyPath: "status") as! String == "success"
//                {
//                    //print(dict)
//                    
//                    self.languagesArray.removeAllObjects()
//                    
//                    if let data = dict.value(forKey: "data") as? NSArray {
//                        
//                        self.languagesArray = data.mutableCopy() as! NSMutableArray
//                    }
//                    
//                    DispatchQueue.main.async {
//                        
//                        self.itemsCV.reloadData()
//                    }
//                    
//                }else{
//                    
//                    if let data = dict.value(forKey: "err_code") as? String {
//                        
//                        AlertSingletanClass.sharedInstance.validationAlert(title: "Quiz".localized, message:data.displayErrorMessageAlert(), preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
//                        })
//                    }
//                }
//            }
//        })
//    }
//    
//    func getInterestedItemsHandlerMethod() {
//        
//        AppDelegate().showCustomLoader(self)
//        
//        // **** Multiple Language
//        var params = NSDictionary()
//        
//        if let tempStrArray = selectedLanguageArray as NSArray as? [String] {
//            
//            // params = ["language": tempStrArray.joined(separator: ",")]
//            params = ["language": tempStrArray]
//        }
//        
//        // **** Single Language
//        //let params = ["language": selectedLanguageArray[0] as! String]
//        
//        let urlString = QuizUrlPaths.sharedInstance.getUrlPath("get-actors-by-language")
//        
//        // let urlString = "http://192.168.1.4:7999/movieapi/rc1/get-actors-by-language"
//        
//        QuizAPI.sharedInstance.QuizService_post_with_header(paramsDict: params as NSDictionary, urlPath:urlString,onCompletion: {
//            (response,error) -> Void in
//            
//            if let networkError = error {
//                AppDelegate().removeCustomLoader(self)
//                if (networkError.code == -1009) {
//                    print("No Internet \(String(describing: error))")
//                    AppDelegate().removeCustomLoader(self)
//                    AlertSingletanClass.sharedInstance.validationAlert(title: "No Internet".localized, message: "QUIZ_000".displayErrorMessageAlert(), preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
//                    })
//                    return
//                }
//            }
//            if response == nil{
//                AppDelegate().removeCustomLoader(self)
//                return
//            }else{
//                
//                AppDelegate().removeCustomLoader(self)
//                
//                let dict = response! as NSDictionary
//                
//                if dict.value(forKeyPath: "status") as! String == "success"
//                {
//                    //print(dict)
//                    
//                    self.actorsArray.removeAllObjects()
//                    
//                    if let data = dict.value(forKey: "fav_actors") as? NSArray {
//                        
//                        self.actorsArray = data.mutableCopy() as! NSMutableArray
//                    }
//                    
//                    DispatchQueue.main.async {
//                        
//                        self.itemsCV.reloadData()
//                    }
//                    
//                }else{
//                    
//                    self.actorsArray.removeAllObjects()
//                    
//                    DispatchQueue.main.async {
//                        
//                        self.itemsCV.reloadData()
//                    }
//                    
//                    if let data = dict.value(forKey: "err_code") as? String {
//                        
//                        AlertSingletanClass.sharedInstance.validationAlert(title: "Quiz".localized, message:data.displayErrorMessageAlert(), preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
//                        })
//                    }
//                }
//            }
//        })
//    }
//}
//
//extension InterestedItemsVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        
//        return 2
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//        if section == 0 {
//            
//            return languagesArray.count
//            
//        } else {
//            
//            return actorsArray.count
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemsCell", for: indexPath)
//        
//        let textLbl = cell.viewWithTag(1) as! UILabel
//        
//        var valueStr = String()
//        
//        if indexPath.section == 0 {
//            
//            valueStr = languagesArray[indexPath.row] as! String
//            
//            if selectedLanguageArray.contains(valueStr) {
//                
//                cell.backgroundColor = UIColor.init(hexString: "5CA833")
//                
//                textLbl.textColor = .white
//                
//            } else {
//                
//                cell.backgroundColor = .white
//                
//                textLbl.textColor = .black
//            }
//            
//        } else {
//            
//            let tempDict = actorsArray[indexPath.row] as! NSDictionary
//            
//            if let data = tempDict.value(forKey: "actor_name") as? String {
//                
//                valueStr = data
//            }
//            
//            if let data = tempDict.value(forKey: "actor_id") as? String {
//                
//                if selectedActorsArray.contains(data) {
//                    
//                    cell.backgroundColor = UIColor.init(hexString: "5CA833")
//                    
//                    textLbl.textColor = .white
//                    
//                } else {
//                    
//                    cell.backgroundColor = .white
//                    
//                    textLbl.textColor = .black
//                }
//            }
//        }
//        
//        textLbl.text = valueStr
//        
//        cell.layer.cornerRadius = 15
//        
//        cell.layer.borderWidth = 1.0
//        
//        cell.layer.borderColor = UIColor.init(hexString: "9A9A9A").cgColor
//        
//        cell.clipsToBounds = true
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        if indexPath.section == 0 {
//            
//            // For multiple remove this line
//            // selectedLanguageArray.removeAllObjects()
//            
//            if selectedLanguageArray.contains(languagesArray[indexPath.row] as! String) {
//                
//                selectedLanguageArray.remove(languagesArray[indexPath.row] as! String)
//                
//            } else {
//                
//                selectedLanguageArray.add(languagesArray[indexPath.row] as! String)
//            }
//            
//            getInterestedItemsHandlerMethod()
//            
//        } else {
//            
//            let tempDict = actorsArray[indexPath.row] as! NSDictionary
//            
//            if let data = tempDict.value(forKey: "actor_id") as? String {
//                
//                if selectedActorsArray.contains(data) {
//                    
//                    selectedActorsArray.remove(data)
//                    
//                } else {
//                    
//                    selectedActorsArray.add(data)
//                }
//            }
//        }
//        
//        UIView.performWithoutAnimation {
//            
//            itemsCV.reloadItems(at: [indexPath])
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        
//        if kind == UICollectionView.elementKindSectionFooter {
//            
//            let myFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "myFooterView", for: indexPath)
//            // configure footer view
//            if let headingLbl = myFooterView.viewWithTag(1) as? UILabel {
//                
//                headingLbl.isHidden = true
//            }
//            
//            if let lineLbl = myFooterView.viewWithTag(2) as? UILabel {
//                
//                lineLbl.isHidden = false
//            }
//            return myFooterView
//            
//        } else {
//            
//            return UICollectionReusableView()
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        
//        if section == 0 {
//            
//            return CGSize(width: self.view.frame.width, height: 40.0)
//        }
//        
//        return CGSize(width: self.view.frame.width, height: 0.0)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        
//        return CGSize(width: self.view.frame.width, height: 0.0)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        var valueStr = String()
//        
//        if indexPath.section == 0 {
//            
//            if languagesArray.count > 0 {
//                
//                valueStr = languagesArray[indexPath.row] as! String
//                
//            } else {
//                
//                return CGSize(width: 0, height: 0)
//            }
//            
//        } else {
//            
//            if actorsArray.count > 0 {
//                
//                let tempDict = actorsArray[indexPath.row] as! NSDictionary
//                
//                if let data = tempDict.value(forKey: "actor_name") as? String {
//                    
//                    valueStr = data
//                }
//                
//            } else {
//                
//                return CGSize(width: 0, height: 0)
//            }
//        }
//        
//        let fontAttributes = [NSAttributedString.Key.font: UIFont(name:"Poppins-Regular", size:15)!]
//        
//        let myText = valueStr
//        
//        let size = (myText as NSString).size(withAttributes: fontAttributes)
//        
//        return CGSize(width: size.width + 20, height: 30)
//    }
//}
//
//extension InterestedItemsVC : MMHeaderViewDelegate {
//    
//    func tappingButtonHandlerMethod(type: String) {
//        
//        print(type)
//        
//        if type == "Back" {
//            
//            self.navigationController?.popViewController(animated: true)
//            
//        } else if type == "Points" {
//            
//            let objVC = self.storyboard?.instantiateViewController(withIdentifier:"NuggetsHistoryVC") as! NuggetsHistoryVC
//            
//            objVC.isFrom = "Points"
//            
//            self.navigationController?.pushViewController(objVC, animated:true)
//            
//        } else {
//            
//            let objVC = self.storyboard?.instantiateViewController(withIdentifier:"NuggetsHistoryVC") as! NuggetsHistoryVC
//            
//            objVC.isFrom = "Nuggets"
//            
//            self.navigationController?.pushViewController(objVC, animated:true)
//        }
//        
//    }
//}
