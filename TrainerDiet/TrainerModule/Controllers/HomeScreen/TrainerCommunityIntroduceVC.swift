//
//  TrainerCommunityIntroduceVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 17/07/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

struct TrainerIntroduce {
    
    static var proceed: Bool = false
}


class TrainerCommunityIntroduceVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true

    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {

        self.navigationController?.popViewController(animated: true)
        
      }
    
    @IBAction func procedBtnAction(_ sender: UIButton) {
          
            TrainerIntroduce.proceed = true
        
            let objVC = storyboard?.instantiateViewController(withIdentifier: "HomeStremmingViewController") as! HomeStremmingViewController
          self.navigationController?.pushViewController(objVC, animated: true)

        
      }

}
