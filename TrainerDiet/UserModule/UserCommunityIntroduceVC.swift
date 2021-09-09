//
//  UserCommunityIntroduceVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 17/07/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit


struct UserIntroduce {

    static var userIntrProceedFlag:Bool = false
}
class UserCommunityIntroduceVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.tabBarController?.tabBar.isHidden = true
        
        
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
          
        self.dismiss(animated: true, completion: nil)
          
      }
    
    @IBAction func procedBtnAction(_ sender: UIButton) {
          
            let objVC = storyboard?.instantiateViewController(withIdentifier: "UserCommunityListVC") as! UserCommunityListVC
        UserIntroduce.userIntrProceedFlag = true
          self.navigationController?.pushViewController(objVC, animated: true)

      }

}
