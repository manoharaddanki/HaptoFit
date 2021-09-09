//
//  PhysicalActivityVC.swift
//  Dieatto
//
//  Created by Developer Dev on 19/10/19.
//  Copyright © 2019 Developer Dev. All rights reserved.
//

import UIKit

class PhysicalActivityVC: UIViewController {

    @IBOutlet var shadowView: UIView!
    @IBOutlet var time15MinBtn: UIButton!
    @IBOutlet var tim30MinBtn: UIButton!
    @IBOutlet var time45MinBtn: UIButton!
    @IBOutlet var time60MinBtn: UIButton!
    @IBOutlet var time90MinBtn: UIButton!

    @IBOutlet var continueBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        shadowView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
    }
    
    @IBAction func timeSelectBtnAction(_ sender: UIButton) {
           
        if sender.tag == 1 {
            
        self.tim30MinBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
        self.time15MinBtn.setBackgroundImage(UIImage(named: "Button_Bg"), for: .normal)
        self.time45MinBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
        self.time60MinBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
        self.time90MinBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)

            
        }else if sender.tag == 2 {
            
            self.tim30MinBtn.setBackgroundImage(UIImage(named: "Button_Bg"), for: .normal)
            self.time15MinBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.time45MinBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.time60MinBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.time90MinBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            
        }else if sender.tag == 3 {
            
            self.tim30MinBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.time15MinBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.time45MinBtn.setBackgroundImage(UIImage(named: "Button_Bg"), for: .normal)
            self.time60MinBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.time90MinBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            
        }else if sender.tag == 3 {
            
            self.tim30MinBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.time15MinBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.time45MinBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.time60MinBtn.setBackgroundImage(UIImage(named: "Button_Bg"), for: .normal)
            self.time90MinBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            
        }else{
            
            self.tim30MinBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.time15MinBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.time45MinBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.time60MinBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            self.time90MinBtn.setBackgroundImage(UIImage(named: "Button_Bg"), for: .normal)
            
        }
           
    }
    @IBAction func continueBtnAction(_ sender: UIButton) {
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "PhysicalActivityLiftVC") as! PhysicalActivityLiftVC
        
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)

    }

}
