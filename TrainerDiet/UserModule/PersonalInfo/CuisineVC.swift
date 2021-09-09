//
//  CuisineVC.swift
//  Dieatto
//
//  Created by Developer Dev on 05/06/20.
//  Copyright © 2020 Developer Dev. All rights reserved.
//

import UIKit

class CuisineVC: UIViewController {

    @IBOutlet var shadowView: UIView!
    @IBOutlet var foodselectBtn1: UIButton!
    @IBOutlet var foodselectBtn2: UIButton!
    @IBOutlet var foodselectBtn3: UIButton!
    @IBOutlet var foodselectBtn4: UIButton!
    @IBOutlet var foodselectBtn5: UIButton!
    @IBOutlet var foodselectBtn6: UIButton!

    @IBOutlet var continueBtn: UIButton!

    var foodSelectStr = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        shadowView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
    }
    
    @IBAction func foodSelectBtnAction(_ sender: UIButton) {
           
        if sender.tag == 1 {
            
        self.foodselectBtn2.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
        self.foodselectBtn1.setBackgroundImage(UIImage(named: "Button_Bg"), for: .normal)
        self.foodselectBtn3.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
        self.foodselectBtn4.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
        self.foodselectBtn5.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
        self.foodselectBtn6.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)

        self.foodSelectStr = "1"
            
        }else if sender.tag == 2 {
            self.foodselectBtn1.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.foodselectBtn2.setBackgroundImage(UIImage(named: "Button_Bg"), for: .normal)
            self.foodselectBtn3.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.foodselectBtn4.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.foodselectBtn5.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.foodselectBtn6.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)

            self.foodSelectStr = "2"

        }else if sender.tag == 3 {
            
            self.foodselectBtn2.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.foodselectBtn3.setBackgroundImage(UIImage(named: "Button_Bg"), for: .normal)
            self.foodselectBtn1.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.foodselectBtn4.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.foodselectBtn5.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.foodselectBtn6.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)

            self.foodSelectStr = "3"
            
        }else if sender.tag == 4 {
            
           self.foodselectBtn2.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.foodselectBtn4.setBackgroundImage(UIImage(named: "Button_Bg"), for: .normal)
            self.foodselectBtn3.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.foodselectBtn1.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.foodselectBtn5.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.foodselectBtn6.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)

            self.foodSelectStr = "4"
        }else if sender.tag == 5 {
            
           self.foodselectBtn2.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.foodselectBtn5.setBackgroundImage(UIImage(named: "Button_Bg"), for: .normal)
            self.foodselectBtn3.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.foodselectBtn1.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.foodselectBtn1.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.foodselectBtn6.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)

            self.foodSelectStr = "5"
        }
        else{
            self.foodselectBtn2.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.foodselectBtn6.setBackgroundImage(UIImage(named: "Button_Bg"), for: .normal)
            self.foodselectBtn3.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.foodselectBtn4.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.foodselectBtn5.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.foodselectBtn1.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)

            self.foodSelectStr = "6"
            
        }
           
    }
    @IBAction func continueBtnAction(_ sender: UIButton) {
        
        SubPersonalDict.personalDict["subCuisinePreferrence"] = self.foodSelectStr
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "GoalsVC") as! GoalsVC
        
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)

    }

}
