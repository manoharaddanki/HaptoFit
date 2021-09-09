//
//  FoodTypeVC.swift
//  Dieatto
//
//  Created by Developer Dev on 19/10/19.
//  Copyright © 2019 Developer Dev. All rights reserved.
//

import UIKit

class FoodTypeVC: UIViewController {
    
    @IBOutlet var veg_imgView: UIImageView!
    @IBOutlet var nonVeg_imgView: UIImageView!
    @IBOutlet var eggVeg_imgView: UIImageView!
    
    @IBOutlet var continue_Btn: UIButton!
    
    
    var foodChoiceStr = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func foodSelectBtnAction(_ sender: UIButton) {
        
        if sender.tag == 1 {
            
            self.veg_imgView.image = UIImage(named: "vegeteraian-unactive")
            self.nonVeg_imgView.image = UIImage(named: "NonVegeterian-unactive")
            self.eggVeg_imgView.image = UIImage(named: "circle-Eggeterian")
            
            self.foodChoiceStr = "0"
            continue_Btn.setBackgroundImage(UIImage(named: "continue_Bule"), for: UIControl.State.normal)
            
        } else if sender.tag == 2 {
            
            self.veg_imgView.image = UIImage(named: "vegeteraian-unactive")
            self.nonVeg_imgView.image = UIImage(named: "NonVegeterian-active")
            self.eggVeg_imgView.image = UIImage(named: "circle-Eggeterian")
            self.foodChoiceStr = "1"
            
            continue_Btn.setBackgroundImage(UIImage(named: "continue_Bule"), for: UIControl.State.normal)
            
        }
        else{
            
            self.veg_imgView.image = UIImage(named: "vegeteraian-unactive")
            self.nonVeg_imgView.image = UIImage(named: "NonVegeterian-unactive")
            self.eggVeg_imgView.image = UIImage(named: "Eggeterian-active")
            self.foodChoiceStr = "2"
            
            continue_Btn.setBackgroundImage(UIImage(named: "continue_Bule"), for: UIControl.State.normal)
            
            
        }
        
    }
    
    
    @IBAction func continueBtnAction(_ sender: UIButton) {
        
        if self.foodChoiceStr == "" {
            
            self.showToast(message: "Please select food type")
            
        }else{
            
            SubPersonalDict.personalDict["subFoodChoice"] = self.foodChoiceStr
            
            let objVC = storyboard?.instantiateViewController(withIdentifier: "PersonalInfoVC") as! PersonalInfoVC
            
            self.navigationController?.pushViewController(objVC, animated: true)
            
        }
        
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
}
