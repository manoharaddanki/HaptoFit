//
//  ThanksVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 05/07/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

class ThanksVC: UIViewController {

    var isFrom = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func proceedBtn_Action(_ sender: UIButton) {
        
        if isFrom == "UnauthorisedLogin" {
            
            self.navigationController?.popViewController(animated: true)
            
        }else{
        
        let viewControllers = self.navigationController!.viewControllers as [UIViewController];
        for aViewController:UIViewController in viewControllers {
            if aViewController.isKind(of: TrainerLoginVC.self) {
                _ = self.navigationController?.popToViewController(aViewController, animated: true)
            }
        }
        }
    }
}
