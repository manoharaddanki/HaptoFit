//
//  UserGenderVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 18/06/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

class UserGenderVC: UIViewController {
    
    @IBOutlet var male_imgView: UIImageView!
    @IBOutlet var feMale_imgView: UIImageView!
    @IBOutlet var continue_Btn: UIButton!
    
    var genderType = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func gendersBtnAction(_ sender: UIButton) {
        
        if sender.tag == 1 {
            
            self.male_imgView.image = UIImage(named: "male-active")
            self.feMale_imgView.image = UIImage(named: "female-unactive")
            continue_Btn.setBackgroundImage(UIImage(named: "continue_Bule"), for: UIControl.State.normal)
            
            self.genderType = "Male"
        }else{
            
            self.male_imgView.image = UIImage(named: "male-unactive")
            self.feMale_imgView.image = UIImage(named: "female-active")
            continue_Btn.setBackgroundImage(UIImage(named: "continue_Bule"), for: UIControl.State.normal)
            
            self.genderType = "Female"
            
        }
        
    }
    
    @IBAction func continueBtnAction(_ sender: UIButton) {
        
        
        if self.genderType == "" {
            
            self.showToast(message: "Please select gender type")
            
        }else{
            
            SubPersonalDict.personalDict["subsGender"] = self.genderType
            
            let objVC = storyboard?.instantiateViewController(withIdentifier: "FoodTypeVC") as! FoodTypeVC
            
            self.navigationController?.pushViewController(objVC, animated: true)
            
            
        }
        
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
