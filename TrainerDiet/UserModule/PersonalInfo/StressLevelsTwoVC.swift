//
//  StressLevelsTwoVC.swift
//  Dieatto
//
//  Created by Developer Dev on 05/06/20.
//  Copyright © 2020 Developer Dev. All rights reserved.
//

import UIKit

class StressLevelsTwoVC: UIViewController {
    
    @IBOutlet var shadowView: UIView!
    @IBOutlet var slider1: UISlider!
    @IBOutlet var slider2: UISlider!
    @IBOutlet var slider3: UISlider!
    @IBOutlet var slider4: UISlider!
    
    
    @IBOutlet weak var continueBtn: UIButton!
    
    var finalStressScore = Int()
    
    var q1 = Int()
    var q2 = Int()
    var q3 = Int()
    var q4 = Int()
    var q5 = Int()
    var q6 = Int()
    var q7 = Int()
    var q8 = Int()
    var q9 = Int()
    
    var currentDate = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        shadowView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        currentDate = formatter.string(from: date)
        
        print("personal Info Dict ==>\(SubPersonalDict.personalDict)")
        
        slider1.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
        slider2.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
        slider3.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
        slider4.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
        
        
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
        } else {
            newValue = 3;
        }
        slider1.value = Float(newValue);
        self.q6 = Int(slider1.value)
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
        } else {
            newValue = 3;
        }
        slider2.value = Float(newValue);
        self.q7 = Int(slider2.value)
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
        self.q8 = Int(slider3.value)
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
        self.q9 = Int(slider4.value)
        
    }
    
    @IBAction func continueBtnAction(_ sender: UIButton) {
        
        let finalScore = (self.finalStressScore + self.q6 + q7 + q8 + q9)
        
        let result = Int((Double(finalScore)/Double(27))*100)
        
        self.stressScoreHandlerMethod(score: result)
        
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func enableContinueBtn(){
        
        
        if self.q6 == 0 && self.q7 == 0 && self.q8 == 0 && self.q9 == 0  {
            
            self.continueBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            
        }else{
            
            self.continueBtn.setBackgroundImage(UIImage(named: "Rectangle -3"), for: .normal)
            
        }
    }
    
    func stressScoreHandlerMethod(score : Int) {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")
        
        let subId = UserDefaults.standard.object(forKey: "subId") as? Int
        
        let params = ["subId":"\(subId!)","stress_q1" :q1,"stress_q2":q2,"stress_q3":q3,"stress_q4":q4,"stress_q5":q5,"stress_q6":q6,"stress_q7":q7,"stress_q8":q8,"stress_q9" : q9,"stressScore": score] as [String : Any]
        
        print("Stress params == >\(params)")
        let urlString = "https://beapis.dieatto.com:8090/dao/wellnessscore/updateStressScore"
        
        TrinerAPI.sharedInstance.TrainerService_put_with_header(paramsDict: params as NSDictionary, urlPath:urlString,onCompletion: {
            (response,error) -> Void in
            
            if let networkError = error {
                
                Services.sharedInstance.dissMissLoader()
                
                if (networkError.code == -1009) {
                    print("No Internet \(String(describing: error))")
                    Services.sharedInstance.dissMissLoader()
                    AlertSingletanClass.sharedInstance.validationAlert(title: "No Internet", message: "", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
                    })
                    
                    return
                }
            }
            
            //            ScoreCard.stress = Int((Double(score) / 27) * (100))
            //            let stressScore = Int((Double(score) / 27) * (100))
            //            UserDefaults.standard.set(stressScore, forKey: "stressScore")
            //            UserDefaults.standard.set(self.currentDate, forKey: "stressLevelDate")
            
            
            let dict = dict_responce(dict: response)
            Services.sharedInstance.dissMissLoader()
            
            if dict.value(forKey: "status") as? Int == 500 {
                
                
                
            }else{
                
                self.showToast(message: "Submitted successfully")
                //UserDefaults.standard.set(score, forKey: "stressScore")

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    
                    //self.navigationController?.popViewController(animated: true)
                    
                    let objVC = self.storyboard?.instantiateViewController(withIdentifier: "UserMainTabVC") as! UserMainTabVC
                    self.navigationController?.pushViewController(objVC, animated: true)
                    
                }
                
                
            }
            
        }
        )
    }
    
    
}
