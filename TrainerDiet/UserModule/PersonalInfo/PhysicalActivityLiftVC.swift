//
//  PhysicalActivityLiftVC.swift
//  Dieatto
//
//  Created by M Venkat  Rao on 10/22/19.
//  Copyright © 2019 Developer Dev. All rights reserved.
//

import UIKit

class PhysicalActivityLiftVC: UIViewController {

    @IBOutlet var shadowView: UIView!

    @IBOutlet var lightWeightBtn: UIButton!
    @IBOutlet var mediumWeightBtn: UIButton!
    @IBOutlet var heavyWeigthBtn: UIButton!

    @IBOutlet var continueBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        shadowView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
    }
    
    @IBAction func weightLiftSelectBtnAction(_ sender: UIButton) {
           
        if sender.tag == 1 {
            
        self.lightWeightBtn.setBackgroundImage(UIImage(named: "Button_Bg"), for: .normal)
        self.mediumWeightBtn.setBackgroundImage(UIImage(named: "Rectangle -10"), for: .normal)
        self.heavyWeigthBtn.setBackgroundImage(UIImage(named: "Rectangle -10"), for: .normal)

            
        }else if sender.tag == 2 {
            
           self.lightWeightBtn.setBackgroundImage(UIImage(named: "Rectangle -10"), for: .normal)
            self.mediumWeightBtn.setBackgroundImage(UIImage(named: "Button_Bg"), for: .normal)
            self.heavyWeigthBtn.setBackgroundImage(UIImage(named: "Rectangle -10"), for: .normal)
            
        }else{
            
           self.lightWeightBtn.setBackgroundImage(UIImage(named: "Rectangle -10"), for: .normal)
            self.mediumWeightBtn.setBackgroundImage(UIImage(named: "Rectangle -10"), for: .normal)
            self.heavyWeigthBtn.setBackgroundImage(UIImage(named: "Button_Bg"), for: .normal)
            
        }
           
    }
    
    @IBAction func continueBtnAction(_ sender: UIButton) {
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "SleepVC") as! SleepVC
        
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
       self.navigationController?.popViewController(animated: true)
        
    }

}
