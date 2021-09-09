//
//  InitialVC.swift
//  MoviesMagic
//
//  Created by laxman on 7/17/19.
//  Copyright © 2019 Rize. All rights reserved.
//

import UIKit

class InitialVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func getStartedBtnAction(_ sender: UIButton) {
        
       // let objVC = storyboard?.instantiateViewController(withIdentifier: "SignupOptionsVC") as! SignupOptionsVC
        
        //self.navigationController?.pushViewController(objVC, animated: true)
        
       // self.present(objVC, animated: true, completion: nil)
    }
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        
       // let objVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        
        //self.navigationController?.pushViewController(objVC, animated: true)
        
        //self.present(objVC, animated: true, completion: nil)
    }
}
