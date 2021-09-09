//
//  CovidVC.swift
//  Dieatto
//
//  Created by Developer Dev on 11/06/20.
//  Copyright © 2020 Developer Dev. All rights reserved.
//

import UIKit

class CovidVC: UIViewController {

    @IBOutlet var userName_Lbl: UILabel!
    @IBOutlet var headerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 2.0)

    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
    }

    @IBAction func notificationBtnAction(_ sender: UIButton) {
                
    let objVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
    self.navigationController?.pushViewController(objVC, animated: true)
        
    }
}
