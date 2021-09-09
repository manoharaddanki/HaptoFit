//
//  GeneralActivityVC.swift
//  Dieatto
//
//  Created by Developer Dev on 19/10/19.
//  Copyright © 2019 Developer Dev. All rights reserved.
//

import UIKit

struct ScoreCard {
    
    static var sleep = Int()
    static var stress = Int()
    static var wellness = Int()
    
}

class SleepVC: UIViewController {
    
    @IBOutlet var shadowView: UIView!
    @IBOutlet var slider1: UISlider!
    @IBOutlet var slider2: UISlider!
    @IBOutlet var slider3: UISlider!
    @IBOutlet var slider4: UISlider!
    @IBOutlet var slider5: UISlider!
    @IBOutlet var slider6: UISlider!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    
    var sleepScore = Int(), sliderVal1 = 1,sliderVal2 = 1,sliderVal3 = 1,sliderVal4 = 1, sliderVal5 = 1, sliderVal6 = 1
    
    var currentDate = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        shadowView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
        
        slider1.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
        slider2.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
        slider3.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
        slider4.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
        slider5.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
        slider6.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)

        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        currentDate = formatter.string(from: date)
        
        print("personal Info Dict ==>\(SubPersonalDict.personalDict)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.tabBarController?.tabBar.isHidden = true
        
    }
    @IBAction func slider1BtnAction(_ sender: UISlider) {
        
          var newValue = 1

          if (slider1.value < 2) {
            newValue = 1;
           }
            else if (slider1.value < 3) {
               newValue = 2;
           } else if (slider1.value < 4) {
               newValue = 3;
           } else if (slider1.value < 5) {
               newValue = 4;
           } else {
               newValue = 5;
           }
        slider1.value = Float(newValue);
        self.sliderVal1 = Int(slider1.value)
        
    }
    
    @IBAction func slider2BtnAction(_ sender: UISlider) {
        
        var newValue = 1

              if (slider2.value < 2) {
                newValue = 1;
               }
                else if (slider2.value < 3) {
                   newValue = 2;
               } else if (slider2.value < 4) {
                   newValue = 3;
               } else if (slider2.value < 5) {
                   newValue = 4;
               } else {
                   newValue = 5;
               }
            slider2.value = Float(newValue);
            self.sliderVal2 = Int(slider2.value)
    }
    
    
    @IBAction func slider3BtnAction(_ sender: UISlider) {
        
        var newValue = 1

              if (slider3.value < 2) {
                newValue = 1;
               }
                else if (slider3.value < 3) {
                   newValue = 2;
               } else if (slider3.value < 4) {
                   newValue = 3;
               } else if (slider3.value < 5) {
                   newValue = 4;
               } else {
                   newValue = 5;
               }
            slider3.value = Float(newValue);
            self.sliderVal3 = Int(slider3.value)
    }
    
    @IBAction func slider4BtnAction(_ sender: UISlider) {
        
        var newValue = 1

              if (slider4.value < 2) {
                newValue = 1;
               }
                else if (slider4.value < 3) {
                   newValue = 2;
               } else if (slider4.value < 4) {
                   newValue = 3;
               } else if (slider4.value < 5) {
                   newValue = 4;
               } else {
                   newValue = 5;
               }
            slider4.value = Float(newValue);
            self.sliderVal4 = Int(slider4.value)
        
    }
    
    @IBAction func slider5BtnAction(_ sender: UISlider) {
        
        //self.sliderVal5 = gettingSliderVal(sliderTxt: slider5, txtVal: slider5.value)
        
        var newValue = 1

              if (slider5.value < 2) {
                newValue = 1;
               }
                else if (slider5.value < 3) {
                   newValue = 2;
               } else if (slider5.value < 4) {
                   newValue = 3;
               } else if (slider5.value < 5) {
                   newValue = 4;
               } else {
                   newValue = 5;
               }
            slider5.value = Float(newValue);
            self.sliderVal5 = Int(slider5.value)
    }
    @IBAction func slider6BtnACtion(_ sender: UISlider) {
        
        //self.sliderVal6 = gettingSliderVal(sliderTxt: slider6, txtVal: slider6.value)
        
        var newValue = 1

              if (slider6.value < 2) {
                newValue = 1;
               }
                else if (slider6.value < 3) {
                   newValue = 2;
               } else if (slider6.value < 4) {
                   newValue = 3;
               } else if (slider6.value < 5) {
                   newValue = 4;
               } else {
                   newValue = 5;
               }
            slider6.value = Float(newValue);
            self.sliderVal6 = Int(slider6.value)
    }
    @IBAction func continueBtnAction(_ sender: UIButton) {
        
        
        let result = (self.sliderVal1 + self.sliderVal2 + (6 - self.sliderVal3) + (6 - self.sliderVal4) + (6 - self.sliderVal5) + (6 - self.sliderVal6))
        
        self.sleepScore = Int((Double(result)/Double(30))*100)

        print("final score is ==>\(sleepScore)")
        self.sleepScoreHandlerMethod(score: sleepScore)
        
        
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func gettingSliderVal(sliderTxt: UISlider, txtVal : Float) -> Int {
        
                 var newValue = 1

                 if (txtVal <= 1) {
                    newValue = 1
                  }
                   else if (txtVal <= 2) {
                       newValue = 2
                  } else if (txtVal <= 3) {
                       newValue = 3
                  } else if (txtVal <= 4) {
                       newValue = 4
                  } else {
                       newValue = 5
                  }
        sliderTxt.value = Float(newValue)
        return newValue
    }
    
    func enableContinueBtn(){
        
        
        if self.sliderVal1 == 1 || self.sliderVal2 == 1 || self.sliderVal3 == 1 || self.sliderVal4 == 1 || self.sliderVal5 == 1 || self.sliderVal6 == 1 {
            
            self.continueBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
            
        }else{
            
            self.continueBtn.setBackgroundImage(UIImage(named: "Rectangle -3"), for: .normal)
            
        }
    }
    
    func sleepScoreHandlerMethod(score : Int) {
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")

        let subId = UserDefaults.standard.object(forKey: "subId") as? Int
        
        let params = ["subId":"\(subId!)","sleep_q1" :self.sliderVal1,"sleep_q2":self.sliderVal2,"sleep_q3":self.sliderVal3,"sleep_q4":self.sliderVal4,"sleep_q5":self.sliderVal5,"sleep_q6":self.sliderVal6,"sleepScore": score] as [String : Any]
        
        print("Sleep params == >\(params)")
        
        let urlString = "https://beapis.dieatto.com:8090/dao/wellnessscore/updateSleepScore"
        
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
            
            Services.sharedInstance.dissMissLoader()
            let dict = dict_responce(dict: response)
                           
            if dict.value(forKey: "status") as? Int == 500 {
                               
                
                               
            }else{
            
                self.showToast(message: "Submitted successfully")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {

                self.navigationController?.popViewController(animated: true)

                }
            }
            //ScoreCard.sleep = Int((Double(self.sleepScore) / 30) * (100))
            //let sleepScore = Int((Double(self.sleepScore) / 30) * (100))
           // UserDefaults.standard.set(score, forKey: "sleepScore")
//            UserDefaults.standard.set(self.currentDate, forKey: "sleepDate")

            
//            if response == nil
//            {
//                Services.sharedInstance.dissMissLoader()
//                return
//            }else
//            {
//                let dict = dict_responce(dict: response)
//
//                if status_Check(dict: dict)
//                {
//                    AlertSingletanClass.sharedInstance.validationAlert(title: "Success", message: "You have successfully register your account. Please login.", preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
//
//                        print("Register response is ==\(dict)")
//                    })
//
//
//                }else
//                {
//                    if let err_code = dict.value(forKeyPath: "error") as? String {
//
//                        AlertSingletanClass.sharedInstance.validationAlert(title: "Error", message: err_code, preferredStyle: UIAlertController.Style.alert, okLabel: "OK", targetViewController: self, okHandler:  { (action) -> Void in
//                        })
//                    }
//                }
//                //Services.sharedInstance.dissMissLoader()
//            }
        }
        )
    }
    
    
}
