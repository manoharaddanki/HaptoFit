//
//  ProcessingVC.swift
//  Dieatto
//
//  Created by Developer Dev on 07/06/20.
//  Copyright © 2020 Developer Dev. All rights reserved.
//

import UIKit

class ProcessingVC: UIViewController {

    var gameTimer: Timer! //Timer object

    override func viewDidLoad() {
        super.viewDidLoad()

        gameTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timeaction), userInfo: nil, repeats: true)

    }
    
    
    //Timer action
    @objc func timeaction(){

          let objVC = storyboard?.instantiateViewController(withIdentifier: "UserMainTabVC") as! UserMainTabVC

           UserDefaults.standard.set(true, forKey: "personalInfo")

            self.navigationController?.pushViewController(objVC, animated: true)
           gameTimer.invalidate()//after that timer invalid

       }

}
