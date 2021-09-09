//
//  UserMainTabVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 18/06/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

class UserMainTabVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let selectedColor   = #colorLiteral(red: 0.2823529412, green: 0.4823529412, blue: 0.8352941176, alpha: 1)
        let unselectedColor = #colorLiteral(red: 0.3450980392, green: 0.3450980392, blue: 0.3450980392, alpha: 1)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:selectedColor], for: .selected)
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
}
