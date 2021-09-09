//
//  StressLevelsVC.swift
//  Dieatto
//
//  Created by Developer Dev on 05/06/20.
//  Copyright © 2020 Developer Dev. All rights reserved.
//

import UIKit

class StressLevelsVC: UIViewController {
    
    @IBOutlet var shadowView: UIView!
    @IBOutlet var slider1: UISlider!
    @IBOutlet var slider2: UISlider!
    @IBOutlet var slider3: UISlider!
    @IBOutlet var slider4: UISlider!
    @IBOutlet var slider5: UISlider!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    var stressScore = Int()
    
    var sliderVal1 = Int()
    var sliderVal2 = Int()
    var sliderVal3 = Int()
    var sliderVal4 = Int()
    var sliderVal5 = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        shadowView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
        
        print("personal Info Dict ==>\(SubPersonalDict.personalDict)")
        
        slider1.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
        slider2.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
        slider3.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
        slider4.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
        slider5.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
        
    }
    @IBAction func slider1BtnAction(_ sender: Any) {
        
        var newValue = 0
        
        if (slider1.value < 0.5) {
            newValue = 0;
        }
        else if (slider1.value <= 1.3) {
            newValue = 1;
        }
        else if (slider1.value <= 2.3) {
            newValue = 2;
        }else {
            newValue = 3;
        }
        slider1.value = Float(newValue);
        self.sliderVal1 = Int(slider1.value)
    }
    
    @IBAction func slider2BtnAction(_ sender: Any) {
        
        var newValue = 0
        
        if (slider2.value < 0.5) {
            newValue = 0;
        }
        else if (slider2.value <= 1.3) {
            newValue = 1;
        }
        else if (slider2.value <= 2.3) {
            newValue = 2;
        }else {
            newValue = 3;
        }
        slider2.value = Float(newValue);
        self.sliderVal2 = Int(slider2.value)
    }
    
    
    @IBAction func slider3BtnAction(_ sender: Any) {
        
        var newValue = 0
        
        if (slider3.value < 0.5) {
            newValue = 0;
        }
        else if (slider3.value <= 1.3) {
            newValue = 1;
        }
        else if (slider3.value <= 2.3) {
            newValue = 2;
        } else {
            newValue = 3;
        }
        slider3.value = Float(newValue);
        self.sliderVal3 = Int(slider3.value)
    }
    
    @IBAction func slider4BtnAction(_ sender: Any) {
        var newValue = 0
        
        if (slider4.value < 0.5) {
            newValue = 0;
        }
        else if (slider4.value <= 1.3) {
            newValue = 1;
        }
        else if (slider4.value <= 2.3) {
            newValue = 2;
        } else {
            newValue = 3;
        }
        slider4.value = Float(newValue);
        self.sliderVal4 = Int(slider4.value)
    }
    
    @IBAction func slider5BtnAction(_ sender: Any) {
        
        var newValue = 0
        
        if (slider5.value < 0.5) {
            newValue = 0;
        }
        else if (slider5.value <= 1.3) {
            newValue = 1;
        }
        else if (slider5.value <= 2.3) {
            newValue = 2;
        } else {
            newValue = 3;
        }
        slider5.value = Float(newValue);
        self.sliderVal5 = Int(slider5.value)
        
    }
    
    func enableContinueBtn(){
        
        
        if self.sliderVal1 == 0 && self.sliderVal2 == 0 && self.sliderVal3 == 0 && self.sliderVal4 == 0 && self.sliderVal5 == 0 {
            
            self.continueBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            
        }else{
            
            self.continueBtn.setBackgroundImage(UIImage(named: "Rectangle -3"), for: .normal)
            
        }
    }
    
    @IBAction func continueBtnAction(_ sender: UIButton) {
        
        
        
        self.stressScore = (self.sliderVal1 + self.sliderVal2 + self.sliderVal3 + self.sliderVal4 + self.sliderVal5)
        
        let objVC = storyboard?.instantiateViewController(withIdentifier: "StressLevelsTwoVC") as! StressLevelsTwoVC
        
        objVC.finalStressScore = self.stressScore
        objVC.q1 = self.sliderVal1
        objVC.q2 = self.sliderVal2
        objVC.q3 = self.sliderVal3
        objVC.q4 = self.sliderVal4
        objVC.q5 = self.sliderVal5
        
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
