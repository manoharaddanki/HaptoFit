//
//  WorkoutTrackerVC.swift
//  TrainerDiet
//
//  Created by Sunkpo on 15/11/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

class WorkoutTrackerVC: UIViewController {
    
    @IBOutlet weak var mainView:UIView!

    @IBOutlet weak var sleepView:UIView!
    @IBOutlet weak var sleepTitleLbl:UILabel!
    @IBOutlet weak var sleepImgView:UIImageView!
    
    @IBOutlet weak var stressView:UIView!
    @IBOutlet weak var stressTitleLbl:UILabel!
    @IBOutlet weak var stressImgView:UIImageView!
    
    @IBOutlet weak var wellnessView:UIView!
    @IBOutlet weak var wellnessTitleLbl:UILabel!
    @IBOutlet weak var wellnessImgView:UIImageView!
    
    var progressRing: CircularProgressBar!
        
    var sleepScore = Int()
    var stressScore = Int()
    var wellnessScore = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let xPosition = view.center.x
        let yPosition = view.center.y - 100
        let position = CGPoint(x: xPosition, y: yPosition)
        
        progressRing = CircularProgressBar(radius: 100, position: position, innerTrackColor: .defaultInnerColor, outerTrackColor: .defaultOuterColor, lineWidth: 10)

        mainView.layer.addSublayer(progressRing)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
         wellnessScore = UserDefaults.standard.object(forKey: "wellnessScore") as? Int ?? 0
         stressScore = UserDefaults.standard.object(forKey: "stressScore") as? Int ?? 0
         sleepScore = UserDefaults.standard.object(forKey: "sleepScore") as? Int ?? 0
         progressRing.progress = CGFloat(sleepScore)

    }
    
    @IBAction func sleepBtnAction(_ sender: UIButton) {
        
        progressRing.progress = CGFloat(sleepScore)

        self.sleepView.backgroundColor = UIColor.white
        self.sleepTitleLbl.textColor = UIColor.init(hexFromString: "31C8C4")
        self.sleepImgView.tintColor = UIColor.init(hexFromString: "31C8C4")
        
        self.wellnessView.backgroundColor = UIColor.init(hexFromString: "31C8C4")
        self.wellnessTitleLbl.textColor = UIColor.white
        self.wellnessImgView.tintColor = UIColor.white
        
        self.stressView.backgroundColor = UIColor.init(hexFromString: "31C8C4")
        self.stressTitleLbl.textColor = UIColor.white
        self.stressImgView.tintColor = UIColor.white

        
    }
    
    @IBAction func stressBtnAction(_ sender: UIButton) {
        
        progressRing.progress = CGFloat(stressScore)
        
        self.sleepView.backgroundColor = UIColor.init(hexFromString: "31C8C4")
        self.sleepTitleLbl.textColor = UIColor.white
        self.sleepImgView.tintColor = UIColor.white
        
        self.wellnessView.backgroundColor = UIColor.init(hexFromString: "31C8C4")
        self.wellnessTitleLbl.textColor = UIColor.white
        self.wellnessImgView.tintColor = UIColor.white
        
        self.stressView.backgroundColor = UIColor.white
        self.stressTitleLbl.textColor = UIColor.init(hexFromString: "31C8C4")
        self.stressImgView.tintColor = UIColor.init(hexFromString: "31C8C4")

    }
    
    @IBAction func wellnessBtnAction(_ sender: UIButton) {
        
        progressRing.progress = CGFloat(wellnessScore)
        
        self.sleepView.backgroundColor = UIColor.init(hexFromString: "31C8C4")
        self.sleepTitleLbl.textColor = UIColor.white
        self.sleepImgView.tintColor = UIColor.white
        
        self.wellnessView.backgroundColor = UIColor.white
        self.wellnessTitleLbl.textColor = UIColor.init(hexFromString: "31C8C4")
        self.wellnessImgView.tintColor = UIColor.init(hexFromString: "31C8C4")
        
        self.stressView.backgroundColor = UIColor.init(hexFromString: "31C8C4")
        self.stressTitleLbl.textColor = UIColor.white
        self.stressImgView.tintColor = UIColor.white

    }
}

extension UIColor {
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
    static let defaultOuterColor = UIColor.rgb(118, 214, 255, alpha: 0.8)
    static let defaultInnerColor: UIColor = .rgb(72, 123, 214 , alpha: 1)
    static let defaultPulseFillColor = UIColor.rgb(86, 30, 63, alpha: 1)
}
