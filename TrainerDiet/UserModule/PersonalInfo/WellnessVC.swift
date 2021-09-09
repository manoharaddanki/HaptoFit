//
//  WellnessVC.swift
//  Dieatto
//
//  Created by Developer Dev on 18/04/20.
//  Copyright © 2020 Developer Dev. All rights reserved.
//

import UIKit

class WellnessVC: UIViewController {

    @IBOutlet var shadowView: UIView!
    @IBOutlet var slider1: UISlider!
    @IBOutlet var slider2: UISlider!
    @IBOutlet var slider3: UISlider!
    @IBOutlet var slider4: UISlider!
    @IBOutlet var slider5: UISlider!
    @IBOutlet var slider6: UISlider!

    @IBOutlet weak var continueBtn: UIButton!
    
    
    var wellnessScore = Int(), sliderVal1 = 1,sliderVal2 = 1,sliderVal3 = 1,sliderVal4 = 1, sliderVal5 = 1, sliderVal6 = 1

    var currentDate = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      shadowView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 20.0)
        
           let date = Date()
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
           currentDate = formatter.string(from: date)
           
               slider1.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
               slider2.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
               slider3.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
               slider4.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
               slider5.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
               slider6.setThumbImage(UIImage(named: "sliderCircle"), for: .normal)
        
        print("personal Info Dict ==>\(SubPersonalDict.personalDict)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true

    }
    
    @IBAction func slider1BtnAction(_ sender: Any) {
        
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
    
    @IBAction func slider2BtnAction(_ sender: Any) {
        

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
    
    
    @IBAction func slider3BtnAction(_ sender: Any) {
        
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
    
    @IBAction func slider4BtnAction(_ sender: Any) {
        
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
    
    @IBAction func slider5BtnAction(_ sender: Any) {
        
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
    @IBAction func slider6BtnACtion(_ sender: Any) {
        
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
    
       func enableContinueBtn(){
           
           
           if self.sliderVal1 == 1 || self.sliderVal2 == 1 || self.sliderVal3 == 1 || self.sliderVal4 == 1 || self.sliderVal5 == 1 || self.sliderVal6 == 1 {
               
               self.continueBtn.setBackgroundImage(UIImage(named: "Rectangle -1"), for: .normal)
               
           }else{
               
               self.continueBtn.setBackgroundImage(UIImage(named: "Rectangle -3"), for: .normal)
               
           }
       }
    
    @IBAction func continueBtnAction(_ sender: UIButton) {
        
        
        let result = (self.sliderVal1 + self.sliderVal2 + self.sliderVal3 + self.sliderVal4 + self.sliderVal5 + self.sliderVal6)
        self.wellnessScore = Int((Double(result)/Double(30))*100)
        print("result by 30 is==\(self.wellnessScore)")

        SubPersonalDict.personalDict["wellness_q1"] = self.sliderVal1
        SubPersonalDict.personalDict["wellness_q2"] = self.sliderVal2
        SubPersonalDict.personalDict["wellness_q3"] = self.sliderVal3
        SubPersonalDict.personalDict["wellness_q4"] = self.sliderVal4
        SubPersonalDict.personalDict["wellness_q5"] = self.sliderVal5
        SubPersonalDict.personalDict["wellness_q6"] = self.sliderVal6
        SubPersonalDict.personalDict["wellnessScore"] = self.wellnessScore
        print("personal dict is ==>\(SubPersonalDict.personalDict)")

        wellnessScoreHandlerMethod(score: self.wellnessScore)

    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }

    
    func wellnessScoreHandlerMethod(score : Int) {
           
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")

        let subId = UserDefaults.standard.object(forKey: "subId") as? Int
        
        let params = ["subId":"\(subId!)","wellness_q1" :self.sliderVal1,"wellness_q2":self.sliderVal2,"wellness_q3":self.sliderVal3,"wellness_q4":self.sliderVal4,"wellness_q5":self.sliderVal5,"wellness_q6":self.sliderVal6,"wellnessScore": self.wellnessScore] as [String : Any]
           
        print("Stress params == >\(params)")
        let urlString = "https://beapis.dieatto.com:8090/dao/wellnessscore/updateWellness"
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

            
//            let wellnessScore = Int((Double(self.wellnessScore) / 30) * (100))
              //UserDefaults.standard.set(score, forKey: "wellnessScore")
//            UserDefaults.standard.set(self.currentDate, forKey: "wellNessDate")

            let dict = dict_responce(dict: response)
                           
            if dict.value(forKey: "status") as? Int == 500 {
                               
                
                               
            }else{
            
                self.showToast(message: "Submitted successfully")
                //UserDefaults.standard.set(score, forKey: "wellnessScore")

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {

                self.navigationController?.popViewController(animated: true)
               
                    }
            }

           }
           )
       }
    
}
