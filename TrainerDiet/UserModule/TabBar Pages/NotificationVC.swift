//
//  NotificationVC.swift
//  Dieatto
//
//  Created by Developer Dev on 07/06/20.
//  Copyright © 2020 Developer Dev. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var notificationListview:UITableView!
    @IBOutlet weak var notificationview:UIView!
    
    @IBOutlet weak var name_Lbl:UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        
//        if let uname = USER_DEFAULTS.value(forKey: "firstName") as? String {
//
//            self.name_Lbl.text = "Hi,\(uname)"
//        }else{
//
//            self.name_Lbl.text = "Hi"
//        }
    }

@IBAction func closePostBtnAction(_ sender: UIButton) {

    
    if let navController = self.navigationController {
           
           navController.popViewController(animated: true)
       }
}
}

extension NotificationVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return 1
            
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTVCell", for: indexPath) as!
            NotificationsTVCell
            return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
            return 50//120

        }
    
}
